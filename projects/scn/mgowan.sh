


echo "calculate the band-structure of MgO on HSE level using wannierization"

#NP=1 #number of processors
rm -f kpoints.dat

k="6"
q="3"

cat >scf.in <<EOF
&control
 calculation='scf',
 prefix='mgo',
 pseudo_dir= './',
 outdir = './',
/
&system
 ibrav=2,
 A=4.5
 !celldm(1) = 8.0420
 nat=2,
 ntyp=2,
 ecutwfc = 100,
 ecutrho = 400,
 nbnd = 16
 input_dft='HSE'
 nqx1=$q, nqx2=$q, nqx3=$q !this is NOT converged but fast
 occupations='smearing', 		!used with systems with metals. Doesn't fix occupations. 
 smearing='gaussian', 			!type of smearing... see http://theossrv1.epfl.ch/Main/ElectronicTemperature
 degauss=0.01 			!value of gaussian spreading for brillouin zone integration
 
/
&electrons
 conv_thr=1.d-9,
/
ATOMIC_SPECIES
 Sc 24.305  Sc.UPF
 N  15.999  N.UPF
ATOMIC_POSITIONS crystal
 Sc       0.0 0.0 0.0
 N        0.5 0.5 0.5 
K_POINTS {automatic}
 $k $k $k 0 0 0
EOF
module load qe/6.6
ibrun pw.x -input scf.in

cat >opengrid.in <<EOF
&inputpp 
   outdir = './'
   prefix = 'mgo'
/
EOF

ibrun $qePathEdited/open_grid.x -input opengrid.in >opengrid.out





#this grabs the k-point list generated by open_grid.x
awk '/wannier90/{flag=1;next}/OPEN_GRID    :/{flag=0}flag' opengrid.out >kpoints.dat

cat >mgo.win <<EOF
num_wann        =  16
num_bands       = 16 
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
 Sc       0.0 0.0 0.0
 N        0.5 0.5 0.5 
end atoms_frac

begin projections
random
Sc:d
Sc:s
N:p
end projections


begin unit_cell_cart
angstrom
-2.25 0.000 2.250
0.000 2.250 2.250
-2.25 2.250 0.000
end_unit_cell_cart

bands_plot = .true.

begin kpoint_path
G  0.000000 0.00000 0.00000  X  0.500000 0.00000 0.50000
X  0.500000 0.00000 0.50000  W  0.500000 0.25000 0.75000
W  0.500000 0.25000 0.75000  K  0.375000 0.37500 0.75000
K  0.375000 0.37500 0.75000  G  0.000000 0.00000 0.00000
end kpoint_path

mp_grid : $k $k $k

begin kpoints
$(cat kpoints.dat)
end kpoints
EOF

cat >pw2wannier90.in <<EOF
&inputpp 
   outdir = './'
   prefix = 'mgo_open'
   seedname = 'mgo'
   spin_component = 'none'
   write_mmn = .true.
   write_amn = .true.
   write_unk = .true.
/
EOF

$qePathEdited/wannier90.x -pp mgo
ibrun $qePathEdited/pw2wannier90.x <pw2wannier90.in
$qePathEdited/wannier90.x mgo
bash plot.sh mgo_band.dat
