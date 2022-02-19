

### get current dir to copy output file
beginDir=$(pwd)
FOLDERNAME=$1
FILENAME=$2
dftOutputPath=$3



### staging files for copy to scratch
FOLDERPATH=$SCRATCH/qe/$FOLDERNAME 
mkdir $FOLDERPATH
cp -r * $FOLDERPATH
cd $FOLDERPATH


### running desired calculations, postprocessing
#module load qe/6.6


#export PATH=/home/viv/dft-tacc-install/:$PATH


#MKL_NUM_THREADS=4

#mpirun  pw.x -input $FILENAME

#mpirun -np 4 $QEpath/pw.x -input $FILENAME.scf
#mpirun -np 4 $QEpath/pw.x -input $FILENAME.nscf
#mpirun -np 4 $QEpath/pw.x -input $FILENAME.bands
#mpirun -np 4 $QEpath/bands.x -input $FILENAME.bandcreate
bash $FILENAME.sh
#mpirun -np 4 $QEpath/pw.x -input $FILENAME.scf > scf.$FILENAME.out
#mpirun -np 4 $QEpath/pw.x -input $FILENAME.nscf > nscf.$FILENAME.out
#mpirun -np 4 $QEpath/pw.x -input $FILENAME.bands > bands.$FILENAME.out
#mpirun -np 4 $QEpath/bands.x -input $FILENAME.bandcreate > bandcreate.$FILENAME.out


#mpirun pw.x -np 4 –i $

### copy files back to output folder
cp $beginDir/*.out.* ./
cd ../
cp -r $FOLDERPATH $dftOutputPath
