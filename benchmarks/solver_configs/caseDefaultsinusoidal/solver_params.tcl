
set case_dir defaultCase

# NOTE: Adapted from caseDefaultclayl

#-----------------------------------------------------------------------------
# Preconditioner Options (NoPC MGSemi PFMG PFMGOctree SMG)
#-----------------------------------------------------------------------------
set Preconditioner PFMG

#-----------------------------------------------------------------------------
# UseJacobian Options (True False)
#-----------------------------------------------------------------------------
set UseJacobian True

#-----------------------------------------------------------------------------
# Smoother Options (Jacobi WJacobi RBGaussSeidelSymmetric
#                       RBGaussSeidelNonSymmetric)
#-----------------------------------------------------------------------------
#set Smoother WJacobi

#-----------------------------------------------------------------------------
# RAPType Options (Galerkin NonGalerkin)
#-----------------------------------------------------------------------------
#set RAPType Galerkin

#-----------------------------------------------------------------------------
# PCMatrixType Options (FullJacobian PFSymmetric SymmetricPart Picard)
#-----------------------------------------------------------------------------
#set PCMatrixType FullJacobian

#-----------------------------------------------------------------------------
# EtaValue Options (0.001 0.01 1e-5)
#-----------------------------------------------------------------------------
set EtaValue 0.001

#-----------------------------------------------------------------------------
# MaxIter Options (1,10...)
#-----------------------------------------------------------------------------
set MaxIter 1

#-----------------------------------------------------------------------------
# MaxLevels Options (10,100...)
# NOTE: Unused in sinusoidal
#-----------------------------------------------------------------------------
set MaxLevels 10
