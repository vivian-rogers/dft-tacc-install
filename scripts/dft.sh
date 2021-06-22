#!/bin/bash


if [ -z "$2" ]
then
printf "Incorrect usage! Call using 'bash dft.sh [SLURM script to run] [input filename]\n"
printf "maybe consider using pwscf.sl as the slurm script?\n"
##### THIS IS WHERE YOU CAN ADD MORE DOCUMENTATION
##### use more printfs to list the options


else


DATE=$(date "+%H-%M_%A_%B_%d_%Y")
FOLDERNAME="$2-$1-$DATE"
printf "\n================ dft (qe, etc) script wrapper ==================\n"
printf "Queueing $1 with $2 into scratch directory\n"
printf "it will be copied back into /outputs/ when finished\n"
sbatch --export=ALL,FOLDERNAME=$FOLDERNAME,FILENAME=$2,dftOutputPath=$dftOutputPath $1

fi
