

module load python2



for file in *_e1; do

printf "plotting $file\n"
python << END


import pandas as pd
import matplotlib.pyplot as plt
import scipy.interpolate
import numpy as np
import matplotlib.colors as colors

# import data
df = pd.read_csv('$file', delim_whitespace=True, 
                     comment='#',header=[0,1])

x = df[0]
y = df[1]
z = df[2]

# Set up a regular grid of interpolation points

spacing = 200
xi, yi = np.linspace(x.min(), x.max(), spacing), np.linspace(y.min(), 
                     y.max(), spacing)

XI, YI = np.meshgrid(xi, yi)

# Interpolate
#rbf = scipy.interpolate.rbf(x, y, z, function='linear')

ZI = df[2].values.reshape(200,200).T

#plot

fig, ax = plt.subplots()

sc = ax.imshow(XI,YI,ZI, vmin=z.min(), vmax=z.max(), origin='lower',
            extent=[x.min(), x.max(), y.min(), 
                    y.max()], cmap="GnBu", norm=colors.LogNorm(vmin=ZI.min(),
                    vmax=ZI.max()))

fig.colorbar(sc, ax=ax, fraction=0.05, pad=0.01)

plt.show()



END

done


module load python3
