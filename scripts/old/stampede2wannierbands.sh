#!/bin/bash 
#SBATCH -J pwcond-up                               # define the job name
#SBATCH -o pwcond-up.%j.out                        # define stdout & stderr output files 
#SBATCH -e pwcond-up.%j.err 
#SBATCH -N 8                              # request 4 nodes 
#SBATCH -n 48                            # 256 total tasks = 64 tasks/node
#SBATCH -p skx-normal                           # submit to "normal" queue 
#SBATCH -t 48:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu
#SBATCH --mail-type=end   # email me when the job starts and end
#SBATCH -A Magnetic-Materials-M

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
export OMP_NUM_THREADS=8 
#export MKL_NUM_THREADS=8

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/2ndcompile-qe/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/2ndcompile-qe/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond
#export MKL_DYNAMIC=false
#export OMP_NESTED=true
#export OMP_NUM_THREADS=12
#export MKL_NUM_THREADS=
#omp_set_max_active_levels(2)

module load qe/6.6
ibrun pw.x -input input.scf
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/qe-stampede/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond


#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/qe-3compile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond 

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/q-e-qe-6.4.1/bin/pwcond.x -input input.spin_up.cond
#ibrun pwcond.x -input input.spin_up.cond
# post processing


folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp * /work/06640/wrogers/mysharedirectory/vivqe/$folder

