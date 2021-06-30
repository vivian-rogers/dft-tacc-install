echo " "
echo " "
echo "====================================================================="
echo "          Enter the number of the simulation you want to run:        "
echo "====================================================================="
echo " "
echo "(not all are implemented: 1, 4, 7, 16, 17, 21, and 23/24 work!)"
echo "see references and scripts for sample input files"
echo " "
echo "1 is scf, 2 is stampede bigscf, 3 is bands, 4 is scf/nscf/bands in succession, 5 is vc-relax", 
echo "6 is barrierscf continue,7 is leadscf, 8 is transport with PWCOND (spin polarized up), "
echo "9 is barrierscf/leadscf, 10 is barrier/lead vc-md, 11 is PWCOND for spin up/down on Stampede2,"
echo "12 is for barrier/lead vc/md picking up from a restart, 13 is for left lead vcmd"
echo "14 is for right lead vcmd, 15/16 is for scattering region vcmd/scf, 17 does barrierscf restart,"
echo "18 is tacc barrierscf, 19 is tacc pwcond, 20 is tacc leadscf, 21 is ls5 cond"
echo "22 is for ikind=1 pwcond, 23 and 24 continue conduction for up and down in scratch"
echo "25 is for scf/nscf/bands/complex bands, 26 is for workfunction, 27 is for projwfc"
echo "28 is for dos, 29 is for scfwannierbands, 30 is for stampede scfwannierbands"
echo "31 is to sweep energy vs lattice spacing vs magnetic config"
printf "Simulation number: " 
read simnum
printf "Simulation title: "
read title
printf "Description of simulation: "
read description
printf "Checking if SCRATCH/qe exists, ignore if so\n"
mkdir $SCRATCH/qe
printf "MOVING FILES (this might take a while)...\n"

date=$(date "+%H:%M_%A_%B_%d_%Y")
printf "#################### $date ##################\n" >> /work/06640/wrogers/mysharedirectory/scripts/log.txt 
printf "queueing $title for $simnum:\n" >> /work/06640/wrogers/mysharedirectory/scripts/log.txt 
printf "$description \n\n" >> /work/06640/wrogers/mysharedirectory/scripts/log.txt 

#chmod -R 

if (( $simnum == 1 )); then
	date="$title-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	sbatch scf.sh
	pwd
	
fi

if (( $simnum == 2 )); then
	date="$title-bigscf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch stampedebigscf.sh

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
	date="$title-vcrelax-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch vcrelax.sh
fi

if (( $simnum == 6 )); then
	date="$title-barrier-continue-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 
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
	sbatch barrierleadscf.sh
fi
if (( $simnum == 10 )); then
	date="$title-leads+barrier-vcmd-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr *.UPF $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barrierleadvcmdgpu.sh
fi
if (( $simnum == 11 )); then
	up="$title-cond-up-$date"
	mkdir $SCRATCH/qe/$up 
	cp -ar * $SCRATCH/qe/$up 
	
	down="$title-cond-down-$date"
	mkdir $SCRATCH/qe/$down 
	cp -ar * $SCRATCH/qe/$down 
	
	cd $SCRATCH/qe/$up/
	sbatch pwcond_up.sh
	cd $SCRATCH/qe/$down/
	sbatch pwcond_down.sh
	
#	date="$title-cond-down-$date"
#	mkdir $SCRATCH/qe/$date 
#	cp -avr * $SCRATCH/qe/$date 
#	cd $SCRATCH/qe/$date/
	#pwd
	#sbatch pwcond_up.sh
#	sbatch pwcond_down.sh
	#sbatch pwcond_0.sh	
fi
if (( $simnum == 12 )); then
	date="$title-leads+barrier-vcmd-continue-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barrierleadvcmdgpu.sh
fi

if (( $simnum == 13 )); then
	date="$title-leftlead-vcmd-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch leftleadvcmd.sh
fi
if (( $simnum == 14 )); then
	date="$title-rightlead-vcmd-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch rightleadvcmd.sh
fi
if (( $simnum == 15 )); then
	date="$title-barrier-vcmd-continue-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barriervcmdcpu.sh
fi
if (( $simnum == 16 )); then
	date="$title-barrier-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	#sbatch barrierscf.sh
	sbatch precompilebarrierscf.sh
fi
if (( $simnum == 17 )); then
	date="$title-barrier-scf-continue-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch barrierscf.sh
fi
if (( $simnum == 18 )); then
	date="$title-barrier-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch taccbarrierscf.sh
fi
if (( $simnum == 19 )); then
	up="$title-tacc-cond-up-$date"
	mkdir $SCRATCH/qe/$up 
	cp -avr * $SCRATCH/qe/$up 
	
	down="$title-tacc-cond-down-$date"
	mkdir $SCRATCH/qe/$down 
	cp -avr * $SCRATCH/qe/$down 
	
	cd $SCRATCH/qe/$up/
	sbatch taccpwcond_up.sh
	cd $SCRATCH/qe/$down/
	sbatch taccpwcond_down.sh
	
	#date="$title-tacc-cond-$date"
	#mkdir $SCRATCH/qe/$date 
	#cp -avr * $SCRATCH/qe/$date 
	#cd $SCRATCH/qe/$date/
	#pwd
	#sbatch taccpwcond_up.sh
	#sbatch taccpwcond_down.sh
fi
if (( $simnum == 20 )); then
	date="$title-tacc-lead-scf-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/
	pwd
	sbatch taccleadscf.sh
fi
if (( $simnum == 21 )); then
	up="$title-ls5-cond-up-$date"
	mkdir $SCRATCH/qe/$up 
	cp -ar * $SCRATCH/qe/$up 
	
	down="$title-ls5-cond-down-$date"
	mkdir $SCRATCH/qe/$down 
	cp -ar * $SCRATCH/qe/$down 
	
	cd $SCRATCH/qe/$up/
	sbatch ls5_pwcond_up.sh
	cd $SCRATCH/qe/$down/
	sbatch ls5_pwcond_down.sh
fi

if (( $simnum == 22 )); then
	up="$title-lorb-cond-up-$date"
	mkdir $SCRATCH/qe/$up 
	cp -ar * $SCRATCH/qe/$up 
	
	down="$title-lorb-cond-down-$date"
	mkdir $SCRATCH/qe/$down 
	cp -ar * $SCRATCH/qe/$down 
	
	cd $SCRATCH/qe/$up/
	sbatch bands_pwcond_up.sh
	cd $SCRATCH/qe/$down/
	sbatch bands_pwcond_down.sh
fi
if (( $simnum == 24 )); then
	sbatch ls5_pwcond_down.sh
fi
if (( $simnum == 23 )); then
	sbatch ls5_pwcond_up.sh
fi

if (( $simnum == 25 )); then
	date="$title-scf-cbands-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 	
	cd $SCRATCH/qe/$date  
	sbatch scf_cbands.sh
fi

if (( $simnum == 26 )); then
	date="$title-workfunct-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr input.* $SCRATCH/qe/$date 	
	cd $SCRATCH/qe/$date  
	sbatch workfunct.sh
fi
if (( $simnum == 27 )); then
	date="$title-projwfc-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 	
	cd $SCRATCH/qe/$date  
	sbatch projwfc.sh
fi
if (( $simnum == 28 )); then
	date="$title-dos-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 	
	cd $SCRATCH/qe/$date  
	sbatch dos.sh
fi
if (( $simnum == 29 )); then
	date="$title-scf-wannier-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 	
	cd $SCRATCH/qe/$date  
	sbatch scfwannierbands.sh
fi
if (( $simnum == 30 )); then
	date="$title-stampede2-scf-wannier-$date"
	mkdir $SCRATCH/qe/$date 
	cp -avr * $SCRATCH/qe/$date 	
	cd $SCRATCH/qe/$date  
	sbatch stampede2wannierbands.sh
fi
if (( $simnum == 31 )); then
	date="$title-scf-sweep-$date"
	mkdir $SCRATCH/qe/$date 
	echo "Type the folder you want to queue: "
	read folder
	cp -avr $folder $SCRATCH/qe/$date 
	cd $SCRATCH/qe/$date/$folder  
	echo "If vc-relax, type 0. If scf, type 1:"
	read scf
	for magconfig in *
	do
		cd magconfig
		if (( $scf == 1 )); then
			for lat in *
			do
				cd lat
				sbatch stampedebigscf.sh
				cd ../	
			done
		else
			sbatch stampedebigscf.sh	
		fi	
		cd ../
	done
	#sbatch stampede2wannierbands.sh
fi


echo "Finished queueing simulation $title for $simnum!"

