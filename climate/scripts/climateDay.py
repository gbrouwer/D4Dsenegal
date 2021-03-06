import os
import sys
import json
import collections
import warnings
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.widgets import Button

basepath='../data'


#------------------------------------------------------------------------------------------
def get_country_shape():

    #Read Shaopes
    with open(os.path.join(basepath,'Senegal_GeoJson.json'),'r') as f:
        geojson=json.loads(f.read())

    #Return
    return geojson['coordinates']


#------------------------------------------------------------------------------------------
def plot_geojson_shape(coords):
    
    if isinstance(coords[0][0], collections.Iterable):
        for c in coords: 
            plot_geojson_shape(c)
    else:
        x = [i for i,j in coords]
        y = [j for i,j in coords]
        print x,y
        plt.plot(x,y,'lightgray')


#------------------------------------------------------------------------------------------
def get_xpix_ypix(nodeid):

    #Get Xpix/Ypix
    ypix = (nodeid-1) & 2**16-1
    xpix = (nodeid-1) >> 16
    
    #Return
    return (xpix,ypix)


#------------------------------------------------------------------------------------------
def lat_lon_from_nodeid(nodeid, res_in_deg):

    #Get LAT/LON
    xpix,ypix = get_xpix_ypix(nodeid)
    lat = (0.5+ypix)*res_in_deg - 90.0
    lon = (0.5+xpix)*res_in_deg - 180.0

    #Return
    return (lat,lon)


#------------------------------------------------------------------------------------------
def nodeid_from_lat_lon(lat, lon, res_in_deg):

    #Get Noide ID 
    xpix = int(math.floor((lon + 180.0) / res_in_deg))
    ypix = int(math.floor((lat + 90.0) / res_in_deg))
    nodeid = (xpix << 16) + ypix + 1

    #Return
    return nodeid


#------------------------------------------------------------------------------------------
def parse_node_offsets(nodeOffsets, n_nodes):

    #Parse Offsets
    nodeIds=[]
    lastOffset=-1
    if len(nodeOffsets)/16 != n_nodes:
        raise Exception('Offset length not compatible with # of nodes from header')
    for i in range(n_nodes):
        nodeId=int(nodeOffsets[i*16:i*16+8],16)
        offset=int(nodeOffsets[i*16+8:i*16+16],16)
        if offset < lastOffset:
            raise Exception('Offsets not sequential')
        else:
            lastOffset=offset
        nodeIds.append(nodeId)

    #Return
    return nodeIds


#------------------------------------------------------------------------------------------
def climate_for_year_from_file(climatefile, year):
    

    #Read JSON
    with open(climatefile+'.json','r') as header:
        hj=json.loads(header.read())
        n_nodes = hj['Metadata']['NodeCount']
        n_tstep = hj['Metadata']['DatavalueCount']
        years   = hj['Metadata']['OriginalDataYears']
        first_year = int(years.split('-')[0])
        #print(os.path.basename(climatefile))
        #print( "\tThere are %d nodes and %d time steps" % (n_nodes, n_tstep) )
        #print( "\tExtracting year %d from file with range %s" % (year, years) )
        nodeIds = parse_node_offsets(hj['NodeOffsets'], n_nodes)


    #Read Binary
    with open(climatefile, 'rb') as bin_file:
        channel_dtype = np.dtype( [ ( 'data', '<f4', (1, n_tstep ) ) ] )
        channel_data = np.fromfile( bin_file, dtype=channel_dtype )
        channel_data = np.transpose( channel_data['data'].reshape(n_nodes, n_tstep) )



    #Grab data
    data = channel_data[365*(year-first_year):365*(year-first_year+1)][:]


    #Count NaNs and INFs
    nan_count = np.isnan(data).sum()
    inf_count = np.isinf(data).sum()


    #Return        
    return nodeIds,data


#------------------------------------------------------------------------------------------
def lons_lats_from_nodes(nodes):

    #Get Lat and Lon
    latlons=[lat_lon_from_nodeid(n,res_in_arcsec/3600.) for n in nodes]

    #Return
    return list(reversed(zip(*latlons)))

#------------------------------------------------------------------------------------------
def scrub_NaNs(values):

    #Scrub
    npvalues=np.array(values)
    scrubbed_values=npvalues[nan_temps==0]

    #Return
    return scrubbed_values


#------------------------------------------------------------------------------------------
if __name__ == '__main__':    


    #Init
    os.system("clear")



    #Parameters
    year = 2013
    res_in_arcsec=150
    prefix = 'Senegal_Gambia_2.5arcmin'
    country_shape=get_country_shape()
    

    #Save Country Shape
    pos = np.array(country_shape[0])[0,:,:]
    with open('senegal.txt','w') as f:
        for i in range(pos.shape[0]):
            f.write(str(pos[i,0]) + ',' + str(pos[i,1]) + '\n')
            



    #Load
    rainNodes,rains   = climate_for_year_from_file(os.path.join(basepath, prefix + '_rainfall_daily.bin'), year)
    tempNodes,temps   = climate_for_year_from_file(os.path.join(basepath, prefix + '_air_temperature_daily.bin'), year)
    humidNodes,humids = climate_for_year_from_file(os.path.join(basepath, prefix + '_relative_humidity_daily.bin'), year)


    print rains[0]    

    """


    #Convert to Lon/Lat
    rainpos=lons_lats_from_nodes(rainNodes)
    temppos=lons_lats_from_nodes(tempNodes)
    humidpos=lons_lats_from_nodes(humidNodes)
    


    #Get Specific Day
    day_of_year=301
    rain  = rains[day_of_year-1,:]
    temp  = temps[day_of_year-1,:]
    humid = humids[day_of_year-1,:]



    rain  = rains[day_of_year-1,:]
    plt.scatter(rainpos[0],rainpos[1],c=rain,lw=0)
    plt.show()
    
    #rain = rains[:,5000]
    #plt.plot(rain)
    #plt.show()
    """

