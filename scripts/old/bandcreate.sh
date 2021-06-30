#!/bin/bash 
#SBATCH -J qe-bands.x                               # define the job name
#SBATCH -o qe-bands.x.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe-bands.x.%j.err 
#SBATCH -N 1                              # request 4 nodes 
#SBATCH -n 16                             # 256 total tasks = 64 tasks/node
#SBATCH -p normal                           # submit to "normal" queue 
#SBATCH -t 2:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu
#SBATCH --mail-type=ALL   # email me when the job starts and end
#SBATCH -A Spintronic-Computing

#module load qe             # setup environment

ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/bands.x -input input.bandcreate   # makes the nice bands.dat files

folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp -r * /work/06640/wrogers/mysharedirectory/vivqe/$folder

#gnuplot /work/06640/wrogers/qsims/scripts/bandplot.gnu  # makes the band structure plot
