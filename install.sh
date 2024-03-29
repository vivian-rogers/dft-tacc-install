function addPath () {
	echo "Adding $(pwd) to path..."
	pre="export PATH="
	execpath=$(pwd)
	post=":\$PATH"
	pathexport="$pre$execpath$post"
	echo $pathexport >> ~/.bashrc 
}

function addPrefixPath () {
	echo "Assigning $(pwd) to $1..."
	pre="export $1='"
	execpath=$(pwd)
	post="'"
	pathexport="$pre$execpath$post"
	echo $pathexport >> ~/.bashrc 
}


#bash clean.sh
printf "======================================================================\n"
printf "              Q-E, WannierTools, SIESTA  TACC INSTALLER               \n"
printf "======================================================================\n"
printf "                                                                      \n"



echo "####  DFT ALIASES BELOW  ####" >> ~/.bashrc 
mkdir projects
#mkdir install
printf "Need QE 6.4.1 with Sc Hubbard +U? Enter 1 or 0 for yes or no: "
read booltest
#if (($booltest == 1 )); then
#	cd ./install
#	printf "\nThis may take a long time...\n\n"
#	echo "Go get a snack and relax!"
#	echo "What snack will you be consuming? (type your snack): "
#	read snack
#	wget https://www.utinclab.com/wp-content/uploads/2021/06/q-e-bigkgrid-sc-hubU-6.4.1.tar.gz
#	bash build641_xconfigure	
#	cd q-e-qe-6.4.1/bin
#	addPrefixPath qePathEdited
#	cd ../../	
#	#configure, make, etc
#	cd ../
#fi



# ADD LATER: SIESTA, WANNIERTOOLS
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



#cd ../

printf "Creating projects, outputs, and scripts folders...\n"
mkdir ./projects/
mkdir $SCRATCH/dft
mkdir $SCRATCH/qe
#mkdir ./projects/test
mkdir ./outputs/
#cp -r ./scripts ../
#mv ./test.scf ./projects/test/





#cd ../
pre="alias cddft='cd "
execpath=$(pwd)
post="'"
pathexport="$pre$execpath$post"
echo $pathexport >> ~/.bashrc
printf "Added 'cddft' as alias to cd into dft dir in .bashrc\n"


#cd ./dft-tacc-install/scripts/
cd ./scripts
addPath
cd ../


## adding dft output path to bashrc
echo "In folder outputs = $(pwd)"
cd ./outputs/
pre="export dftOutputPath="
execpath=$(pwd)
pwd
pathexport2="$pre'$execpath'"
echo $pathexport2 >> ~/.bashrc
printf "Added dft output path as dftOutputPath in your .bashrc\n"
cd ../

echo "Want to change the pwscf.sl file to your frontera allocation and email? (you do, type yes)"
read changefile
vim ./scripts/editedpwscf.sl
echo "Now for the other one (type 'okay fine')"
read changefile
vim ./scripts/pwscf.sl
#echo "While I have you here, I should recommend you to read 'The Dispossessed' by Ursula K Leguin"
#echo "What do you think? (type 'shutup viv')"
#read boolconvo
#echo 

source ~/.bashrc
printf "Applied source to your .bashrc\n"
printf "Install complete!\n"

printf "\nWould you like to queue a test simulation? ( 1 for yes, 0 for no): "
read booltest

if (($booltest == 1 )); then
	printf "\n=========== RUNNING TEST CODE ===========\n"
        printf "    cd-ing into /projects/co2scsb... \n\n"
	cd ./projects/co2scsb/
        printf "    list files in directory with 'ls -lt': "
        ls -lt
	printf "\n    typing 'bash dft.sh editedpwscf.sl input.scf'\n"
	printf "    (this runs the wrapper script 'dft.sh' to call the slurm script 'editedpwscf.sl' with input.scf)\n"
	printf "    (after which the results will be copied back into /outputs/ )\n"
        bash dft.sh editedpwscf.sl input.scf
	printf "\n\nCongrats! if all of that worked, then you can go make your own systems now and run them :^)\n"
fi

cd ../

