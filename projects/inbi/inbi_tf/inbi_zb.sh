



NP=4 #number of processors
rm -f kpoints.dat

k="2"
q="1"
simname="inbi_zb"
echo "calculate the band-structure of $simname on HSE level using wannierization"
lat="6.75"
hlat=$(awk '{print ($1*0.5)}' <<< "${lat}")



a1="In"
a2="Bi"


nbands="32"

cat >scf.in <<EOF
&control
 calculation='scf',
 prefix='$simname',
 pseudo_dir= './pseudos-hybrid',
 outdir = './$simname',
 wf_collect = .true.,
 !max_seconds = 4500 
/
&system
 ibrav=2,
 A=$lat
 !celldm(1) = 8.0420
 nat=2,
 ntyp=2,
 noncolin= .true. 
 lspinorb = .true.
 nosym= .true.
 !noinv = .true.
 !no_t_rev = .true.
 !!starting_magnetization(1)= 0.15
 !starting_magnetization(2)= 0.15
 !starting_magnetization(3)= -0.05
 !starting_magnetization(4)= 0,	!starting magnetization
 !report = 1,
 
 ecutwfc = 100,
 ecutfock = 200,
 ecutrho = 500,
 nbnd = $nbands
 input_dft='HSE'
 nqx1=$q, nqx2=$q, nqx3=$q !this is NOT converged but fast
 occupations='smearing', 		!used with systems with metals. Doesn't fix occupations. 
 smearing='gaussian', 			!type of smearing... see http://theossrv1.epfl.ch/Main/ElectronicTemperature
 degauss=0.01 			!value of gaussian spreading for brillouin zone integration
  
/
&electrons
 conv_thr=1.d-8,
 adaptive_thr = .true.
 mixing_beta = 0.3
/
ATOMIC_SPECIES
 ${a1} 58.933 ${a1}.upf
 ${a2} 58.933 ${a2}.upf

ATOMIC_POSITIONS crystal
 ${a1} 0.00000 0.00000 0.0000
 ${a2} 0.25000 0.25000 0.2500

K_POINTS {automatic}
 $k $k $k 0 0 0
EOF

echo "Printed SCF file"

mpirun $QEpath/pw.x -np $NP -input scf.in

cat >opengrid.in <<EOF
&inputpp 
   outdir = './$simname'
   prefix = '$simname'
/
EOF

mpirun $QEpath/open_grid.x -np $NP -i opengrid.in > opengrid.out





#this grabs the k-point list generated by open_grid.x
awk '/wannier90/{flag=1;next}/OPEN_GRID    :/{flag=0}flag' opengrid.out > kpoints.dat

cat > $simname.win <<EOF
num_wann        = 12 
num_bands       = $nbands
dis_num_iter    = 400
num_iter        = 100
guiding_centres =.true.

!dis_win_min       = -8.0d0
!dis_win_max       = 70.0d0
!dis_froz_min      = -8.0d0


dis_win_min = 8.1
dis_win_max = 20.15
dis_froz_min = -20
dis_froz_max = 50.15
begin atoms_frac
 ${a1} 0.00000 0.00000 0.0000
 ${a2} 0.25000 0.25000 0.2500
end atoms_frac

spinors = true
begin projections
random
${a1}:d
${a1}:p
${a2}:p
${a2}:d
end projections


begin unit_cell_cart
angstrom
-$hlat 0.000 $hlat
0.000 $hlat $hlat
-$hlat $hlat 0.000
end_unit_cell_cart

kpath = true
kpath_task = bands
!kpath_num_points=500
!kpath_bands_colour = spin
!kpath_num_points=500

begin kpoint_path
W  0.50 0.25 0.75  L  0.50 0.50 0.50
L  0.50 0.50 0.50  G  0.00 0.00 0.00
G  0.00 0.00 0.00  X  0.50 0.00 0.50
X  0.50 0.00 0.50  W  0.50 0.25 0.75
W  0.50 0.25 0.75  K  0.50 0.25 0.75
end kpoint_path

mp_grid : $k $k $k

begin kpoints
$(cat kpoints.dat)
end kpoints
EOF

cat >pw2wannier90.in <<EOF
&inputpp 
   outdir = './$simname'
   prefix = '$simname'
   seedname = '$simname'
   write_spn = .true.   
   write_mmn = .true.
   write_amn = .true.
   write_unk = .true.
/
EOF

$QEpath/wannier90.x -pp $simname
mpirun $QEpath/pw2wannier90.x -np 4 -i pw2wannier90.in
$QEpath/wannier90.x $simname
bash bandstructure.sh ${simname}_band.dat