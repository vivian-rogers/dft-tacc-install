#bash clean.sh
printf "======================================================================\n"
printf "              Q-E, WannierTools, SIESTA  TACC INSTALLER               \n"
printf "======================================================================\n"
printf "                                                                      \n"

mkdir projects
mkdir install
printf "Need QE 6.4.1 with Sc Hubbard +U? Enter 1 or 0 for yes or no: "
read booltest
if (($booltest == 1 )); then
	cd ./install
	tar -xvzf  
	#configure, make, etc
	cd ../
fi
cd install

echo "Downloading q-e..."
#git clone https://github.com/QEF/q-e.git
cd q-e

echo "Installing q-e..."
export ARCH=x86_64
export F77=ifort
export MPIF90=mpif90
export CC=icc
export LD_LIBS="-Wl,--as-needed -liomp5 -Wl,--no-as-needed"
export LDFLAGS="-Wl,--as-needed -liomp5 -Wl,--no-as-needed"
export DFLAGS="-D__OPENMP -D__INTEL -D__DFTI -D__MPI -D__PARA -D__SCALAPACK -D__USE_MANY_FFT -D__NON_BLOCKING_SCATTER -D__EXX_ACE"
export FFLAGS="-O3 -fp-model precise -assume byterecl -qopenmp"
#export FFLAGS="-O3 -xCORE-AVX2 -axMIC-AVX512,CORE-AVX512 -fp-model precise -assume byterecl -qopenmp"
export IFLAGS="-I../include/ -I${MKLROOT}/include -I../FoX/finclude -I../../FoX/finclude"
export BLAS_LIBS=" -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl"
export LAPACK_LIBS="${BLAS_LIBS}"
export SCALAPACK_LIBS="-lmkl_scalapack_lp64 -lmkl_blacs_intelmpi_lp64"
export FFT_LIBS="${BLAS_LIBS}"

#configure and make
#./configure
#make pw pwcond pp w90

cd bin
pre="export PATH="
execpath=$(pwd)
post=":\$PATH"
pathexport="$pre$execpath$post"
echo "####  DFT ALIASES BELOW  ####" >> ~/.bashrc 
echo $pathexport >> ~/.bashrc 
cd ../../

#compile options

if (1==0); then
echo "Downloading WannierTools..."
git clone https://github.com/quanshengwu/wannier_tools.git
cd src
echo "Installing WannierTools..."
module load impi
cat > Makefile <<EOF
OBJ =  module.o sparse.o wt_aux.o math_lib.o symmetry.o readHmnR.o inverse.o proteus.o \
       eigen.o ham_qlayer2qlayer.o psi.o unfolding.o rand.o \
  		 ham_slab.o ham_bulk.o ek_slab.o ek_bulk_polar.o ek_bulk.o \
       readinput.o fermisurface.o surfgreen.o surfstat.o \
  		 mat_mul.o ham_ribbon.o ek_ribbon.o \
       fermiarc.o berrycurvature.o \
  		 wanniercenter.o dos.o  orbital_momenta.o \
  		 landau_level_sparse.o landau_level.o lanczos_sparse.o \
		 berry.o wanniercenter_adaptive.o \
  		 effective_mass.o findnodes.o \
		 sigma_OHE.o sigma.o sigma_AHC.o \
       main.o

# compiler
F90  = mpiifort -fpp -DMPI -DINTELMKL -fpe3

INCLUDE = -I${MKLROOT}/include
WFLAG = -nogen-interface
OFLAG = -O3 -static-intel
FFLAG = $(OFLAG) $(WFLAG)
LFLAG = $(OFLAG)


# blas and lapack libraries
# static linking
LIBS = -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a \
        ${MKLROOT}/lib/intel64/libmkl_sequential.a \
        ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl

# dynamic linking
# LIBS = -L/${MKLROOT}/lib/intel64 -lmkl_core -lmkl_sequential -lmkl_intel_lp64 -lpthread
 
main : $(OBJ)
	$(F90) $(LFLAG) $(OBJ) -o wt.x $(LIBS)
	cp -f wt.x ../bin

.SUFFIXES: .o .f90

.f90.o :
	$(F90) $(FFLAG) $(INCLUDE) -c $*.f90

clean :
	rm -f *.o *.mod *~ wt.x

EOF

make

cd ../bin

pre="export PATH="
execpath=$(pwd)
post=":\$PATH"
pathexport="$pre$execpath$post"
echo "####  DFT ALIASES BELOW  ####" >> ~/.bashrc 
echo $pathexport >> ~/.bashrc 
cd ../../

echo "Downloading SIESTA..."
git clone https://gitlab.com/siesta-project/siesta.git
cd siesta-project
cd ./Obj

cat > arch.make <<EOF
# 
# Copyright (C) 1996-2016	The SIESTA group
#  This file is distributed under the terms of the
#  GNU General Public License: see COPYING in the top directory
#  or http://www.gnu.org/copyleft/gpl.txt.
# See Docs/Contributors.txt for a list of contributors.
#
#-------------------------------------------------------------------
# arch.make file for intel compiler.
# To use this arch.make file you should rename it to
#   arch.make
# or make a sym-link.
# For an explanation of the flags see DOCUMENTED-TEMPLATE.make

.SUFFIXES:
.SUFFIXES: .f .F .o .c .a .f90 .F90

SIESTA_ARCH = unknown

FPP = $(FC) -E -P
CC = mpicc
FC = mpif90
MPI_INTERFACE = libmpi_f90.a
MPI_INCLUDE = .
FPPFLAGS += -DMPI




FFLAGS = -O2 -fPIC -fp-model source

AR = ar
RANLIB = ranlib

SYS = nag

SP_KIND = 4
DP_KIND = 8
KINDS = $(SP_KIND) $(DP_KIND)

LDFLAGS =

COMP_LIBS = libsiestaLAPACK.a libsiestaBLAS.a

FPPFLAGS = $(DEFS_PREFIX)-DFC_HAVE_ABORT

LIBS =

# Dependency rules ---------

FFLAGS_DEBUG = -g -O1 -fp-model source   # your appropriate flags here...

# The atom.f code is very vulnerable. Particularly the Intel compiler
# will make an erroneous compilation of atom.f with high optimization
# levels.
atom.o: atom.F
	$(FC) -c $(FFLAGS_DEBUG) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_fixed_F) $< 
state_analysis.o: state_analysis.F
	$(FC) -c $(FFLAGS_DEBUG) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_fixed_F) $< 

.c.o:
	$(CC) -c $(CFLAGS) $(INCFLAGS) $(CPPFLAGS) $< 
.F.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_fixed_F)  $< 
.F90.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_free_F90) $< 
.f.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FCFLAGS_fixed_f)  $<
.f90.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FCFLAGS_free_f90)  $<

EOF

make
fi

source ~/.bashrc
printf "Added QE executables to path in your .bashrc\n"
#cd ../

printf "Creating systems, outputs, and scripts folders...\n"
mkdir ../systems/
mkdir $SCRATCH/dft
mkdir ../systems/test/
mkdir ../outputs/
#cp -r ./scripts ../
#cp ./test.mx3 ../systems/test/





cd ../
pre="alias cddft='cd "
execpath=$(pwd)
post="'"
pathexport="$pre$execpath$post"
echo $pathexport >> ~/.bashrc
printf "Added 'cddft' as alias to cd into dft dir in .bashrc\n"


#cd ./dft-tacc-install/scripts/
cd ./scripts
pre="export PATH="
execpath=$(pwd)
post=":\$PATH"
pathexport="$pre$execpath$post"
echo $pathexport >> ~/.bashrc
printf "Added DFT scripts to path in your .bashrc\n"
cd ../

cd /outputs/
pre="export dftOutputPath="
execpath=$(pwd)
pwd
pathexport2="$pre'$execpath'"
echo $pathexport2 >> ~/.bashrc
printf "Added dft output path as dftOutputPath in your .bashrc\n"
source ~/.bashrc
printf "Applied source to your .bashrc\n"
printf "Install complete!\n"

printf "\nWould you like to queue a test simulation? ( 1 for yes, 0 for no): "
read booltest

if (($booltest == 1 )); then
	printf "\n=========== RUNNING TEST CODE ===========\n"
        printf "    cd-ing into /systems/test... \n\n"
	cd ../systems/test/
        printf "    list files in directory with 'ls -lt': "
        ls -lt
	printf "\n    typing 'bash mumax3.sh general-mumax3.sl test.mx3'\n"
	printf "    (this runs the wrapper script 'mumax3.sl' to call the slurm script 'general-mumax3.sl' with test.mx3)\n"
	printf "    (after which the results will be copied back into /outputs/ )\n"
        bash mumax3.sh general-mumax3.sl test.mx3
	printf "\n\nCongrats! if all of that worked, then you can go make your own systems now and run them :^)\n"
	printf "Have fun with your magnets\n"
fi

cd ../

