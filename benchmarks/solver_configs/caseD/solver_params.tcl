set case_dir caseD

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
set Smoother WJacobi

#-----------------------------------------------------------------------------
# RAPType Options (Galerkin NonGalerkin)
#-----------------------------------------------------------------------------
set RAPType NonGalerkin

#-----------------------------------------------------------------------------
# PCMatrixType Options (FullJacobian PFSymmetric SymmetricPart Picard)
#-----------------------------------------------------------------------------
set PCMatrixType PFSymmetric

#-----------------------------------------------------------------------------
# EtaValue Options (0.001 0.01 1e-5)
#-----------------------------------------------------------------------------
set EtaValue 0.001
 
