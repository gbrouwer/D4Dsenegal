import sys
import os
import numpy
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt




#------------------------------------------------------------------------
if __name__ == '__main__':


	#Load the Department and arrondissement
	deplist = pd.read_csv('data/dept.csv')
	deplist = numpy.array(deplist)



	#Load the Department and arrondissement
	demolist = pd.read_csv('data/' + sys.argv[1] + '.csv')
	demoarray = numpy.array(demolist)

	fields = demolist.columns.values
	fields = [field.encode('ascii','ingore') for field in fields]
	with open(sys.argv[1] + '_plus.csv','w') as f:
		f.write('arr')
		for i in range(1,len(fields)):
			f.write(',' + fields[i])
		f.write('\n')
		
		for i in range(deplist.shape[0]):
			if (deplist[i,1] == 'DAKAR'):
				index = 1
			if (deplist[i,1] == 'DIOURBEL'):
				index = 4
			if (deplist[i,1] == 'FATICK'):
				index = 9
			if (deplist[i,1] == 'LOUGA'):
				index = 8
			if (deplist[i,1] == 'KAOLACK'):
				index = 7
			if (deplist[i,1] == 'KAFFRINE'):
				index = 6
			if (deplist[i,1] == 'SAINT-LOUIS'):
				index = 17
			if (deplist[i,1] == 'KOLDA'):
				index = 14
			if (deplist[i,1] == 'SEDHIOU'):
				index = 13
			if (deplist[i,1] == 'ZIGUINCHOR'):
				index = 11
			if (deplist[i,1] == 'KEDOUGOU'):
				print i
				index = 19
			if (deplist[i,1] == 'TAMBACOUNDA'):
				index = 20
			if (deplist[i,1] == 'MATAM'):
				index = 16
		
			f.write(str(i))
			val = demoarray[index,1:]
			for j in range(val.shape[0]):
				f.write(',' + str(val[j]))
			f.write('\n')

		#print 