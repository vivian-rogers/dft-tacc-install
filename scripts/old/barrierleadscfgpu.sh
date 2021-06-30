#!/bin/bash 
#SBATCH -J qe-scf                               # define the job name
#SBATCH -o qe-scf.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe-scf.%j.err 
#SBATCH -N 2                              # request 4 nodes 
#SBATCH -n 10                             # 256 total tasks = 64 tasks/node
#SBATCH -p gpu                            # submit to "normal" queue 
#SBATCH -t 24:00:00                          # run for 4 hours max 
#SBATCH --mail-user=vivian.rogers@utexas.edu,suyogya.karki@utexas.edu
#SBATCH --mail-type=ALL   # email me when the job starts and end
#SBATCH -A Spintronic-Computing

#module unload qe                # setup environment


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

ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-gpu-qe-gpu-6.4.1a1/bin/pw.x -input input.lead_down.scf
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-gpu-qe-gpu-6.4.1a1/bin/pw.x -input input.lead_up.scf
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-gpu-qe-gpu-6.4.1a1/bin/pw.x -input input.barrier.scf
# post processing


folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp -r * /work/06640/wrogers/mysharedirectory/vivqe/$folder
#cd /work/06640/wrogers/qsims/ScN/$date
#touch bands_$date_.log bandcreate_$date_.log scf_$date_.log nscf_$date_.log

