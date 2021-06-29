#!/bin/bash
#SBATCH -J pwscf        # Job Name
#SBATCH -o pwscf.out.%j  # output and error file name (%j expands to jobID) Name of the output file (eg. myMPI.oJobID)
#SBATCH -n 1         # number of tasks per node per node
#SBATCH -N 1         # total number of nodes requested
#SBATCH -p small              # Queue name
#SBATCH -t 48:00:00       # Run time (hh:mm:ss) - 0.25 hours (max is 48 hours)
#SBATCH --mail-user=sc2329@cornell.edu    # Email notification address MAKE THIS YOURS, PLEASE
#SBATCH --mail-type=ALL                  # Email at Begin/End of job  (UNCOMMENT)
#SBATCH -A MRSEC-REU



### get current dir to copy output file
beginDir=$(pwd)

### staging files for copy to scratch
FOLDERPATH=$SCRATCH/qe/$FOLDERNAME 
mkdir $FOLDERPATH
cp -r * $FOLDERPATH
cd $FOLDERPATH


### running desired calculations, postprocessing
module load qe/6.6
MKL_NUM_THREADS=8
ibrun pw.x -input Fe.scf
ibrun pw.x -input Fe.nscf
wannier90.x -pp Fe
pw2wannier90.x -input Fe.pw2wan
ibrun wannier90.x Fe
postw90.x Fe

### copy files back to output folder
cp $beginDir/*.out.* ./
cd ../
cp -r $FOLDERPATH $dftOutputPath
