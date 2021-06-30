#!/bin/bash 
#SBATCH -J bands.x                               # define the job name
#SBATCH -o bands.%j.out                        # define stdout & stderr output files 
#SBATCH -e bands.%j.err 
#SBATCH -N 4                              # request 4 nodes 
#SBATCH -n 40                             # 256 total tasks = 64 tasks/node
#SBATCH -p gpu                           # submit to "normal" queue 
#SBATCH -t 24:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu,suyogya.karki@utexas.edu
#SBATCH --mail-type=ALL   # email me when the job starts and end
#SBATCH -A Spintronic-Computing

module load qe/6.2                 # setup environment
ibrun pw.x -input input.bands    # calculates bands ..?

# post processing

ibrun bands.x -input input.bandcreate   # makes the nice bands.dat files

gnuplot /work/06640/wrogers/qsims/scripts  # makes the band structure plot
