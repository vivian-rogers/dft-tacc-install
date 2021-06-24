

#inVitlat = 1, dlat = 2, name = 3, x = 4, y= 5, z=6, initmag1=7, initmag2=8, initmag3=9, xmass=10, ymass=11, zmass=12
createInputFiles () {
lat=$1
name="${4}-doped${5}$6-$3"
X1="${4}1"
X2="${4}2"
mkdir $name
cd $name
for i in {0..0}
do
lat=$(awk '{print ($3 - $1*$2)}' <<<"${i} ${2} ${1}")
hlat=$(awk '{print ($1*0.5)}' <<<"${lat}")
mlat=$(awk '{print ($1*1.5)}' <<<"${lat}")
dlat=$(awk '{print ($1*2)}' <<<"${lat}")
#mkdir $lat
#cd $lat
cat > input.scf <<EOF
 &control
    calculation='vc-relax'
    restart_mode='from_scratch', !disregards any prior wfc, etc files created 
    pseudo_dir = '/work/06640/wrogers/mysharedirectory/pseudos/ONCV/SR/', 		 !the pseudopotentials will be in this directory
    prefix='dat' 		 !this is the prefix that the PWCOND file will pull from
    disk_io = 'low'
    verbosity='high' 		 !will print out fermi energy in output 
    max_seconds=169200,
 /
 &system
    ibrav= 1,
    A=$lat
    !celldm(1)= 11.7654,
    !celldm(3)= 1.4142,
    nat= 8, 				!number of atoms in unit cell for scf calculation
    ntyp= 3, 				!number of types of atoms defined under atomic species
    !nbnd = 64  				!number of bands to be calculated, default should be fine
  
    !noncolin= .true. 			!"if .true, the program will perform a noncollinear calculation"
    !lspinorb = .true. 			!if true, noncolin mode can use a pseudopotential with spin-orbit
    nspin = 2,				!if 1, will perform non-spin-polarized calculation. if 2, will do so, constraining magnetization to z axis. if 4, will do noncollinear magnetization    
    starting_magnetization(1)= $7,	!starting magnetization
    starting_magnetization(2)= $8,	!starting magnetization
    starting_magnetization(3)= 0,	!starting magnetization
    input_dft='HSE',
    report = 1,
    ecutwfc = 100, 			!kinetic energy cutoff (Ry) for wfcs
    ecutfock = 400
    ecutrho = 400, 			!kinetic energy cutoff for charge density and potential. see *.UPF file 
    nqx1=1, nqx2=1, nqx3=1,
    occupations='smearing', 		!used with systems with metals. Doesn't fix occupations. 
    smearing='gaussian', 			!type of smearing... see http://theossrv1.epfl.ch/Main/ElectronicTemperature
    degauss=0.02 			!value of gaussian spreading for brillouin zone integration
 /
 &electrons
    diagonalization='david',		!type of diagonalization, conjugate-gradient band by band diag. uses less m   
    adaptive_thr = .true.,
    conv_thr = 1.0e-7,			!convergence threshold for scf, will stop if estimated energy error is less that
    mixing_beta = 0.4			!mixing factor for scf
 /
 &ions
    ion_dynamics = 'bfgs',
    wfc_extrapolation = 'first-order'
 /
 &cell
    cell_dofree = 'ibrav',
    press_conv_thr = 0.001,
 /

ATOMIC_SPECIES
$X1 ${10} $4.UPF
$5 ${11} $5.UPF
$6 ${12} $6.UPF

ATOMIC_POSITIONS (angstrom)
$X1	0.0	0.0	0.0
$5	$hlat	$hlat	0.0
$5	0.0	$hlat	$hlat
$5	$hlat	0.0	$hlat
$6	0.0	0.0	$hlat
$6	$hlat	$hlat	$hlat
$6	0.0	$hlat	0.0
$6	$hlat	0.0	0.0

K_POINTS (automatic)
8 8 8 0 0 0

EOF
done
cd ../
}

massFromName () {
#echo "Masses: Co=58.933, Mn=54.938, Fe=55.845"
#echo "Sc=44.956, N=14.007, Sb=121.76"
local  __resultvar=$1
local  mass='some value'
case $2 in
  Co)
	mass='58.933'
	;;
  Mn)
	mass='54.938'
	;;
  Fe)
	mass='55.845'
	;;
  Sc)
	mass='44.956'
	;;
  N)
	mass='14.007'
	;;
  Sb)
	mass='121.76'
	;;
  *)
	echo "Enter mass of element $2: "
	read mass
	;;
esac
eval $__resultvar="'$mass'"
}

echo "Enter name of folder to create"
read foldername
rm -r $foldername
mkdir $foldername
cd $foldername

#echo "Creating inputs for X2YZ full heusler"
echo "Creating inputs for X_0.25 Y_0.75 Z lattice"
echo "(case sensitive!) Enter X atom: "
read X
X1="${X}1"
X2="${X}2"

echo "Enter Y atom: "
read Y
echo "enter Z atom: "
read Z
echo " "
#echo "Masses: Co=58.933, Mn=54.938, Fe=55.845"
#echo "Sc=44.956, N=14.007, Sb=121.76"
#echo "Enter X mass"
echo "Calculating masses: "

massFromName Xmass $X
massFromName Ymass $Y
massFromName Zmass $Z

echo "Enter guessed starting lattice parameter (angstroms):"
read initlat
echo "Enter dlat to increment by (0.01 is good):"
read dlat


#inVitlat = 1, dlat = 2, name = 3, x = 4, y= 5, z=6, initmag1=7, initmag2=8, initmag3=9, xmass=10, ymass=11, zmass=12
createInputFiles $initlat $dlat "ferromagnetic" $X $Y $Z "1" "0.2" "0.2" $Xmass $Ymass $Zmass
createInputFiles $initlat $dlat "ferrimagnetic" $X $Y $Z "1" "0.2" "-0.2" $Xmass $Ymass $Zmass
createInputFiles $initlat $dlat "antiferromagnetic" $X $Y $Z "1" "-0.1" "0" $Xmass $Ymass $Zmass




