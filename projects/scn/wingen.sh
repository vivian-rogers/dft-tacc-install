


cat > input.win <<EOF

num_wann        =  4
num_bands       = 16 
dis_num_iter    = 400
num_iter        = 100
guiding_centres =.true.

dis_win_min    =0
dis_win_max    =21
!dis_froz_min   =0
dis_froz_max   =8
begin atoms_frac
 Sc       0.0 0.0 0.0
 N        0.5 0.5 0.5 
end atoms_frac

begin projections
Sc:s
Sc:d
N:p
end projections


begin unit_cell_cart
angstrom
-2.250 0.000 2.250
0.0000 2.250 2.250
-2.250 2.250 0.000
end_unit_cell_cart

bands_plot = .true.

begin kpoint_path
G  0.000000 0.00000 0.00000  X  0.500000 0.00000 0.50000
X  0.500000 0.00000 0.50000  W  0.500000 0.25000 0.75000
W  0.500000 0.25000 0.75000  K  0.375000 0.37500 0.75000
K  0.375000 0.37500 0.75000  G  0.000000 0.00000 0.00000
end kpoint_path

mp_grid : 6 6 6

begin kpoints
$(cat kpoints.dat)
end kpoints
EOF
