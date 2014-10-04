import sys
import os
import numpy
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection


#------------------------------------------------------------------------
def readOutlines():


	#Read outline files
	outlines = []
	for i in range(1666):
		filename = 'towers/polygon' + str(i+1)
		shape = []
		with open(filename,'r') as f:
			for line in f:
				elements = line.rstrip().split('\t')
				shape.append((float(elements[0]),float(elements[1])))
		shape = numpy.array(shape)
		outlines.insert(i,shape)


	#return outlines
	return outlines


#------------------------------------------------------------------------
def querydemo():

	print 'query'


#------------------------------------------------------------------------
if __name__ == '__main__':


	#Run Test Query
	#querydemo()
	indexer = int(sys.argv[1]);


	
	#Load the demographics
	statistics = pd.read_csv('data/arrond',delimiter=',')
	fields = list(statistics.columns.values)
	for i,field in enumerate(fields):
		print i,field
	statistics = statistics.fillna(-1)
	statistics = numpy.array(statistics)


	
	#Read Map
	senegal = pd.read_csv('meta/senegal.csv')
	senegal = numpy.array(senegal)

	
	
	#Read the outlines to plot
	outlines = readOutlines()



	#Create Polygons
	meanval = numpy.mean(statistics[:,indexer])
	patches = []
	colors = []
	invalid = [692,288,315,281]
	for i,outline in enumerate(outlines):
		polygon = Polygon(outline,True)
		if (i not in invalid):
			value = statistics[i,indexer]
			if (value < 0):
				value = meanval
			print value
			colors.append(value)
			patches.append(polygon)
		


	#Min,Max value
	minval = numpy.min(statistics[:,indexer])
	maxval = numpy.max(statistics[:,indexer])

	
	
	#Figure
	mpl.rcParams['toolbar'] = 'None'
	fig, ax = plt.subplots()
	plt.title(fields[indexer])
	plt.plot(senegal[:,0],senegal[:,1],color='k')
	p = PatchCollection(patches, edgecolor='none',alpha=1.0,cmap=plt.get_cmap('hot'))#,norm=mpl.colors.Normalize(vmin=minval,vmax=maxval))
	p.set_array(numpy.array(colors))
	ax.add_collection(p)
	plt.colorbar(p)
	plt.show()	