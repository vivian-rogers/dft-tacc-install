#!/bin/bash 
#SBATCH -J pwcond-0                               # define the job name
#SBATCH -o pwcond-0.%j.out                        # define stdout & stderr output files 
#SBATCH -e pwcond-0.%j.err 
#SBATCH -N 4                              # request 4 nodes 
#SBATCH -n 64                             # 256 total tasks = 64 tasks/node
#SBATCH -p normal                           # submit to "normal" queue 
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

# input.barrier.scf  input.lead_down.scf  input.lead_up.scf  input.spin_down.cond  input.spin_up.cond
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_0.cond
# post processing


folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder-spin0
cp -r * /work/06640/wrogers/mysharedirectory/vivqe/$folder-spin0

