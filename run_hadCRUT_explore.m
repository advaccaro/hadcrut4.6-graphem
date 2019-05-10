load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/had46med.mat')
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/had46med_full_sp80_merra_krig.mat')
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/cw17/data/cw17.mat')

loc = loc;
lonin = H46med.lon;
latin = H46med.lat;

H46MED_EXP = had43med_explore(had46med,lonin, latin, H46med.tser, loc);
save('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MED_EXP.mat','H46MED_EXP')

H46M80_EXP = had43med_explore(SP1.X,lonin, latin, H46med.tser, loc);
save('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46M80_EXP.mat','H46M80_EXP')

C46MED_EXP = had43med_explore(cw17.temp2d,lonin, latin, datenum(cw17.tvec), loc);
save('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/C46MED_EXP.mat','C46MED_EXP')

H46MNE_EXP = had_explore(CR.X, lonin, latin, H46med.tser, loc);
save('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MNE_EXP.mat', 'H46MNE_EXP');
