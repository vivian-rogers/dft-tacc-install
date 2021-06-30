

echo "Which Fe leads would you like to copy into this directory?"
echo "0 for fe0 up-up, 1 for fe0 up-down, 2 for fe0 down-down"
echo "3 for fe1 up-up, 4 for fe1 up-down, 5 for fe1 down-down"
echo "6 for fe0squished up-up, 7 for fe0s up-down, 8 for fe0s down-down"
echo "9 for fe0-up-up-uspp, 10 for fe0-up-down-uspp"
read copynum
if (( $copynum == 0 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe0-leads-up-up/* ./
fi
if (( $copynum == 1 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe0-leads-up-down/* ./
fi
if (( $copynum == 2 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe0-leads-down-down/* ./
fi
if (( $copynum == 3 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe1-leads-up-up/* ./
fi
if (( $copynum == 4 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe1-leads-up-down/* ./
fi
if (( $copynum == 5 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe1-leads-down-down/* ./ 
fi
if (( $copynum == 6 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe0s-leads-up-up/* ./
fi
if (( $copynum == 7 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe0s-leads-up-down/* ./
fi
if (( $copynum == 8 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/final/fe0s-leads-down-down/* ./
fi
if (( $copynum == 9 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/redo/fe0-leads-up-up/* ./
fi
if (( $copynum == 10 )); then
	cp -ar /work/06640/wrogers/mysharedirectory/systems/redo/fe0-leads-up-down/* ./
fi

. cptransinput.sh
