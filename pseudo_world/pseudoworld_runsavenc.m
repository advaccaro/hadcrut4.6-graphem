%pseudoworld_runsavenc.m
%run pseudoworld_savenc.m for all files in a directory

function pseudoworld_runsavenc(indir)

folder = indir;

inletter = folder(61);
if inletter == 's'
	display('type is SST')
	intype = 'sst';
elseif inletter == 'l'
	display('type is LSAT')
	intype = 'lsat';
else
	display('error:invalid data type')
end

world = folder(48:59)


filelist = dir([folder world '_' intype '_graphem_sp*_step2.mat']);
filelist.name
nfiles = length(filelist);
for i = 1:nfiles
	filename = [folder filelist(i).name]
	pseudoworld_savenc(filename)
	clear filename
end
