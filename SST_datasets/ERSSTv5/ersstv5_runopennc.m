%ersstv5_runopennc.m
%run ersstv5_opennc.m for all files in a directory

function ersstv5_runopennc(indir)

folder = indir;



filelist = dir([folder '*.nc']);
nfiles = length(filelist);
for i = 1:nfiles
	filename = [filelist(i).name]
	ersstv5_opennc(filename)
	clear filename
end
