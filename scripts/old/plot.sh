

module load python2


fermi=$(grep Fermi qe*.out | awk 'BEGIN{temp=$5}{temp=$5}END{print temp}')
printf "The detected fermi energy is $fermi eV\n"

#file="bands_gamma_up.co_im"
file=$1
file2=$2
file3=$3

#for file in *_e1; do

printf "plotting $file\n"
python << END
import matplotlib.pyplot as plt
import numpy as np
import matplotlib as mpl
import csv
import pandas as pd
fig = mpl.pyplot.figure(figsize=(7,5))

#fig = mpl.pyplot.figure(figsize=(12,9.5))
ax1 = fig.add_subplot(111)


ymax = 16
ymin = -10

#xmin = 0
#xmax = 4.3479
x = []
y = []
z = []

with open('$file') as fp:
	line = fp.readline()
	line = fp.readline()
        while line:
		line = fp.readline()
		columns = line.split()
		if(len(columns)>1):
		 x.append(float(columns[0]))
               	 y.append(float(columns[1]))
               	 z.append(float(columns[2]))
               	 #y.append(float(columns[1]) - $fermi)


surface = plt.scatter(x,y,c='#FF1111')
surface = plt.scatter(x,z,c='#11FFF1')
#kpts = [xmin,0.7071,1.5731,2.5731,3.0731,xmax]
#kpts = np.array([0,0.7071,1.5731,2.5731,3.0731,3.5731])
#kptnames = ['W','L','G','X','W','K']
#i = 0
#for kpt in kpts:
#	x.append(float(kpts[i]))
#	x.append(float(kpts[i]))
#	y.append(ymin)
#	y.append(ymax)
#	surface = plt.plot(x,y,c='#111111')
#	x = []
#	y = []
#	i += 1

#plt.xticks(kpts,kptnames)
	

#ax1.set_xlim(-1.5,0)
#ax1.set_ylim(ymin,ymax)
ax1.set_title("Transmission ", fontname="Arial", fontsize=15)
ax1.set_ylabel("E - Ef (eV)", fontname="Arial", fontsize=15)
ax1.set_xlabel("k", fontname="Arial", fontsize=15)

#fig.colorbar(surface, shrink=0.5, aspect=5, ticks = tickLt)
#plt.savefig("$file.png")
mpl.pyplot.show()
#plt.clf()
END

