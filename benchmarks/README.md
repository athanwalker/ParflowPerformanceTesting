# ParFlow Solver Configuration Testing

## INDEX
 * [Overview](#overview)
 * [Quickstart](#quickstart)
 * [Install and Configure Parflow for ParflowPerformanceTesting](#install-and-configure-parflow-for-parflowperformancetesting)
 * [Upload Setup](#upload-setup)
 * [To Add a New Domain](#to-add-a-new-domain)
 * [To Add or Change Solver Configurations for a Domain](#to-add-or-change-solver-configurations-for-a-domain)
 * [To Delete Test Logs](#to-delete-test-logs)
 * [Included Files](#included-files)
 * [Getting Started with Docker on Mac](#getting-started-with-docker-on-mac)


## OVERVIEW

 The performance test framework allows a user to run various domains against several solver configurations 
 in single or batch runs. Statistics will be gathered at the end of each domain simulation.


## QUICKSTART

 You must have Parflow installed and an environment variable named $PARFLOW_DIR which points to the directory where the
 bin folder is located (standard Parflow requirements).

 Python 3.4+ for post test validation

 /usr/bin/time available

 To run all the test cases for a Domain, from this folder run
 ```bash
 $ tclsh exec_test_suite.tcl domainName P Q R T U
 ```
 where domainName is the name of a Domain SubFolder and P Q R are integers which define the computation grid,
 T is the StopTime you want the simulation to use, and U is an integer specifying to upload the results or not.

 From this directory, run:
 ```
 $ tclsh exec_test_suite.tcl LW 1 1 1 12 0
 ```

 [NEXT LIST NECESSITIES FOR MINICONDA AND MONGODB]

## Install and Configure Parflow for ParflowPerformanceTesting
 
 Verify environment variable **LD_LIBRARY_PATH** is set to a **v11 lib64** library.

 Install Hypre by following Parflow's [Dockerfile instructions regarding Hypre](https://github.com/parflow/parflow/blob/master/Dockerfile).
 Create environment variable **HYPRE_DIR** set to the **path** of the installed **hypre** directory which 
 contains directories **include** and **lib**.
 
 Follow installation instructions from [Parflow](http://github.com/parflow/parflow).

 The ```cmake``` configuration of Parflow must at least contain the following arguments/options:
 * ```-DCMAKE_INSTALL_PREFIX=${PARFLOW_DIR}```
 * ```-DPARFLOW_HAVE_CLM=ON ```
 * ```-DPARFLOW_AMPS_LAYER=mpi1```
 * ```-DPARFLOW_ENABLE_TIMING=TRUE```
 * ```-DCMAKE_BUILD_TYPE=Release```
 * ```-DHYPRE_ROOT=${HYPRE_DIR}```

 ```cmake``` **must** find the Hypre library.

 Details of **PARFLOW_DIR** in [Parflow](http://github.com/parflow/parflow).


## Upload Setup

 Obtain and unzip **connection_strings.zip** and set environment variable **MONGO_ENVIRONMENT** to the path 
 leading directly too **upload_mongostring.txt** (file from connection_strings.zip).

 Install [miniconda](https://docs.conda.io/en/latest/miniconda.html). Create a new virtual environment
 ```conda create --name <name> python=<version of python>``` then activate it:
 * WINDOWS: ```activate <name>```
 * LINUX, macOS: ```source activate <name>```

 While the environment is activated, install the necessary dependencies ```conda install pymongo pandas numpy dnspython```
 
 For more information on conda commands see [conda cheat sheet](https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf). 

 [NOTE WHEN SETTING UP ```<version of python>``` NEEDS TO BE 3.7.6 OTHERWISE UPLOAD FAILS]
 

## TO ADD A NEW DOMAIN
 
 Each new domain should be added as a Domain SubFolder to the main test directory. 
 Test cases are defined as folders in the Domain SubFolder and require a solver_params.tcl file.
 A domain run script (DomainName.tcl) should be edited to use supplied parameters for P Q R T.
 Additional modifications to DomainName.tcl required:
 * Comment out existing settings for solver configurations set by solver_params.tcl
 * Create a caseDefault test folder and place the original solver configurations in the solver_params.tcl there.
 * Copy any other test folders from existing test domain into new domain
 * Move the validation portion of the script to the validate_results.tcl script.
 * Insert the following code block to set the solver configurations at runtime: 
 ```tcl
 
 set runname <domainname>
 
 source solver_params.tcl

 #-----------------------------------------------------------------------------
 # StopTime
 #-----------------------------------------------------------------------------
 set StopTime [lindex $argv 3]

 #-----------------------------------------------------------------------------
 # Set Processor topology 
 #-----------------------------------------------------------------------------
 pfset Process.Topology.P        [lindex $argv 0]
 pfset Process.Topology.Q        [lindex $argv 1]
 pfset Process.Topology.R        [lindex $argv 2]
 
 pfset TimingInfo.StopTime        $StopTime
 
 
 ###Test Settings
 pfset Solver.Nonlinear.UseJacobian                       $UseJacobian 
 pfset Solver.Nonlinear.EtaValue                          $EtaValue
 pfset Solver.Linear.Preconditioner                       $Preconditioner

 if {[info exists PCMatrixType]} {
	pfset Solver.Linear.Preconditioner.PCMatrixType          $PCMatrixType
 }

 if {[info exists MaxIter]} { 
   pfset Solver.Linear.Preconditioner.$Preconditioner.MaxIter         $MaxIter
 }

 if {[info exists MaxLevels]} { 
   pfset Solver.Linear.Preconditioner.$Preconditioner.MaxLevels         $MaxLevels
 }

 if {[info exists Smoother]} { 
   pfset Solver.Linear.Preconditioner.$Preconditioner.Smoother         $Smoother
 }

 if {[info exists RAPType]} {
   pfset Solver.Linear.Preconditioner.$Preconditioner.RAPType          $RAPType
 }
 ```
 * add the following to the .gitignore:
 ```
 <domainname>/**/solver_params.tcl
 ```


## To Add or Change Solver Configurations for a Domain

 Modify the list of solver configurations defined in the subdomain's test.tcl file. 

 For example, clayl/tests.tcl


## To Delete Test Logs

 Use the purge_log_files.tcl script to remove log files for all subdomains.


## INCLUDED FILES

                                  |---collect_stats.tcl
                                  |---delete_logs.tcl
                                  |---pfbdiff.py
                     |---assets---|---pftest.tcl
                     |            |---post_run_uploader.py
                     |            |---purge_log_files.tcl
                     |            |---run_test.tcl
                     |            |---run_tests.tcl
                     |
                     |                                    |---DomainName.tcl
                     |---Domain SubFolders---|---assets---|---test_config.tcl
                     |                       |            |---tests.tcl
                     |                       |            |---validate_results.tcl
                     |                       |
                     |                       |---resuts.csv
                     |
        benchmarks---|---solver_configs---caseXX---solver_params.tcl 
                     |
                     |---.gitignore
                     |
                     |---Dockerfile
                     |
                     |---README.md
                     |
                     |---exec_test_suite.tcl
                     |
                     |---solver_configs---caseXX---solver_params.tcl

 [BELOW FILES/DESCRIPTIONS MAY BE OUT OF DATE???]

 * solver_configs/caseXX/solver_params.tcl - Solver configuration to apply for this test
 * collect_stats.tcl - script to collect stats from all the test cases in a domain
 * purge_log_files.tcl - script to purge all the log files generated from a run
 * exec_test_suite.tcl - wrapper script to run all tests in a domain from root of test directory
 * run_test.tcl - script to run a single solver configuration for a test domain
 * run_tests.tcl - wrapper script to run all tests for a domain from within domain directory
 * README.md - this file
 * pfbdiff.py - python script to compare output files for differences
 * Domain SubFolders - Each problem domain is given its own folder
 * Domain SubFolders/tests.tcl - Defines the set of solver configurations to use for this test domain
 * Domain SubFolders/DomainName.tcl - adapted TCL script to use when testing
 * Domain SubFolders/results.csv - the collected results from the
 * Domain SubFolders/test_config.tcl - Domain specific information, where to find the test directory, runname, etc.
 * Domain SubFolders/validate_results.tcl - Script to run any post test validations of output data


## GETTING STARTED WITH DOCKER ON MAC
 Install parflow_docker:
 ```
 git clone https://github.com/parflow/docker parflow_docker
 ```

 Install Docker:
 ```
 https://docs.docker.com/docker-for-mac/install
 ```

 Clone this hydroframe/ParflowPerformanceTesting directory:
 ```
 git clone https://github.com/hydroframe/ParflowPerformanceTesting.git
 ```

 ```cd``` into ```ParflowPerformanceTesting/benchmarks```

 Build the docker image using the version of parflow you want (for latest you can just say ```:latest-x.x.x``` instead of ```:version-x.x.x```):
 ```
 docker build --tag <[meaningful_tag_name][:version-x.x.x]> .
 ```

 Here is an example of a meaningful tag name:
 ```
 parflow37:version-3.6.0
 ```

 To see if the installation was successful, run the test suite for LW on 1 core, for 12 time steps:
 ```
 docker run -it --rm -v $(pwd):/data <[meaningful_tag_name][:version-x.x.x]> exec_test_suite.tcl LW 1 1 1 12 0
 ```

 For information on argument and option meanings from ```docker run...``` read [Quickstart](#quickstart)

 Currently to upload results download ```connection_strings.zip```[NOTE: ADDRESS WHERE TO GET THIS OR IF THERE WILL BE A FIX TO THE UPLOAD] and paste ```upload_mongostring.txt``` anywhere under the benchmarks folder. Lastly, run:
 ```
 docker run -it --rm -v $(pwd):/data -e MONGO_CONNECTION='/data/pathtotxtfileunderbenchmarks/upload_mongostring.txt' <docker container name> exec_test_suite.tcl LW 1 1 1 12 1
 ```

 Where:
 * ```data``` is ```/benchmarks```
 * ```pathtotxtfileunderbenchmarks``` is the path from ```/data``` to ```upload_mongostring.txt```
 * ```<docker container name>``` is the same as your previously created ```<[meaningful_tag_name][:version-x.x.x]>```
