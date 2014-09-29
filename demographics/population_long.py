import sys
import os
import numpy
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt


#------------------------------------------------------------------------
def parseData(filename):

	#Loop
	population = []
	gender = []
	dept = []
	deptid = []
	year = []
	area = []
	with open(filename,'r') as f:
		for line in f:
			elements = line.rstrip().split(';')
			newelements = elements[0].split('.')
			population.append(newelements[0])
			gender.append(elements[2])
			deptid.append(elements[3])
			dept.append(elements[4])
			year.append(elements[-1][:4])
			if (len(elements) != 6):
				area.append(elements[6])
			else:
				area.append('COMBINED')
	

	#To Integer
	population = [int(pop) for pop in population]
	year = [int(thisyear) for thisyear in year]
	deptid = [int(id) for id in deptid]



	#To Numpy array
	population = numpy.array(population)
	gender = numpy.array(gender)
	dept = numpy.array(dept)
	deptid = numpy.array(deptid)
	year = numpy.array(year)
	area = numpy.array(area)


	#Return
	return population,gender,dept,deptid,year,area


#------------------------------------------------------------------------
if __name__ == '__main__':


	#Parse Data
	population,gender,dept,deptid,year,area = parseData('population.csv')

	
	#Load the Department and arrondissement
	deplist = pd.read_csv('dept.csv')
	deplist = numpy.array(deplist)



	#Empty Array
	P = numpy.zeros((123,3,3,8))


	#Loop to find hits
	arrlist = []
	for department in numpy.unique(dept):
		arrvalues = []
		for i in range(deplist.shape[0]):
			if deplist[i,-2] in department:
				arrvalues.append(deplist[i,0]-1)

		indices = numpy.where(dept == department)[0]
		yindices = year[indices] - 2008
		tmp = gender[indices]
		gindices = []
		for element in tmp:
			if element == 'Men':
				gindices.append(0)
			if element == 'Women':
				gindices.append(1)
			if element == 'Total':
				gindices.append(2)
		gindices = numpy.array(gindices)

		tmp2 = area[indices]
		aindices = []
		for element in tmp2:
			if element == 'RURAL AREA':
				aindices.append(0)
			if element == 'URBAN AREA':
				aindices.append(1)
			if element == 'COMBINED':
				aindices.append(2)
		aindices = numpy.array(aindices)

		populations = population[indices]
		for arrval in arrvalues:
			for i in range(populations.shape[0]):
				P[arrval,aindices[i],gindices[i],yindices[i]] = populations[i]


	#Store
	with open('populationMatrix.csv','w') as f:
		for i in range(123):
			for j in range(3):
				for l in range(3):
					for m in range(8):
						f.write(str(int(P[i,j,l,m])) + '\n')





