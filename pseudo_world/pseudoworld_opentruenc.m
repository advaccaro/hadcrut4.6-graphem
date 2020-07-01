%pseudoworld_opentruenc.m

%opens pseudoworld truth fields' netCDF files and saves at .mat file
%input is filename w/o directory

function [opath] = pseudoworld_opentruenc(infile)

indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/truth/'; %in-directory
odir = indir; %out-directory

inname = infile;
inpath = [indir inname]; %complete in-file path

%determine pseudoworld number (1-4)
numstr = inname(7);
worldnum = str2num(numstr);

%determine pseudoworld type (SST vs LSAT)
if ~isempty(strfind(infile, 'sst')) == 1
	inletter = 's';
	intype = 'sst';
elseif ~isempty(strfind(infile, 'lsat')) == 1
	inletter = 'l';
	intype = 'lsat';
else
	display('error: could not determine data type')
end

%define out-name and out-path
oname = ['pseudoworld' numstr '_' intype '_truth.mat'];
opath = [odir oname];




ncidin = netcdf.open(inpath); %open netCDF file

%Var IDs (found prior using cfdataset)
latname = 'latitude';
lonname = 'longitude';
timename = 'time';
gridname = 'grid_data';

%find indices for vars
lat_indx = netcdf.inqVarID(ncidin,latname);
lon_indx = netcdf.inqVarID(ncidin,lonname);
time_indx = netcdf.inqVarID(ncidin,timename);
grid_indx = netcdf.inqVarID(ncidin,gridname);

%now import
PWtruth.lat = netcdf.getVar(ncidin,lat_indx);
PWtruth.lon = netcdf.getVar(ncidin,lon_indx);
PWtruth.time = netcdf.getVar(ncidin,time_indx);
PWtruth.grid = netcdf.getVar(ncidin,grid_indx);

%encode NaN's
PWtruth.grid(PWtruth.grid < -999999) = NaN;

%get dims
[nlon,nlat,ntime] = size(PWtruth.grid);
nloc = nlon*nlat;

%reshape grid to 2D
PWtruth.grid_2d = reshape(PWtruth.grid, [nloc, ntime]);
PWtruth.grid_2d = PWtruth.grid_2d'; %time x space
PWtruth.grid_2d = double(PWtruth.grid_2d);

%make loc
[x,y] = meshgrid(PWtruth.lat,PWtruth.lon);
PWtruth.loc = [y(:),x(:)];


if worldnum == 1
	if inletter == 's'
		PW1_sst_truth = PWtruth;
		save(opath, 'PW1_sst_truth');
	elseif inletter == 'l';
		PW1_lsat_truth = PWtruth;
		save(opath, 'PW1_lsat_truth');
	else
		display('error')
	end
elseif worldnum == 2
	if inletter == 's'
		PW2_sst_truth = PWtruth;
		save(opath, 'PW2_sst_truth');
	elseif inletter == 'l';
		PW2_lsat_truth = PWtruth;
		save(opath,'PW2_lsat_truth');
	else
		display('error')
	end
elseif worldnum == 3
	if inletter == 's'
		PW3_sst_truth = PWtruth;
		save(opath,'PW3_sst_truth');
	elseif inletter == 'l';
		PW3_lsat_truth = PWtruth;
		save(opath,'PW3_lsat_truth');
	else
		display('error') 
	end
elseif worldnum == 4
	if inletter == 's'
		PW4_sst_truth = PWtruth;
		save(opath,'PW4_sst_truth');
	elseif inletter == 'l'
		PW4_lsat_truth = PWtruth;
		save(opath,'PW4_lsat_truth');
	else
		display('error')
	end
else
	display('error: unknown world number')
end



