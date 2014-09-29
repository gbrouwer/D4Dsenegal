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
	for i in range(123):
		filename = 'outlines/lines' + str(i)
		shape = []
		with open(filename,'r') as f:
			line = f.readline()
			elements = line.rstrip().split(',')
			index = int(elements[-2])
			for line in f:
				elements = line.rstrip().split(',')
				shape.append((float(elements[1]),float(elements[2])))
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
	statistics = pd.read_csv('data/arrondissement.csv',delimiter='\t')
	fields = list(statistics.columns.values)
	for i,field in enumerate(fields):
		print i,field
	statistics = numpy.array(statistics)



	#Read Map
	senegal = pd.read_csv('meta/senegal_outline.csv')
	senegal = numpy.array(senegal)


	
	#Read the outlines to plot
	outlines = readOutlines()

	

	#Create Polygons
	patches = []
	colors = []
	for i,outline in enumerate(outlines):
		polygon = Polygon(outline,True)
		colors.append(statistics[i,indexer])
		patches.append(polygon)


	#Min,Max value
	minval = numpy.min(statistics[:,indexer])
	maxval = numpy.max(statistics[:,indexer])

	
	#Figure
	mpl.rcParams['toolbar'] = 'None'
	fig, ax = plt.subplots()
	plt.title(fields[indexer])
	plt.plot(senegal[:,0],senegal[:,1],color='k')

	p = PatchCollection(patches, edgecolor='none',alpha=1.0,cmap=plt.get_cmap('hot'),norm=mpl.colors.Normalize(vmin=minval,vmax=maxval))
	p.set_array(numpy.array(colors))
	ax.add_collection(p)
	plt.colorbar(p)
	plt.show()	



#		plt.plot(outline[:,0],outline[:,1])
#	plt.show()
	