#!/bin/bash 
#SBATCH -J projwfc                               # define the job name
#SBATCH -o projwfc.%j.out                        # define stdout & stderr output files 
#SBATCH -e projwfc.%j.err 
#SBATCH -N 1                             # request 4 nodes 
#SBATCH -n 16                            # 256 total tasks = 64 tasks/node
#SBATCH -p normal                           # submit to "normal" queue 
#SBATCH -t 01:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu,suyogya.karki@utexas.edu
#SBATCH --mail-type=end   # email me when the job starts and end
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
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond

#export MKL_DYNAMIC=false
#export OMP_NESTED=true
#export OMP_NUM_THREADS=8 
#export MKL_NUM_THREADS=8

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/2ndcompile-qe/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/2ndcompile-qe/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond
#export MKL_DYNAMIC=false
#export OMP_NESTED=true
#export OMP_NUM_THREADS=20 
#export MKL_NUM_THREADS=1
#omp_set_max_active_levels(2)


ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/qe-5compile/q-e-qe-6.4.1/bin/projwfc.x -input input.projwfc

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/qe-3compile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond 

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond
#ibrun pwcond.x -input input.spin_up.cond
# post processing


folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp * /work/06640/wrogers/mysharedirectory/vivqe/$folder

