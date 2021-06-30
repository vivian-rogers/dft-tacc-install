echo "=================================================="
echo "               qe system template                 "
echo "=================================================="
echo " "
echo "This will copy one of the base systems from /reference/ for you to modify"
echo "Which system would you like to copy? fcc ScN for the scf/nscf/bands calculation is 1, bcc iron is 2 for same, and 3 is for very basic scf/conduction system with leads and a scatterer"
read simnum
echo "What do you want to title your simulation? (ex: 3-layer-ScN-conduction)"
read title

mkdir /work/06640/wrogers/mysharedirectory/systems/$title

if (( $simnum == 1 )); then
	cp -avr /work/06640/wrogers/mysharedirectory/reference/scn-test/* /work/06640/wrogers/mysharedirectory/systems/$title 
	pwd
fi

if (( $simnum == 2 )); then
	cp -avr /work/06640/wrogers/mysharedirectory/reference/fe-test/* /work/06640/wrogers/mysharedirectory/systems/$title 
	pwd
fi

if (( $simnum == 3 )); then
	cp -avr /work/06640/wrogers/mysharedirectory/reference/small-scatterer/* /work/06640/wrogers/mysharedirectory/systems/$title 
	pwd
fi

echo "Copied system to /work/06640/wrogers/mysharedirectory/systems/$title !"
