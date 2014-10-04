import sys
import os
import numpy
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt


#------------------------------------------------------------------------
if __name__ == '__main__':


	
	#Load the arrond01
	fulldata = numpy.zeros((1666,35))
	for i in range(25):
		if (i < 9):
			filename = 'data/arrond0' + str(i+1)
		else:
			filename = 'data/arrond' + str(i+1)
		data = pd.read_csv(filename,delimiter='\t')
		columns = data.columns.values;
		data = numpy.array(data)
		for i in range(data.shape[0]):
			index = int(data[i,0] - 1)
			fulldata[index,:-1] = fulldata[index,:-1] + data[i,:]
			fulldata[index,-1] = fulldata[index,-1] + 1

	
	#Normalize
	for i in range(fulldata.shape[0]):
		fulldata[i,:-1] = fulldata[i,:-1] / fulldata[i,-1]


	#Store full data
	fulldata = pd.DataFrame(fulldata[:,:-1])
	fulldata.columns = columns
	fulldata.to_csv('data/arrond.csv',index=False)