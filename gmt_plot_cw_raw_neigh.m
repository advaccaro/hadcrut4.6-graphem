%gmt_plot2.m


%Load GMT datasets
load_gmt_datasets
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MNE_EXP.mat')
%Load ensemble
%load('/home/geovault-02/avaccaro/HadCRUT4.6/ensemble/data/ENS_SP80.mat')

%Abbreviate dataset names
HR = H46MED_EXP;
HG = H46M60_EXP;
G = GISTEMP_GMT;
CW = C46MED_EXP;
N = NOAA_GMT;
E = ENS;
CR = H46MNE_EXP;
%E = ENS; %screen broken records out here (for now)
%ind_in = setdiff(1:97,19); %#19, (file 26) screened out
%E.GMTm = ENS.GMTm(:,ind_in);
%E.NINO34m = ENS.GMTm(:,ind_in);
%E.GMTm = ENS.GMTm;
%E.NINO34m = ENS.G
E.GMTm = ENS.globalmean;

%Flip datenum time axes (because it's a pain in the ass)
HR.tmdn = flipud(HR.tmdn);
%HU.tmdn = flipud(HU.tmdn);
HG.tmdn = flipud(HG.tmdn);
%G.tmdn = flipud(G.tmdn); %already oriented in the proper direction!  Hooray!
CW.tmdn = flipud(CW.tmdn);
CR.tmdn = flipud(CR.tmdn);



%% Get indices of recent (1985-present)
HR.trec_ind = find(HR.tmfrac >= 1985); ind1 = HR.trec_ind
HG.trec_ind = find(HG.tmfrac >= 1985); ind2 = HG.trec_ind;
G.trec_ind = find(G.tmfrac >= 1985); ind3 = G.trec_ind;
CW.trec_ind = find(CW.tmfrac >= 1985); ind4 = CW.trec_ind;
CR.trec_ind = find(CR.tmfrac >= 1985); ind5 = CR.trec_ind; 
N.trec_ind = find(N.tmfrac >= 1985);


%% Plotting
load JEG_graphics
dark_gray = .3*[1 1 1];
light_gray = .7*[1 1 1];

% 1985-Present
fig('1985 - Present');
hold on;
plot(HR.tmdn(HR.trec_ind), HR.GMTm(HR.trec_ind),'k', 'LineWidth', 1.5);
%plot(HG.tmdn(HG.trec_ind), HG.GMTm(HG.trec_ind));
%plot(CW.tmdn(CW.trec_ind), CW.GMTm(CW.trec_ind));
plot(CR.tmdn(CR.trec_ind), CR.GMTm(CR.trec_ind), 'LineWidth', 1.5);
plot(N.tmdn(N.trec_ind), N.GMTm(N.trec_ind), 'LineWidth', 1.5);
 
legstr1 = ['ST Kriging - Linear trend = ' num2str(CR.trendcoeffr) '(\circC/century)'];
legstr2 = ['ST GAM - Linear trend = ' num2str(N.trendcoeffr) '(\circC/century)'];
legstr3 = ['Raw - Linear trend = ' num2str(HR.trendcoeffr) '(\circC/century)'];

datetick('x','yyyy')
%hleg = legend('GraphEM', 'CW14', 'ST Kriging', 'ST GAM', 'Raw');
%hleg = legend('ST Kriging', 'ST GAM', 'Raw');
hleg = legend(legstr3, legstr1, legstr2 );
set(hleg, 'Location', 'SouthEast');
legend('boxoff');
ylabel_str = 'Temperature anomaly (\circC)';
fancyplot_deco('GMT 1985 - Present', 'Time (Year)', ylabel_str, 14, 'Helvetica')



%save/print
odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/figs/';
%figname = 'gmt_plot2.eps';
figname = 'gmt_cw_neigh_raw.jpeg';
figpath = [odir figname];
%hepta_figprint(figpath)
print(figpath, '-cmyk', '-djpeg')







