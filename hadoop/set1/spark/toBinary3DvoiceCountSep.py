import sys
import math
import re
import numpy as np
from scipy.stats.mstats import gmean

from operator import add
from pyspark import SparkContext



#------------------------------------------------------------------------------------
def parseTowers(strs):

	#Split
	elements = strs.encode('ascii','ignore').split(',')

	#Return
	return int(elements[0]),int(elements[1])

#------------------------------------------------------------------------------------
def parseFile(strs):


    #Split and clean
    elements = strs.encode('ascii','ignore').split('\t')
    newelements = elements[0][1:-1].split(',')
    
    #Return
    return int(newelements[0]),int(newelements[1]),int(newelements[2]),int(elements[1])


#------------------------------------------------------------------------------------
def replace(mytuple,towers):


	#Replace
	keyval,fromval,toval,count = mytuple
	fromval = towers[fromval-1,1]
	toval = towers[toval-1,1]


	#Return
	return (keyval,fromval,toval),count


#------------------------------------------------------------------------------------
def aggregateCount(aggdata):


    #Group
    aggdata = aggdata.groupByKey()


    #Compute
    aggdata = aggdata.map(lambda x: (x[0],sum(x[1])))
    aggdata = aggdata.sortByKey()


    #Collect
    aggdata = aggdata.collect()


    #Return
    return aggdata


#------------------------------------------------------------------------------------
if __name__ == "__main__":



	#Init
	sc = SparkContext(sys.argv[1], "Python Spark")



	#Read Towers
	towers = sc.textFile('/user/gijs/d4d/towers')
	towers = towers.map(lambda x: parseTowers(x))
	towers = np.array(towers.collect())



	#Read File
	data = sc.textFile('/user/gijs/d4d/set1/' + sys.argv[2])
	data = data.map(lambda x: parseFile(x))



	#Loop through week ranges
	for wrange in range(1,52,5):

		#Range
		startval = wrange
		endval = wrange + 5 - 1
		newdata = data.filter(lambda x: x[0] >= startval and x[0] <= endval)

		#Replace tower with district
		newdata = newdata.map(lambda x: replace(x,towers))

		#Group 
		newdata = aggregateCount(newdata)

		#Save
		with open('aggregated/' + sys.argv[2] + '_district_count' + str(wrange),'w') as f:
			for item in newdata:
				left,count = item
				keyval,fromval,toval = left
				f.write(str(keyval) + ',' + str(fromval) + ',' + str(toval) + ',' + str(count) + '\n')

