import pylab as pl
import numpy as np
print('loading data...')
data = np.loadtxt('heusler-bands.dat')
print('loaded data...')
x=data[:,0]
y=data[:,1]
z=data[:,2]
tick_labels=[]
tick_locs=[]
tick_labels.append('$\Gamma$')
tick_locs.append(0)
tick_labels.append(' X'.strip())
tick_locs.append(    1.010158)
tick_labels.append(' W'.strip())
tick_locs.append(    1.515238)
tick_labels.append(' K'.strip())
tick_locs.append(    1.872383)
tick_labels.append('$\Gamma$')
tick_locs.append(    2.943817)
pl.scatter(x,y,c=z,marker='+',s=1,cmap=pl.cm.jet)
pl.xlim([0,max(x)])
pl.ylim([min(y)-0.025*(max(y)-min(y)),max(y)+0.025*(max(y)-min(y))])
pl.xticks(tick_locs,tick_labels)
for n in range(1,len(tick_locs)):
   pl.plot([tick_locs[n],tick_locs[n]],[pl.ylim()[0],pl.ylim()[1]],color='gray',linestyle='-',linewidth=0.5)
pl.ylabel('Energy [eV]')
pl.axes().set_aspect(aspect=0.65*max(x)/(max(y)-min(y)))
pl.colorbar(shrink=0.7)
outfile = 'heusler-bands.pdf'
pl.savefig(outfile,bbox_inches='tight')
pl.show()
