#!/usr/bin/env tclsh

# @IJB This is stupid. I wrote this with 8.6 in mind, but 8.5 doesnt have lmap
if { [info tclversion] < 8.6 } {
  # Shamelessly stolen from https://en.wikibooks.org/wiki/Tcl_Programming/Examples
  proc lmap {_var list body} {
    upvar 1 $_var var
    set res {}
    foreach var $list {lappend res [uplevel 1 $body]}
    set res
  }
}

# Expand command line arguments to individual variables
lassign $argv suite P Q R T upload

# Shamelessly stolen from: https://wiki.tcl-lang.org/page/Generating+random+strings
proc randomRangeString {length {chars "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"}} {
    set range [expr {[string length $chars]-1}]

    set txt ""
    for {set i 0} {$i < $length} {incr i} {
       set pos [expr {int(rand()*$range)}]
       append txt [string range $chars $pos $pos]
    }
    return $txt
}

#Get absolute path to the benchmarks directory
set path_to_benchmarks [file dirname [file normalize [info script]]]
set assets_dir [file join $path_to_benchmarks assets]

# absolute path to suite_dir (with no trailing slashes)
set suite_dir [file normalize $suite ]
set suite_assets [file join $suite_dir assets ]
set suite_outputs [file join $suite_dir outputs ]

source [ file join $suite_assets tests.tcl ]
source [ file join $suite_assets test_config.tcl ]

# Timestamp (month-day-year(4 digit)_24hours-minute-seconds)
set time_stamp [clock format [clock seconds] -format %m-%d-%Y_%H-%M-%S]
# Random 5 character alpha-numeric string
set rand_suffix [randomRangeString 5]
set unique_name "${time_stamp}_${rand_suffix}"
set unique_dir [file join $suite_outputs $unique_name]
puts "Test files located at [file join [file tail $suite] outputs $unique_name]"

# Full paths to framework assets
set test_framework_assets [lmap i [glob -directory $assets_dir * ] {file join $assets_dir $i} ]
# Full paths to suite assets
set test_suite_assets [lmap i [glob -directory [file join $suite_dir assets] * ] { file join $suite_dir $i } ]

# If suite's output directory does not already exist, create it
if { ![file exists $suite_outputs] } {
  file mkdir $suite_outputs
}
# Create (hopefully) unique directory for this execution of the test suite
file mkdir $unique_dir

# Copy all necessary test framework assets
# possible modes:
#   copy: Literally copy all files and directories
#   link: Link all
set asset_mode "copy"
# TODO figure out how to do recreate directory structure and create file links
if { $asset_mode == "copy" } {
  file copy -force {*}[concat $test_framework_assets $test_suite_assets] $unique_dir
} elseif { $asset_mode == "link" } {
  foreach asset [concat $test_framework_assets $test_suite_assets] {
    # Link absolute path to asset to $unique_dir/filename
    # This reduces the amount of replicated data on disk, which can be substantial
    # Assumes that assets are immutable
    file link [file join $unique_dir [file tail $asset]] $asset
  }
} else {
  puts "Invalid asset_mode setting: $asset_mode"
  exit
}

# Delete any existing solver configuration directories (this is now unnecessary)
# Copy appropriate solver configurations
foreach dir $solver_configs {
  file delete -force -- [file join $unique_dir $dir]
  file copy -force [file join solver_configs $dir] [file join $unique_dir $dir]
}

# Move into test directory and execute tests
cd $unique_dir

puts "running"
exec tclsh run_tests.tcl $P $Q $R $T $upload >@stdout
