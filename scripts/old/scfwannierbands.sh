#!/bin/bash 
#SBATCH -J qe-scf                               # define the job name
#SBATCH -o qe-scf.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe-scf.%j.err 
#SBATCH -N 4                              # request 4 nodes 
#SBATCH -n 8                             # 256 total tasks = 64 tasks/node
#SBATCH -p normal                            # submit to "normal" queue 
#SBATCH -t 48:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu 
#SBATCH --mail-type=ALL   # email me when the job starts and end
#SBATCH -A Spintronic-Computing

#module load qe/6.2            # setup environment




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

#load-qe-cpu
#brun pw.x -input input.barrier.scf



#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/q-e-qe-6.4.1/bin/pw.x -input input.scf


MKL_NUM_THREADS=12
module load qe/6.6
ibrun pw.x -input input.scf
ibrun open_grid.x < input.opengrid > opengrid.out
awk '/wannier90/{flag=1;next}/OPEN_GRID    :/{flag=0}flag' opengrid.out >kpoints.dat

#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pw.x -input input.barrier.scf
#/work/06640/wrogers/mysharedirectory/qe-edited/qe-newcompile/q-e-qe-6.4.1/bin/open_grid.x < input.opengrid > opengrid.out
#awk '/wannier90/{flag=1;next}/OPEN_GRID    :/{flag=0}flag' opengrid.out > kpoints.dat
# post processing


folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp -r ./* /work/06640/wrogers/mysharedirectory/vivqe/$folder
#cd /work/06640/wrogers/qsims/ScN/$date
#touch bands_$date_.log bandcreate_$date_.log scf_$date_.log nscf_$date_.log

