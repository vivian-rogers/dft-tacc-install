



NP=8 #number of processors
rm -f kpoints.dat

k="3"
q="1"
simname="inbi_t"
echo "calculate the band-structure of $simname on HSE level using wannierization"
lat="4.991"
#hlat=$(awk '{print ($1*0.5)}' <<< "${lat}")



a1="In"
a2="Bi"


nbands="68"

cat >scf.in <<EOF
&control
 calculation='scf',
 prefix='$simname',
 pseudo_dir= './pseudos',
 outdir = './$simname',
 wf_collect = .true.,
 !max_seconds = 4500 
/
&system
 ibrav=6,
 A=$lat
 C=$lat
 !celldm(1) = 8.0420
 nat=4,
 ntyp=2,
 !noncolin= .true. 
 !lspinorb = .true.
 nosym= .true.
 noinv = .true.
 no_t_rev = .true.
 !!starting_magnetization(1)= 0.15
 !starting_magnetization(2)= 0.15
 !starting_magnetization(3)= -0.05
 !starting_magnetization(4)= 0,	!starting magnetization
 !report = 1,
 
 ecutwfc = 45,
 !ecutfock = 200,
 ecutrho = 500,
 nbnd = $nbands
 !input_dft='HSE'
 !nqx1=$q, nqx2=$q, nqx3=$q !this is NOT converged but fast
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
 ${a1} 0.000 0.000 0.500
 ${a1} 0.500 0.500 0.500
 ${a2} 0.000 0.500 0.89752
 ${a2} 0.500 0.500 0.10248

K_POINTS {automatic}
 $k $k $k 0 0 0
EOF

echo "Printed SCF file"

echo "Running SCF..."

mpirun pw.x -np $NP -input scf.in > scf.out
#mpirun $QEpath/pw.x -np $NP -input scf.in > scf.out

cat >opengrid.in <<EOF
&inputpp 
   outdir = './$simname'
   prefix = '$simname'
/
EOF

echo "Running opengrid..."

#open_grid.x -i opengrid.in > opengrid.out
mpirun open_grid.x -np $NP -i opengrid.in > opengrid.out
#mpirun $QEpath/open_grid.x -np 1 -i opengrid.in > opengrid.out





#this grabs the k-point list generated by open_grid.x
awk '/wannier90/{flag=1;next}/OPEN_GRID    :/{flag=0}flag' opengrid.out > kpoints.dat

cat > $simname.win <<EOF
num_wann        = $nbands 
num_bands       = $nbands
dis_num_iter    = 400
num_iter        = 100
guiding_centres =.true.

!dis_win_min       = -8.0d0
!dis_win_max       = 70.0d0
!dis_froz_min      = -8.0d0


dis_win_min = 2.1
dis_win_max = 20.15
dis_froz_min = -20
dis_froz_max = 50
begin atoms_frac
 ${a1} 0.000 0.000 0.500
 ${a1} 0.500 0.500 0.500
 ${a2} 0.000 0.500 0.89752
 ${a2} 0.500 0.500 0.10248
end atoms_frac

begin projections
random
${a1}:p
${a2}:p
end projections


begin unit_cell_cart
angstrom
$lat 0.00 0.00
0.00 $lat 0.00
0.00 0.00 $lat
end_unit_cell_cart

kpath = true
kpath_task = bands
bands_plot = true
bands_plot_project = 4
fermi_surface_plot = true
!kpath_num_points=500
!kpath_bands_colour = spin
!kpath_num_points=500

begin kpoint_path
G 0.00  0.00  0.00    X 0.50  0.00  0.00
X 0.50  0.00  0.00    M 0.50  0.50  0.00
M 0.50  0.50  0.00    G 0.00  0.00  0.00
G 0.00  0.00  0.00    M 0.50  0.50  0.00
M 0.50  0.50  0.00    A 0.50  0.50  0.50
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
   spin_component = 'none'
   !write_spn = .true.   
   write_mmn = .true.
   write_amn = .true.
   write_unk = .false.
/
EOF

echo "Running wannier90"

wannier90.x -pp $simname
#$QEpath/wannier90.x -pp $simname
mpirun pw2wannier90.x -np 4 -i pw2wannier90.in
#mpirun $QEpath/pw2wannier90.x -np 2 -i pw2wannier90.in
wannier90.x $simname
#$QEpath/wannier90.x $simname
bash bandstructure.sh ${simname}_band.dat