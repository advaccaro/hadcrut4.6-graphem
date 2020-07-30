#!/usr/bin/python3
'''combine_netcdf.py
Open CCI NetCDF files and combine into single 2d array.
Also constructs monthly time axis.

Adam Vaccaro
'''
import os
import sys
import argparse
import pickle

import numpy as np
from netCDF4 import Dataset


def main(nc_dir, outpath):
    '''Main driver


    '''
    # Find netCDF files
    nc_files = [file for file in os.listdir(nc_dir) if file.endswith('.nc')]

    # Sort by file name (oldest to most-recent)
    nc_files.sort()

    # Number of files (also number of time steps)
    nfiles = len(nc_files)

    # Initialze storage structure
    cci = {
        'sst3' : None,
        'uncertainty3' : None,
        'mask3' : None,
        'sea_fraction3' : None,
        'sea_ice_fraction3' : None,

        'sst2' : None,
        'uncertainty2' : None,
        'mask2' : None,
        'sea_fraction2' : None,
        'sea_ice_fraction2' : None,

        'lon' : None,
        'lat' : None,
        'loc' : None,

        'tfrac': []
    }

    keys3 = [
        'sst3', 'uncertainty3', 'mask3', 
        'sea_fraction3', 'sea_ice_fraction3'
    ]

    # keys2 = [
    #     'sst2', 'uncertainty2', 'mask2',
    #     'sea_fraction2', 'sea_ice_fraction2',
    # ]

    # Set first flag to True
    first = True

    # Initialze counter
    tx = 0

    # Loop through files, open, extract data, and compile into combined dataset
    for file in nc_files:
        # Assemble file path
        filepath = os.path.join(nc_dir, file)

        # Open file
        f = Dataset(filepath, mode='r')

        # Initialze storage structure
        if first:
            # Get spatial metadata
            nlat = f.dimensions['lat'].size
            nlon = f.dimensions['lon'].size
            nloc = nlat * nlon
            # Get latitude and longitude
            cci['lon'] = f.variables['lon'][:].data
            cci['lat'] = f.variables['lat'][:].data


            # Allocate space for 3d arrays
            for key in keys3:
                cci[key] = np.empty((nfiles, nlat, nlon), dtype=np.float32)
            # 2d arrays
            # for key in keys2:
            #     cci[key] = np.empty((nfiles, nloc), dtype=np.float32)

        # Extract relevant data
        [
            sst, mask, tfrac, uncertainty, 
            sea_ice_fraction, sea_fraction
        ] = extract_cci_data(f)
        
        # Save to persisent variable
        cci['sst3'][tx,:,:] = sst
        cci['uncertainty3'][tx,:,:] = uncertainty
        cci['mask3'][tx,:,:] = mask
        cci['sea_fraction3'][tx,:,:] = sea_fraction
        cci['sea_ice_fraction3'][tx,:,:] = sea_ice_fraction

        cci['tfrac'].append(tfrac)

        # Close NetCDF file
        f.close()

        # Increment counter
        tx += 1

    # assert(tx == nfiles) #Make sure all files were read

    ## Reshape to 2d
    # Locations
    [lons, lats] = np.meshgrid(cci['lon'], cci['lat'])
    cci['loc'] = np.transpose(np.array([lons.flatten(), lats.flatten()]))

    # 3D data
    for key in keys3:
        key2 = key.replace('3', '2')
        cci[key2] = reshape3to2(cci[key], nfiles, nloc)
    # cci['sst2'] = reshape3to2(cci['sst3'], nloc)
    # cci['uncertainty2'] = reshape3to2(cci['uncertainty3'] nloc)
    # cci['mask2'] = reshape3to2(cci['mask3'], nloc)
    # cci['sea_fraction3'] = reshape3to2(cci['sea_fraction2'], nloc)
    # cci['sea_ice_fraction3'] = reshape3to2(cci['sea_ice_fraction3'], nloc)


    # Save to pickle
    pickle_out = outpath + '.pkl'
    with open(pickle_out, 'wb') as po:
        pickle.dump(cci, po)

    # Save to netCDF
    netcdf_out = pickle_out.replace('.pkl', '.nc')
    with Dataset(netcdf_out, mode='w', format='NETCDF4_CLASSIC') as f:
        write_cci_netcdf(f, cci)
        # parms = f.createGroup('parameters')
        # for k,v in cci.items():
        #     setattr(parms, k, v)


def write_cci_netcdf(ncfile, cci):
    '''write_cci_netcdf
    Parameters:
    f-
    cci-
    '''
    spatial_keys = ['lat', 'lon', 'loc']
    temporal_keys = ['tfrac']
    temp_keys = ['sst3', 'sst2']
    mask_keys = ['mask3', 'mask2']
    stats_keys = [
        'uncertainty3', 'uncertainty2', 
        'sea_fraction3', 'sea_fraction2',
        'sea_ice_fraction3', 'sea_ice_fraction2'
    ]
    units_dtype_map = {
        'spatial' : {
            'units' : 'degrees', 
            'dtype' : np.float32
        }, 
        'temporal' : {
            'units' :'fractional year', 
            'dtype' : np.float32
        }, 
        'temp' : {
            'units' : 'K', 
            'dtype' : np.float32
        },
        'stats' : {
            'units' : '', 
            'dtype' : np.float32
        },
        'mask' : {
            'units' : 'boolean', 
            'dtype' : np.float32
        }
    }
    dim_map = {
        'temporal' : 'tfrac',
        '3d' : ('tfrac', 'lon', 'lat'),
        '2d' : ('tfrac', 'loc'),
        'spatial' : {'lon' : 'lon', 'lat' : 'lat', 'loc' : ('loc', '2')}
    }
    # Create Dimensions
    for k in 'lat', 'lon', 'tfrac':
        try:
            size = cci[k].shape[0]
        except:
            size = len(cci[k])
        ncfile.createDimension(k, size)

    ncfile.createDimension('loc', len(cci['lon'])*len(cci['lat']))
    ncfile.createDimension('2', 2)



    for k,v in cci.items():
        map_key = None
        if k in spatial_keys:
            map_key = 'spatial'
        elif k in temporal_keys:
            map_key = 'temporal'
        elif k in temp_keys:
            map_key = 'temp'
        elif k in mask_keys:
            map_key = 'mask'
        elif k in stats_keys:
            map_key = 'stats'
        
        dim = None
        if k.endswith('3'):
            dim = dim_map['3d']
        elif k.endswith('2'):
            dim = dim_map['2d']
        elif map_key == 'temporal':
            dim = dim_map[map_key]
        elif map_key == 'spatial':
            dim = dim_map[map_key][k]

        # Create variables
        tmp = ncfile.createVariable(
            k, 
            units_dtype_map[map_key]['dtype'],
            dim
        )
        tmp.units = units_dtype_map[map_key]['units']

        if k.endswith('3'):
            tmp[:,:,:] = v
        elif k.endswith('2'):
            tmp[:,:] = v
        elif map_key == 'temporal':
            tmp[:] = v
        elif map_key == 'spatial':
            if k != 'loc':
                tmp[:] = v
            else:
                tmp[:,:] = v


def extract_cci_data(f):
    '''extract_cci_data
    Parameters:
    f-
    '''
    relevant_keys = [
        'sst', 'sst_uncertainty', 
        'sea_ice_fraction', 'sea_fraction', 
        'calendar_year', 'calendar_month'
    ]
    tmp = {}
    for key in relevant_keys:
        tmp[key] = f.variables[key][:]
    tfrac = tmp['calendar_year'][0] + (tmp['calendar_month'][0]-1)/12
    ssta = tmp['sst'].data[0,:,:]
    mask = tmp['sst'].mask[0,:,:]
    uncertainty = tmp['sst_uncertainty'].data[0,:,:]
    sea_ice_fraction = tmp['sea_ice_fraction'].data[0,:,:]
    sea_fraction = tmp['sea_fraction'].data[0,:,:]
    return([ssta, mask, tfrac, uncertainty, sea_ice_fraction, sea_fraction])

def reshape3to2(data3, nt, ns):
    '''reshape3to2

    Reshapes data from 3 dimensions (t,x,y) -> (t,xy)
    '''
    return(np.transpose(np.reshape(data3, (ns, nt))))


if __name__ == '__main__':
    '''Command line driver

    '''
    main(sys.argv[1],sys.argv[2])