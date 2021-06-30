

module load python2



#for dog in *; do

read file

printf "plotting $file\n"
python << END
import matplotlib.pyplot as plt
import numpy as np
import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
import csv
fig = mpl.pyplot.figure(figsize=(12,9))
ax1 = fig.add_subplot(111,projection='3d')


x = []
y = []
z = []


#for i in range(0, 20):
#	tickList.append(float(i/20))

with open('$file') as fp:
	line = fp.readline()
	line = fp.readline()
	line = fp.readline()
        while line:
		line = fp.readline()
		columns = line.split()
		#print(columns[0] + "|" + columns[1] + "|" + columns[2])
		if (len(columns)>1):
               	 x.append(float(columns[0]))
               	 y.append(float(columns[1]))
               	 z.append(float(columns[2]))


surface = ax1.scatter(x,y,z, cmap='inferno', linewidth=0.01, antialiased=False)
#ax1.view_init(90,0)
#fig.colorbar(surface, shrink=0.5, aspect=5, ticks = tickList)
mpl.pyplot.show()
END

#done


module load python3
