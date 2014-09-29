import sys
import os
import numpy
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt



#------------------------------------------------------------------------
if __name__ == '__main__':


	#Fields
	fields = []
	superdata = numpy.zeros((123,1))
	superdata[:,0] = range(123)



	#Load data
	data = pd.read_csv('data/population_plus.csv')
	columns = list(data.columns.values)
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/age_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/household_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/orphan_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:-2]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:-2]))



	#Load data
	data = pd.read_csv('data/cooking_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:-2]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:-2]))



	#Load data
	data = pd.read_csv('data/school_female_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/school_male_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/education_male_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))
	


	#Load data
	data = pd.read_csv('data/education_female_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/employment_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/occupation_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/literacy_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/massmedia_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/water_electricity_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))



	#Load data
	data = pd.read_csv('data/possessions_plus.csv')
	columns = list(data.columns.values)
	columns = columns[1:]
	fields = fields + columns
	data = numpy.array(data)
	superdata = numpy.hstack((superdata,data[:,1:]))


	#Store
	superdata = pd.DataFrame(superdata)
	superdata.columns = fields
	superdata.to_csv('data/demographics.csv',index=False,format='%2.2f')

	