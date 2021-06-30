
set terminal svg size 600,400
set output "bands.svg"
set xlabel "K points"
set ylabel "Energy (eV)"
set autoscale
set yrange [0:40]
#set title "CoFeB hysteresis out-of-plane-H"
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set grid xtics lt 0 lw 1 lc rgb "#bbbbbb"
unset log
unset label
set xtic auto
set ytic auto
plot "bands.dat.gnu" using 1:2 with lines
