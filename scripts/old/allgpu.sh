#!/bin/bash 
#SBATCH -J qe                               # define the job name
#SBATCH -o qe.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe.%j.err 
#SBATCH -N 4                              # request 4 nodes 
#SBATCH -n 16                             # 256 total tasks = 64 tasks/node
#SBATCH -p gpu                           # submit to "normal" queue 
#SBATCH -t 24:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu,suyogya.karki@utexas.edu
#SBATCH --mail-type=ALL   # email me when the job starts and end
#SBATCH -A Spintronic-Computing

#module load qe/6.2                 # setup environment


#date=$(date +"%H_%M-%F_all")
#mkdir /scratch/06640/wrogers/qe/$date 
#cp *.UPF /scratch/06640/wrogers/qe/$date 
#cp input.* /scratch/06640/wrogers/qe/$date 
#cp *.log /scratch/06640/wrogers/qe/$date
#cp -r *.save /scratch/06640/wrogers/qe/$date
#cp *.hub* /scratch/06640/wrogers/qe/$date
#cp *.wfc* /scratch/06640/wrogers/qe/$date
#pwd
#cd /scratch/06640/wrogers/qe/$date/
#pwd
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-gpu-qe-gpu-6.4.1a1/bin/pw.x -input input.scf      # do scf calculations
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-gpu-qe-gpu-6.4.1a1/bin/pw.x -input input.nscf     # do nscf calculations
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-gpu-qe-gpu-6.4.1a1/bin/pw.x -input input.bands    # calculates bands ..?

# post processing
#module load qe
 
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/bands.x -input input.bandcreate   # makes the nice bands.dat files

folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp -r * /work/06640/wrogers/mysharedirectory/vivqe/$folder
#cd /work/06640/wrogers/qsims/ScN/$date
#touch bands_$date_.log bandcreate_$date_.log scf_$date_.log nscf_$date_.log

