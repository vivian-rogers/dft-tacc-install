
echo "====================================================================="
echo "              Enter the operation you would like to do               "
echo "====================================================================="
echo " "
echo "1 is scf, 2 is nscf, 3 is bands, 4 is scf/nscf/bands in succession, 5 is vc-relax", 
echo "6 is barrierscf,7 is leadscf, 8 is transport with PWCOND (spin polarized up), "
echo "9 is barrierscf/leadscf, 10 is barrier/lead vc-md, 11 is PWCOND for spin up/down/0(?)"
printf "Simulation number: " 
read simnum
printf "Simulation title: "
read title

date=$(date "+%H:%M_%A_%B_%d_%Y")


if (( $simnum == 1 )); then
	date="$title-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	
fi

if (( $simnum == 2 )); then
	date="$title-nscf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cp -avr *.log $SCRATCH/qe/$date
	cp -avr *.save $SCRATCH/qe/$date
	cp -avr*.hub* $SCRATCH/qe/$date
	cp -avr *.wfc* $SCRATCH/qe/$date
	cd $SCRATCH/qe/$date/
	pwd

fi

if (( $simnum == 3 )); then
	date="$title-bands-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date
	cp -avr input.* $SCRATCH/qe/$date
	cp -avr *.log $SCRATCH/qe/$date
	cp -avr *.save $SCRATCH/qe/$date
	cp -avr *.hub* $SCRATCH/qe/$date
	cp -avr *.wfc* $SCRATCH/qe/$date
	cd $SCRATCH/qe/$date
	sbatch bandcreate.sh
	pwd
fi
if (( $simnum == 4 )); then
	date="$title-scn-nscf-bands-$date"
	mkdir $SCRATCH/qe/$date
	echo " "
        echo "Moving input files..."
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date
	cd $SCRATCH/qe/$date
	pwd
	sbatch all.sh
fi
if (( $simnum == 5 )); then
	date="$title-mdrelax-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch vcrelax.sh
fi

if (( $simnum == 6 )); then
	date="$title-barrier-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barrierscf.sh
fi

if (( $simnum == 7 )); then
	date="$title-lead-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch leadscf.sh
fi

if (( $simnum == 8 )); then
	date="$title-cond-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch pwcond_up.sh
fi
if (( $simnum == 9 )); then
	date="$title-leads+barrier-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barrierleadscfgpu.sh
fi
if (( $simnum == 10 )); then
	date="$title-leads+barrier-vcmd-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barrierleadvcmdcpu.sh
fi
if (( $simnum == 11 )); then
	date="$title-cond-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch pwcond_up.sh
	sbatch pwcond_down.sh
	#sbatch pwcond_0.sh	
fi

echo "Finished queueing simulation $title for $simnum!"

