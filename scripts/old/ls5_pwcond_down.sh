#!/bin/bash 
#SBATCH -J pwcond-down                               # define the job name
#SBATCH -o pwcond-down.%j.out                        # define stdout & stderr output files 
#SBATCH -e pwcond-down.%j.err 
#SBATCH -N 1                              # request 4 nodes 
#SBATCH -n 16                             # 256 total tasks = 64 tasks/node
#SBATCH -p normal                           # submit to "normal" queue 
#SBATCH -t 48:00:00                          # run for 4 hours max 
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
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/2ndcompile-qe/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/2ndcompile-qe/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond

#module load remora
#export MKL_DYNAMIC=false
#export OMP_NESTED=true
#export OMP_NUM_THREADS=20 
#export MKL_NUM_THREADS=1
#omp_set_max_active_levels(2)


#export MKL_NUM_THREADS=1 
#export OMP_NUM_THREADS=64


#change this path to the binary folder of your qe install!!!!!


ibrun /work/06640/wrogers/mysharedirectory/qe-edited/pwcond-scattering/documentation/qe-build/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/qe-5compile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond


#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/qe-3compile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond 

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_down.cond


#ibrun pwcond.x -input input.spin_down.cond
# post processing


folder=${PWD##*/}

#change these paths to where you want the output to go
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder-spindown
cp * /work/06640/wrogers/mysharedirectory/vivqe/$folder-spindown

