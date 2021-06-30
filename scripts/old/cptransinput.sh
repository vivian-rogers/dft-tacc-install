printf "\nEnsure that you have changed bds in both spin_up and spin_down, use half unit cell for antiparallel system\n"
printf "SCF unit cell length: "
grep 'celldm(3)' input.barrier.scf

printf "Moving input transmission files...\n"
cp -avr /work/06640/wrogers/mysharedirectory/scripts/transinput/* ./
