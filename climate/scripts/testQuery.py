import os
import sys
import numpy as np
import math
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import climateQuery as cq


#------------------------------------------------------------------------
def convert2colormap(myarray):

	#Init
	colors = np.random.random((myarray.shape[0],3))

	myarray = myarray - np.min(myarray)
	myarray = myarray / np.max(myarray)
	colors[:,0] = myarray
	colors[:,1] = 0.0
	colors[:,2] = 0.0



	#Return
	return colors

#------------------------------------------------------------------------
if __name__ == '__main__':


	#Load the biggest cities in Senegal
	bigcities = pd.read_csv('../meta/bigcities.csv', delimiter=',',header=None)


	#Load Outline
	outline = pd.read_csv('../meta/senegal_outline.csv', delimiter=',',header=None)
	outline = np.array(outline)



	#Lon/Lats/
	bigcities = np.array(bigcities)
	locations = bigcities[:,3:]



	#Population
	populations = np.zeros((bigcities.shape[0],1))
	populations[:,0] = bigcities[:,2]
	normpop = np.log10(populations) ** 3



	#Query climateQuery
	rain,temperature,humidity = cq.query(locations,2013)



	#Average and plot
	meanrain = np.mean(rain,axis=0)
	meanhumid = np.mean(humidity,axis=0)
	meantemp = np.mean(temperature,axis=0)
	colors = convert2colormap(meantemp)



	#Visualize
	plt.plot(outline[:,0],outline[:,1],color='k')
	plt.scatter(locations[:,0],locations[:,1],c=colors,lw=0,s=normpop)
	plt.show()
