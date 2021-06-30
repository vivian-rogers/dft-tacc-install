#!/bin/bash

echo "=================================================="
echo "      Quantum Espresso K-point generator          "
echo "=================================================="
echo "Paste the output at the bottom of the input.* files!"

printf "K-point table:
Symmetries of cubic lattice:
G 0.0 0.0 0.0
M 0.5 0.5 0.0
R 0.5 0.5 0.5
X 0.0 0.5 0.0

Symmetries of fcc lattice:
G 0.0 0.0 0.0
K 0.75 0.75 0.0
L 0.5 0.5 0.5
#U 0.625 0.25 0.625
W 0.5 0.0 1.0
X 0.0 0.0 1.0\n\n"


echo "Name of material file (ex: "input.kpoints"):"
read namefile
echo "How many high symmetry k points do you want to generate?"
read numkpoints
echo "How many points do you want to interpolate between each k point?"
read numinterpolate


printf "!paste this file into the bottom of your input.bands, input.nscf, and input.scf files
K_POINTS 

$(((numkpoints-1)*(numinterpolate+1)+1))\n" >> $namefile


weight=40 # this should not be important for nscf calculations but can be modified from here
currentx=0
currenty=0
currentz=0 
dx=0
dy=0
dz=0
goalx=0
goaly=0
goalz=0

printf "what is the name of this k point? "
read kname
printf "what is kx for your first k point? (ex: 0.5) "
read currentx
printf "what is ky for your first k point? "
read currenty
printf "what is kz for your first k point? "
read currentz

echo "$currentx $currenty $currentz $weight !$kname" >> $namefile



for ((i = 0 ; i < numkpoints-1; i++)); do #iterate through every layer
	printf "\nwhat is the name of this k point? (ex: X) "
	read kname
	printf "what is kx for the next k point? "
	read goalx
	printf "what is ky for the next k point? "
	read goaly
	printf "what is kz for the next k point? "
	read goalz
	
	dx=$(awk '{print (-$2+$1)/($3+1)}' <<<"${currentx} ${goalx} ${numinterpolate}") #calculates the offset to move to the next point
	dy=$(awk '{print (-$2+$1)/($3+1)}' <<<"${currenty} ${goaly} ${numinterpolate}")
	dz=$(awk '{print (-$2+$1)/($3+1)}' <<<"${currentz} ${goalz} ${numinterpolate}")
	
	#printf "$dx $dy $dz\n"
	
	for ((j = 0 ; j < (numinterpolate) ; j++)); do
		currentx=$(awk '{print ($1-$2)}' <<<"${currentx} ${dx}") #moves to the next point
		currenty=$(awk '{print ($1-$2)}' <<<"${currenty} ${dy}")
		currentz=$(awk '{print ($1-$2)}' <<<"${currentz} ${dz}")
		echo "$currentx $currenty $currentz $weight" >> $namefile
	done
	
	currentx=$(awk '{print ($1-$2)}' <<<"${currentx} ${dx}") #does the final point and names the k point
	currenty=$(awk '{print ($1-$2)}' <<<"${currenty} ${dy}")
	currentz=$(awk '{print ($1-$2)}' <<<"${currentz} ${dz}")
	
	echo "$currentx $currenty $currentz $weight !$kname" >> $namefile
	
done

echo "generated $namefile!"
