%nino_plot.m

%Load NINO3.4 datasets
load_nino_datasets

%load ensemble
%load('/home/geovault-02/avaccaro/HadCRUT4.6/ensemble/data/ENS_SP80.mat')

% Abbreviate dataset names
B = BUNGE_NINO;
C = COBE_NINO;
CW = C46MED_EXP;
E = ERSSTv5_NINO;
HR = H46MED_EXP;
HG = H46M80_EXP;
K = Kext_NINO;
%E = ENS;
ENS.NINO34m = ENS.nino34;
%E = ENS; %screen broken records out here (for now)
%ind_in = setdiff(1:97,19); %#19, (file 26) screened out
%ENS.NINO34m = ENS.NINO34m(:,ind_in);
[nt,nf] = size(ENS.nino34); ENS.tmfrac = ENS.tfrac;
ENS.tmdn = (ENS.tser);
%ENS.tmdn = flipud(HR.tmdn);
%ENS.tmdn(end+1) = ENS.tmdn(end) + 30;
[Hind1,Hind2] = find_overlap(ENS.tmfrac,HR.tmfrac);
ENS.NINO34m_Hdiff = ENS.NINO34m(Hind1,:) - repmat(HR.NINO34m(Hind2), [1 nf]);
[Kind1,Kind2] = find_overlap(ENS.tmfrac,K.tmfrac);
ENS.NINO34m_Kdiff = ENS.NINO34m(Kind1,:) - repmat(K.NINO34m(Kind2), [1 nf]);
[Cind1,Cind2] = find_overlap(ENS.tmfrac,CW.tmfrac);
ENS.NINO34m_Cdiff = ENS.NINO34m(Cind1,:) - repmat(CW.NINO34m(Cind2), [1 nf]);

for i = 1:nt
	NINOsum(i,:) = quantile(ENS.NINO34m(i,:),[.025 .25 .5 .75 .975]);
end
for i = 1:length(ENS.NINO34m_Hdiff(:,1))
	NINOsum_Hdiff(i,:) = quantile(ENS.NINO34m_Hdiff(i,:),[.025 .25 .5 .75 .975]);
end
for i = 1:length(ENS.NINO34m_Kdiff(:,1))
	NINOsum_Kdiff(i,:) = quantile(ENS.NINO34m_Kdiff(i,:),[.025 .25 .5 .75 .975]);
end
for i = 1:length(ENS.NINO34m_Cdiff(:,1))
	NINOsum_Cdiff(i,:) = quantile(ENS.NINO34m_Cdiff(i,:),[.025 .25 .5 .75 .975]);
end

%calculate envelopes
[vertxsqO, y2O, ZO] = fill3_prep(ENS.tmdn',NINOsum(:,5)',NINOsum(:,1)');
[vertxsqI, y2I, ZI] = fill3_prep(ENS.tmdn',NINOsum(:,4)',NINOsum(:,2)');
[vertxsqO_H,y2O_H,ZO_H] = fill3_prep(flipud(HR.tmdn)',NINOsum_Hdiff(:,5)',NINOsum_Hdiff(:,1)');
[vertxsqI_H,y2I_H,ZI_H] = fill3_prep(flipud(HR.tmdn)',NINOsum_Hdiff(:,4)',NINOsum_Hdiff(:,2)');
[vertxsqO_K,y2O_K,ZO_K] = fill3_prep(K.tmdn(Kind2)',NINOsum_Kdiff(:,5)',NINOsum_Kdiff(:,1)');
[vertxsqI_K,y2I_K,ZI_K] = fill3_prep(K.tmdn(Kind2)',NINOsum_Kdiff(:,4)',NINOsum_Kdiff(:,2)');
[vertxsqO_C,y2O_C,ZO_C] = fill3_prep(CW.tmdn(Cind2)',NINOsum_Cdiff(:,5)',NINOsum_Cdiff(:,1)');
[vertxsqI_C,y2I_C,ZI_C] = fill3_prep(CW.tmdn(Cind2)',NINOsum_Cdiff(:,4)',NINOsum_Cdiff(:,2)');



%flip datenum time axes (because it's a pain in the rear end)
C.tmdn = flipud(C.tmdn);
CW.tmdn = flipud(CW.tmdn);
E.tmdn = flipud(E.tmdn);
HR.tmdn = flipud(HR.tmdn);
%HU.tmdn = flipud(HU.tmdn);
HG.tmdn = flipud(HG.tmdn);
ENS.tmdn = flipud(ENS.tmdn);

%% Calculate differences to HadCRUT4.6 median raw

HG.NINO34m_Hdiff = HG.NINO34m - HR.NINO34m;
[CW.Hind1,CW.Hind2] = find_overlap(CW.tmfrac,HR.tmfrac);
CW.NINO34m_Hdiff = CW.NINO34m(CW.Hind1) - HR.NINO34m(CW.Hind2);




%% Calculate differences to Cowtan & Way
%HadCRUT family
[CWind1,CWind2] = find_overlap(HR.tmfrac,CW.tmfrac);
HG.NINO34m_Cdiff = HG.NINO34m(CWind1) - CW.NINO34m(CWind2);
HR.NINO34m_Cdiff = HR.NINO34m(CWind1) - CW.NINO34m(CWind2);





%% Calculate differences to Kaplan


%Bunge
%clear X
[B.Kind1,B.Kind2] = find_overlap(B.tmfrac,K.tmfrac);
B.NINO34m_Kdiff = B.NINO34m(B.Kind1) - K.NINO34m(B.Kind2);



% ERSSTv4
[E.Kind1,E.Kind2] = find_overlap(E.tmfrac,K.tmfrac);
E.NINO34m_Kdiff = E.NINO34m(E.Kind1) - K.NINO34m(E.Kind2);

%COBE
[C.Kind1,C.Kind2] = find_overlap(C.tmfrac,K.tmfrac);
C.NINO34m_Kdiff = C.NINO34m(C.Kind1) - K.NINO34m(C.Kind2);

%HadCRUT4.6 GraphEM
[HG.Kind1,HG.Kind2] = find_overlap(HG.tmfrac,K.tmfrac);
HG.NINO34m_Kdiff = HG.NINO34m(HG.Kind1) - K.NINO34m(HG.Kind2);





%% Plotting
load JEG_graphics
light_gray = .3*[1 1 1];
dark_gray = .7*[1 1 1];


%NINO3.4 Panels 1-2 (HadCRUT family w/ differences)
fig('HadCRUT family NINO3.4 w/ differences'); clf;
subplot(2,1,1);
hold on;
hp1 = fill3(vertxsqO,y2O,ZO,light_gray);
hp2 = fill3(vertxsqI,y2I,ZI,dark_gray);
set(hp1,'EdgeColor',light_gray); set(hp2,'EdgeColor',dark_gray);
p2=plot(HR.tmdn,HR.NINO34m,'color','g');
p3=plot(CW.tmdn,CW.NINO34m,'color','r');
p1=plot(HG.tmdn,HG.NINO34m,'color','k');
datetick('x','yyyy')
%[hleg,objh] = legend([p1,p2,p3],{'GraphEM ensemble median (0.8% sparsity)', 'HadCRUT4.6 median raw', 'HadCRUT4.6 Cowtan & Way'});
[hleg,objh] = legend([p1,hp2,hp1,p2,p3],{'GraphEM ensemble median (0.8% sparsity)', 'GraphEM ensemble 25-75%', 'GraphEM ensemble 2.5-97.5%','HadCRUT4.6 median raw', 'HadCRUT4.6 Cowtan & Way'});
set(hleg,'Location','SouthEast')
set(objh,'linewidth',2)
legend('boxoff')
ylabel_str = ['Temperature (' char(176) 'C)'];
fancyplot_deco('Monthly NINO3.4 index for various temperature products', 'Time (Year)', ylabel_str,14,'Helvetica')

subplot(2,1,2); hold on;
hp3 = fill3(vertxsqO_H,y2O_H,ZO_H,light_gray);
hp4 = fill3(vertxsqI_H,y2I_H,ZI_H,dark_gray);
set(hp3,'EdgeColor',light_gray); set(hp4,'EdgeColor',dark_gray);
p5=plot(CW.tmdn(CW.Hind1),CW.NINO34m_Hdiff,'color','r');
p4=plot(HG.tmdn,HG.NINO34m_Hdiff,'color','k');
datetick('x','yyyy')
%[hleg,objh] = legend([p4,p5], {'GraphEM ensemble median (0.8% sparsity)', 'HadCRUT4.6 Cowtan & Way'});
%[hleg,objh] = legend([p4,hp4,hp3,p5],{'GraphEM ensemble median (0.8% sparsity)', 'GraphEM ensemble 25-75%', 'GraphEM ensemble 2.5-97.5%', 'HadCRUT4.6 Cowtan & Way'});
%set(hleg,'Location','SouthEast')
%set(objh,'linewidth',2)
%legend('boxoff')
fancyplot_deco('Same, difference from HadCRUT 4.6 median raw', 'Time (Year)', '{\Delta}T ({\circ}C)',14,'Helvetica')

%save/print
odir = '/home/geovault-02/avaccaro/hadCRUT4.6/figs/';
oname = 'nino_ens_plot1.pdf';
otag = [odir oname];
%hepta_figprint(otag)
print(otag, '-dpdf', '-cmyk', '-fillpage');



%NINO3.4 Panels 1-2 (HadCRUT family w/ differences to CW)
fig('HadCRUT family NINO3.4 w/ differences to CW'); clf;
subplot(2,1,1);
hold on;
hp1 = fill3(vertxsqO,y2O,ZO,light_gray);
hp2 = fill3(vertxsqI,y2I,ZI,dark_gray);
set(hp1,'EdgeColor',light_gray); set(hp2,'EdgeColor',dark_gray);
p2=plot(HR.tmdn,HR.NINO34m,'color','g');
p3=plot(CW.tmdn,CW.NINO34m,'color','r');
p1=plot(HG.tmdn,HG.NINO34m,'color','k');
datetick('x','yyyy')
%[hleg,objh] = legend([p1,p2,p3],{'GraphEM ensemble median (0.8% sparsity)', 'HadCRUT4.6 median raw', 'HadCRUT4.6 Cowtan & Way'});
[hleg,objh] = legend([p1,hp2,hp1,p2,p3],{'GraphEM ensemble median (0.8% sparsity)', 'GraphEM ensemble 25-75%', 'GraphEM ensemble 2.5-97.5%','HadCRUT4.6 median raw', 'HadCRUT4.6 Cowtan & Way'});
set(hleg,'Location','SouthEast')
set(objh,'linewidth',2)
legend('boxoff')
ylabel_str = ['Temperature (' char(176) 'C)'];
fancyplot_deco('Monthly NINO3.4 index for various temperature products', 'Time (Year)', ylabel_str,14,'Helvetica')

subplot(2,1,2); hold on;
hp3 = fill3(vertxsqO_C,y2O_C,ZO_C,light_gray);
hp4 = fill3(vertxsqI_C,y2I_C,ZI_C,dark_gray);
set(hp3,'EdgeColor',light_gray); set(hp4,'EdgeColor',dark_gray);
p5=plot(HR.tmdn(CWind1),HR.NINO34m_Cdiff,'color','g');
p4=plot(HG.tmdn,HG.NINO34m_Cdiff,'color','k');
datetick('x','yyyy')
%[hleg,objh] = legend([p4,p5], {'GraphEM ensemble median (0.8% sparsity)', 'HadCRUT4.6 Cowtan & Way'});
[hleg,objh] = legend([p4,hp4,hp3,p5],{'GraphEM ensemble median (0.8% sparsity)', 'GraphEM ensemble 25-75%', 'GraphEM ensemble 2.5-97.5%', 'HadCRUT4.6 median raw'});
set(hleg,'Location','SouthEast')
set(objh,'linewidth',2)
legend('boxoff')
fancyplot_deco('Same, difference to HadCRUT 4.6 Cowtan and Way', 'Time (Year)', '{\Delta}T ({\circ}C)',14,'Helvetica')

%save/print
odir = '/home/geovault-02/avaccaro/hadCRUT4.6/figs/';
oname = 'nino_ens_plot3.pdf';
otag = [odir oname];
%hepta_figprint(otag)
print(otag, '-dpdf', '-cmyk', '-fillpage');









%NINO3.4 Panels 3-4 (all the pals)

fig('NINO34 fig 2'); clf
%subplot(4,1,3); hold on;
%subplot(5,1,1:2); hold on;
subplot(2,1,1); hold on;
%hp5 = fill3(fliplr(vertxsqO),(y2O),fliplr(ZO),light_gray);
%hp6 = fill3(fliplr(vertxsqI),(y2I),fliplr(ZI),dark_gray);
%set(hp5,'EdgeColor',light_gray); set(hp6,'EdgeColor',dark_gray);
hp1 = fill3(vertxsqO, y2O, ZO, light_gray);
hp2 = fill3(vertxsqI, y2I, ZI, dark_gray);
set(hp1, 'EdgeColor', light_gray);
set(hp2, 'EdgeColor', dark_gray);
p7=plot(K.tmdn,K.NINO34m,'color',dark_green);
p8=plot(B.tmdn,B.NINO34m,'color',dark_violet);
p9=plot(E.tmdn,E.NINO34m,'color',firebrick);
p10=plot(C.tmdn,C.NINO34m,'color',pink);
p6=plot(HG.tmdn,HG.NINO34m,'color','k');
datetick('x','yyyy')
ylim([-7 4]);
%[hleg,objh] = legend([p6,p7,p8,p9,p10], {'GraphEM ensemble median (0.8% sparsity)','Kaplan','Bunge & Clarke','ERSSTv4','COBE'});
%[hleg,objh] = legend([p6,hp6,hp5,p7,p8,p9,p10], {'GraphEM ensemble median (0.8% sparsity)','GraphEM ensemble 25-75%','GraphEM ensemble 2.5-97.5%','Kaplan','Bunge & Clarke','ERSSTv5','COBE'});
[hleg,objh] = legend([p6,hp2,hp1,p7,p8,p9,p10], {'GraphEM ensemble median (0.8% sparsity)','GraphEM ensemble 25-75%','GraphEM ensemble 2.5-97.5%','Kaplan','Bunge & Clarke','ERSSTv5','COBE'});
set(hleg,'Location','SouthEast')
set(objh,'linewidth',2)
legend('boxoff')
fancyplot_deco('Monthly NINO3.4 index for various temperature products', 'Time (Year)', ylabel_str,14,'Helvetica')
%subplot(5,1,3); hold on;
%axis off
%[hleg,objh] = legend([p6,hp2,hp1,p7,p8,p9,p10], {'GraphEM ensemble median (0.8% sparsity)','GraphEM ensemble 25-75%','GraphEM ensemble 2.5-97.5%','Kaplan','Bunge & Clarke','ERSSTv5','COBE'});
%set(hleg,'Location','SouthEast')
%set(objh,'linewidth',2)
%set(hleg, 'Position', [.7 .46 .12 .1]);
%legend('boxoff')


%subplot(5,1,4:5); hold on;
subplot(2,1,2); hold on;
hp7 = fill3(vertxsqO_K,y2O_K,ZO_K,light_gray);
hp8 = fill3(vertxsqI_K,y2I_K,ZI_K,dark_gray);
set(hp7,'EdgeColor',light_gray); set(hp8,'EdgeColor',dark_gray);
p12=plot(B.tmdn(B.Kind1),B.NINO34m_Kdiff,'color',dark_violet);
p13=plot(E.tmdn(E.Kind1),E.NINO34m_Kdiff,'color',firebrick);
p14=plot(C.tmdn(C.Kind1),C.NINO34m_Kdiff,'color',pink);
p11=plot(HG.tmdn(HG.Kind1),HG.NINO34m_Kdiff,'color','k');
datetick('x','yyyy');
%[hleg,objh] = legend([p11,p12,p13,p14],{'GraphEM ensemble median (0.8% sparsity)','Bunge & Clarke', 'ERSSTv5', 'COBE'});
%[hleg,objh] = legend([p11,hp8,hp7,p12,p13,p14], {'GraphEM ensemble median (0.8% sparsity)','GraphEM ensemble 25-75%','GraphEM ensemble 2.5-97.5%','Bunge & Clarke','ERSSTv5','COBE'});
%set(hleg,'Location','SouthEast')
%set(objh,'linewidth',2)
%legend('boxoff')
fancyplot_deco('Same, difference to Kaplan', 'Time (Year)', '{\Delta}T ({\circ}C)',14,'Helvetica')

%save/print
odir = '/home/geovault-02/avaccaro/hadCRUT4.6/figs/';
oname = 'nino_ens_plot2.pdf';
otag = [odir oname];
%hepta_figprint(otag)
print(otag, '-dpdf', '-cmyk', '-fillpage');





