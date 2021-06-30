#!/bin/bash 
#SBATCH -J avg-workfunct                               # define the job name
#SBATCH -o avg.%j.out                        # define stdout & stderr output files 
#SBATCH -e avg.%j.err 
#SBATCH -N 1                              # request 4 nodes 
#SBATCH -n 1                             # 256 total tasks = 64 tasks/node
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
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pw.x -input input.barrier.scf      # do scf calculations
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pp.x -input input.pp      # do scf calculations
#cd ./scratch
ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/average.x -input ./input.avg      # do scf calculations
#cd ../
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pw.x -input input.nscf     # do nscf calculation
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pw.x -input input.bands    # calculates bands ..?

# post processing
#module load qe
 
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/bands.x -input input.bandcreate   # makes the nice bands.dat files
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.x.spin_up.cond   # makes the nice bands.dat files
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.x.spin_down.cond   # makes the nice bands.dat files
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.gamma.spin_up.cond   # makes the nice bands.dat files
#ibrun /work/06640/wrogers/mysharedirectory/qe-edited/q-e-qe-6.4.1/bin/pwcond.x -input input.gamma.spin_down.cond   # makes the nice bands.dat files

folder=${PWD##*/}
mkdir /work/06640/wrogers/mysharedirectory/vivqe/$folder
cp -r * /work/06640/wrogers/mysharedirectory/vivqe/$folder
#cd /work/06640/wrogers/qsims/ScN/$date
#touch bands_$date_.log bandcreate_$date_.log scf_$date_.log nscf_$date_.log


