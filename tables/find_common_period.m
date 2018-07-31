%% find_common_period.m
%
% USC Climate Dynamics Lab - Adam Vaccaro

addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))

load_gmt_datasets

C=C46MED_EXP;
G=GISTEMP_GMT;
HR=H46MED_EXP;
HG=H46M80_EXP;
N=NOAA_GMT;

min_times = [min(C.tmdn), min(G.tmdn), min(HR.tmdn), min(HG.tmdn), min(N.tmdn)];
min_time = max(min_times);

max_times = [max(C.tmdn), max(G.tmdn), max(HR.tmdn), max(HG.tmdn), max(N.tmdn)];
max_time = min(max_times);
