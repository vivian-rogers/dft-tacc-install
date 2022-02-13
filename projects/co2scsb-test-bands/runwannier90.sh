


echo "calculate the band-structure of MgO on HSE level using wannierization"

#NP=1 #number of processors
rm -f kpoints.dat

k="5"
q="1"
lat="6.22"
hlat=$(awk '{print ($1*0.5)}' <<<"${lat}")

a1="Co"
a2="Co"
a3="Sc"
a4="Sb"
nbands="70"


awk '/wannier90/{flag=1;next}/OPEN_GRID    :/{flag=0}flag' opengrid.out >kpoints.dat


cat > heusler.win <<EOF
num_wann        = $nbands
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
 ${a3} 0.00000 0.00000 0.0000
 ${a1} 0.25000 0.25000 0.2500
 ${a4} 0.50000 0.50000 0.5000
 ${a2} 0.75000 0.75000 0.7500
end atoms_frac

spinors = true
begin projections
random
${a1}:d
${a3}:d
${a4}:p
end projections


begin unit_cell_cart
angstrom
-$hlat 0.000 $hlat
0.000 $hlat $hlat
-$hlat $hlat 0.000
end_unit_cell_cart

kpath = true
kpath_task = bands
kpath_bands_colour = spin
!kpath_num_points=500

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
   outdir = './scratch'
   prefix = 'dat'
   seedname = 'heusler'
   write_spn = .true.   
   write_mmn = .true.
   write_amn = .true.
   !write_unk = .true.
/
EOF

$qePathEdited/wannier90.x -pp heusler
ibrun $qePathEdited/pw2wannier90.x <pw2wannier90.in
$qePathEdited/wannier90.x heusler
bash plot.sh heusler_band.dat
