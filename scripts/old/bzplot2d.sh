

module load python2



for file in *_e1; do

printf "plotting $file\n"
python << END
import matplotlib.pyplot as plt
import numpy as np
import matplotlib as mpl
#from mpl_toolkits.mplot3d import Axes3D
import csv
import pandas as pd

fig = mpl.pyplot.figure(figsize=(12,9.5))
ax1 = fig.add_subplot(111)


x = []
y = []
z = []
#datapts = []
tickList = [1,0.1,0.01,0.001,0.0001,0.00001,0.000001,0.0000001,0.00000001]

for i in range(0, 20):
	tickList.append(float(i/20))

offset = 0.00000001

with open('$file') as fp:
	line = fp.readline()
	line = fp.readline()
	#line = fp.readline()
        while line:
		line = fp.readline()
		columns = line.split()
		#print(columns[0] + "|" + columns[1] + "|" + columns[2])
		if (len(columns)>1):
               	 #datapts.append([float(columns[0]),float(columns[1]),float(columns[2])+0.000001])
		 x.append(float(columns[0]))
               	 y.append(float(columns[1]))
               	 z.insert(0,float(columns[2])+ offset)


#datapts = sorted(datapts)

#yy, xx = np.meshgrid(x,y)
#zz = griddata(x,y,z,xx,yy, interp='linear')
#plt.pcolor(zz)
#df = pd.DataFrame(data=[np.asarray(x),np.asarray(y),np.asarray(z)])
#ny = 200
#nx = 200
#dat = pd.read_csv('$file')
#print len(x)
#print len(y)
#print len(z)
#X = np.asarray(x).reshape(nx,ny)
#Y = np.asarray(y).reshape(nx,ny)
#Z = np.asarray(z).reshape(nx,ny)
#df = pd.DataFrame(data=Z)
#X, Y = np.meshgrid(x, y)
#z = x*y
#values = [x,y,z]

surface = plt.scatter(x,y,c=z,marker=',', norm=mpl.colors.LogNorm(vmin=offset, vmax=2), cmap='inferno')
#ax1.set_title("Transmission ", fontname="Adobe Arial", fontsize=15)
#ax1.set_ylabel("k_y", fontname="Adobe Arial", fontsize=15)
#ax1.set_xlabel("k_x", fontname="Adobe Arial", fontsize=15)

#surface = ax1.pcolormesh(x,y,z, norm=mpl.colors.LogNorm(vmin=offset, vmax=1), cmap='inferno')
#ax1.view_init(90,0)
fig.colorbar(surface, shrink=0.5, aspect=5, ticks = tickList)
plt.savefig("$file.png")
mpl.pyplot.show()
plt.clf()
END

done


module load python3
