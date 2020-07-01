%extract data from .mat file and save to .nc
%must enter FULL inpath
%won't work if files are moved

function [opath] = pseudoworld_savenc(inpath)

%% Get inpath info and set outpath
inpath = inpath;
nin = length(inpath);

preamble = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/';
npre = length(preamble);
inpre = inpath(1:npre);
if ~isequal(inpre,preamble) == 1
display('error:invalid filepath')
end

inworld = inpath(48:59); display(inworld);
worldnum = str2num(inworld(end));


inletter = inpath(61);
if inletter == 's'
	intype = 'sst';
	display('type is SST')
	if nin == 108
		sparstag = inpath(end-11:end-10);
	elseif nin == 109
		sparstag = inpath(end-12:end-10);
	else
		display('error: invalid filepath')
	end
elseif inletter == 'l'
	intype = 'lsat';
	display('type is LSAT')
	if nin == 110
		sparstag = inpath(end-11:end-10);
	elseif nin == 111
		sparstag = inpath(end-12:end-10);
	else
		display('error: invalid filepath')
	end
else
	display('error: unknown data type')
end
display(sparstag);
oname = [inworld '_' intype '_graphem_sp' sparstag '.nc'];
opath = [inpre inworld '/' intype '/data/' oname];


%% Extra data from .mat file
load(inpath)

if worldnum == 1
	if inletter == 's'
		PW = PW1_sst;
		index = PW.ocean;
	elseif inletter == 'l';
		PW = PW1_lsat;
		index = PW.land;
	else
		display('error')
	end
elseif worldnum == 2
	if inletter == 's'
		PW = PW2_sst;
		index = PW.ocean;
	elseif inletter == 'l';
		PW = PW2_lsat;
		index = PW.land;
	else
		display('error')
	end
elseif worldnum == 3
	if inletter == 's'
		PW = PW3_sst;
		index = PW.ocean;
	elseif inletter == 'l';
		PW = PW3_lsat;
		index = PW.land;
	else
		display('error') 
	end
elseif worldnum == 4
	if inletter == 's'
		PW = PW4_sst;
		index = PW.ocean;
	elseif inletter == 'l'
		PW = PW4_lsat;
		index = PW.land;
	else
		display('error')
	end
else
	display('error: unknown world number')
end


lat = PW.lat; nlat = length(lat);
lon = PW.lon; nlon = length(lon);
nloc = nlat * nlon;
time = PW.time; ntime = length(time);

grid_2d = nan(ntime,nloc);
grid_2d(:,index) = Xf; %Xf is GraphEM output loaded from input file
gridded_data = reshape(grid_2d', [nlon nlat ntime]);
gridded_data(gridded_data == nan) = -1*10^30;
gridded_data=single(gridded_data);



%% Save data to netCDF file
ncid = netcdf.create(opath,'CLOBBER'); %create netCDF file

%Define dimensions and variables
lonDimId = netcdf.defDim(ncid,'longitude',nlon); lonVarId = netcdf.defVar(ncid,'longitude','float',lonDimId);
latDimId = netcdf.defDim(ncid,'latitude',nlat); latVarId = netcdf.defVar(ncid, 'latitude', 'float',latDimId);
timeDimId = netcdf.defDim(ncid,'time',ntime); timeVarId = netcdf.defVar(ncid,'time','float',timeDimId);
gridVarId = netcdf.defVar(ncid,'gridded_data','float', [lonDimId latDimId timeDimId]);
netcdf.endDef(ncid); %end define mode

%Put data into netCDF variables
netcdf.putVar(ncid,lonVarId,lon);
netcdf.putVar(ncid,latVarId,lat);
netcdf.putVar(ncid,timeVarId,time);
netcdf.putVar(ncid,gridVarId,gridded_data);

netcdf.close(ncid); %close netCDF file

