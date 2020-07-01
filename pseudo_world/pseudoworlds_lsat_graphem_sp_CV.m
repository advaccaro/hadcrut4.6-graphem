%pseudoworlds_lsat_graphem_sp_CV.m

addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/'))
addpath('/home/scec-02/avaccaro/HadCRUT4.2/ensemble/')
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/data/truth/'))

%% load raw data
load('pseudoworld1_lsat.mat'); [ntime1,nspace1] = size(PW1_lsat.grid_2d);
load('pseudoworld2_lsat.mat'); [ntime2,nspace2] = size(PW2_lsat.grid_2d);
load('pseudoworld3_lsat.mat'); [ntime3,nspace3] = size(PW3_lsat.grid_2d);
load('pseudoworld4_lsat.mat'); [ntime4,nspace4] = size(PW4_lsat.grid_2d);
loc = PW1_lsat.loc; lats = loc(:,2);
lats1_2d = repmat(lats,[1 ntime1]); lats1_2d = lats1_2d';
lats2_2d = repmat(lats,[1 ntime2]); lats2_2d = lats2_2d';
lats3_2d = repmat(lats,[1 ntime3]); lats3_2d = lats3_2d';
lats4_2d = repmat(lats,[1 ntime4]); lats4_2d = lats4_2d';




%% load CV scores
PW1_CV = load('pseudoworld1_lsat_CVscores10.mat');
PW2_CV = load('pseudoworld2_lsat_CVscores10.mat');
PW3_CV = load('pseudoworld3_lsat_CVscores10.mat');
PW4_CV = load('pseudoworld4_lsat_CVscores10.mat');

%calculate envelopes
Scases1 = [PW1_CV.Scases]; Ncases1 = length(Scases1);
Sqcases1 = [Scases1 Scases1];
Scases2 = [PW2_CV.Scases]; Ncases2 = length(Scases2);
Sqcases2 = [Scases2 Scases2];
Scases3 = [PW3_CV.Scases]; Ncases3 = length(Scases3);
Sqcases3 = [Scases3 Scases3];
Scases4 = [PW4_CV.Scases]; Ncases4 = length(Scases4);
Sqcases4 = [Scases4 Scases4];


pw1top = PW1_CV.epe3+PW1_CV.sigg3; pw1bot = PW1_CV.epe3-PW1_CV.sigg3;
pw2top = PW2_CV.epe3+PW2_CV.sigg3; pw2bot = PW2_CV.epe3-PW2_CV.sigg3;
pw3top = PW3_CV.epe3+PW3_CV.sigg3; pw3bot = PW3_CV.epe3-PW3_CV.sigg3;
pw4top = PW4_CV.epe3+PW4_CV.sigg3; pw4bot = PW4_CV.epe3-PW4_CV.sigg3;


pw1v = zeros(2*Ncases1,1); pw2v = zeros(2*Ncases2,1); 
pw3v = zeros(2*Ncases3,1); pw4v = zeros(2*Ncases4,1);

Sverts1 = zeros(2*Ncases1,1);
Sverts2 = zeros(2*Ncases2,1);
Sverts3 = zeros(2*Ncases3,1);
Sverts4 = zeros(2*Ncases4,1);

for j = 1:Ncases1
Sverts1(2*j) = Scases1(j);
Sverts1(1+(2*(j-1))) = Scases1(j);
pw1v(2*j) = pw1top(j);
pw1v(1+2*(j-1)) = pw1bot(j);
end

for j = 1:Ncases2
Sverts2(2*j) = Scases2(j);
Sverts2(1+(2*(j-1))) = Scases2(j);
pw2v(2*j) = pw2top(j);
pw2v(1+2*(j-1)) = pw2bot(j);
end

for j = 1:Ncases3
Sverts3(2*j) = Scases3(j);
Sverts3(1+(2*(j-1))) = Scases3(j);
pw3v(2*j) = pw3top(j);
pw3v(1+2*(j-1)) = pw3bot(j);
end

for j =1:Ncases4
Sverts4(2*j) = Scases4(j);
Sverts4(1+(2*(j-1))) = Scases4(j);
pw4v(2*j) = pw4top(j);
pw4v(1+2*(j-1)) = pw4bot(j);
end

pw1y = [pw1bot, fliplr(pw1top)]; pw1y2 = [pw1y, pw1y(1)];
pw2y = [pw2bot, fliplr(pw2top)]; pw2y2 = [pw2y, pw2y(1)];
pw3y = [pw3bot, fliplr(pw3top)]; pw3y2 = [pw3y, pw3y(1)];
pw4y = [pw4bot, fliplr(pw4top)]; pw4y2 = [pw4y, pw4y(1)];

vertx1 = [Scases1, fliplr(Scases1)];
vertxsq1 = [vertx1, vertx1(1)];
Z1 = zeros(size(vertxsq1));

vertx2 = [Scases2, fliplr(Scases2)];
vertxsq2 = [vertx2, vertx2(1)];
Z2 = zeros(size(vertxsq2));

vertx3 = [Scases3, fliplr(Scases3)];
vertxsq3 = [vertx3, vertx3(1)];
Z3 = zeros(size(vertxsq3));

vertx4 = [Scases4, fliplr(Scases4)];
vertxsq4 = [vertx4, vertx4(1)];
Z4 = zeros(size(vertxsq4));



%for i = 1:24
%r = mod(i,2);
%if r == 1
%pw1v(i) = pw1bot(i);
%pw2v(i) = pw2bot(i);
%pw3v(i) = pw3bot(i);
%pw4v(i) = pw4bot(i);
%elseif r == 0
%pw1v(i) = pw1top(i);
%pw2v(i) = pw2top(i);
%pw3v(i) = pw3top(i);
%pw4v(i) = pw4top(i);
%end
%end


%display(['h4inf{' num2str(r) '} = ' loadtag])





%load truth fields
load('pseudoworld1_lsat_truth.mat'); PW1_truth = PW1_lsat_truth.grid_2d; [ntime, nloc] = size(PW1_truth);
load('pseudoworld2_lsat_truth.mat'); PW2_truth = PW2_lsat_truth.grid_2d;
load('pseudoworld3_lsat_truth.mat'); PW3_truth = PW3_lsat_truth.grid_2d;
load('pseudoworld4_lsat_truth.mat'); PW4_truth = PW4_lsat_truth.grid_2d; [ntime4, nloc4] = size(PW4_truth);


for i = 1:Ncases1 %PW1
loadtag = ['pseudoworld1_lsat_graphem_sp' num2str(Scases1(i)*100) '_step2.mat'];
PW1inf{i} = load(loadtag);
PW1inf{i}.Xc = center(PW1inf{i}.Xf);
PW1inf{i}.grid_2d = nan(ntime,nloc); index = PW1inf{i}.PW1_lsat.land;
PW1inf{i}.grid_2d(:,index) = PW1inf{i}.Xc; %Xf is GraphEM output loaded from input file
%gridded_data = reshape(grid_2d', [nlon nlat ntime]);
clear index  
end


for i = 1:Ncases2 %PW2
loadtag = ['pseudoworld2_lsat_graphem_sp' num2str(Scases2(i)*100) '_step2.mat'];
PW2inf{i} = load(loadtag);
PW2inf{i}.Xc = center(PW2inf{i}.Xf);
PW2inf{i}.grid_2d = nan(ntime,nloc); index = PW2inf{i}.PW2_lsat.land;
PW2inf{i}.grid_2d(:,index) = PW2inf{i}.Xc; %Xf is GraphEM output loaded from input file
%gridded_data = reshape(grid_2d', [nlon nlat ntime]);
clear index  
end

for i = 1:Ncases3 %PW3
loadtag = ['pseudoworld3_lsat_graphem_sp' num2str(Scases3(i)*100) '_step2.mat'];
PW3inf{i} = load(loadtag);
PW3inf{i}.Xc = center(PW3inf{i}.Xf);
PW3inf{i}.grid_2d = nan(ntime,nloc); index = PW3inf{i}.PW3_lsat.land;
PW3inf{i}.grid_2d(:,index) = PW3inf{i}.Xc; %Xf is GraphEM output loaded from input file
%gridded_data = reshape(grid_2d', [nlon nlat ntime]);
clear index  
end


for i = 1:Ncases4 %PW4
loadtag = ['pseudoworld4_lsat_graphem_sp' num2str(Scases4(i)*100) '_step2.mat'];
PW4inf{i} = load(loadtag);
PW4inf{i}.Xc = center(PW4inf{i}.Xf);
PW4inf{i}.grid_2d = nan(ntime4,nloc4); index = PW4inf{i}.PW4_lsat.land;
PW4inf{i}.grid_2d(:,index) = PW4inf{i}.Xc; %Xf is GraphEM output loaded from input file
%gridded_data = reshape(grid_2d', [nlon nlat ntime]);
clear index  
end


%for i = 1:Ncases %Truth
%tpe1(i) = nmean(nmean((PW1_truth-PW1inf{i}.grid_2d).^2));
%tpe2(i) = nmean(nmean((PW2_truth-PW2inf{i}.grid_2d).^2));
%tpe3(i) = nmean(nmean((PW3_truth-PW3inf{i}.grid_2d).^2));
%tpe4(i) = nmean(nmean((PW4_truth-PW4inf{i}.grid_2d).^2));
%end

%for i = 1:Ncases %Truth 2.0
%indavl1 = ~isnan(PW1inf{i}.grid_2d); index1 = PW1inf{i}.PW1_lsat.land;
%indavl2 = ~isnan(PW2inf{i}.grid_2d); index2 = PW2inf{i}.PW2_lsat.land;
%indavl3 = ~isnan(PW3inf{i}.grid_2d); index3 = PW3inf{i}.PW3_lsat.land;
%indavl4 = ~isnan(PW4inf{i}.grid_2d); index4 = PW4inf{i}.PW4_lsat.land;
%mse1{i}.grid = (PW1_truth(indavl1)-PW1inf{i}.grid_2d(indavl1)).^2;
%mse2{i}.grid = (PW2_truth(indavl2)-PW2inf{i}.grid_2d(indavl2)).^2; 
%mse3{i}.grid = (PW3_truth(indavl3)-PW3inf{i}.grid_2d(indavl3)).^2; 
%mse4{i}.grid = (PW4_truth(indavl4)-PW4inf{i}.grid_2d(indavl4)).^2; 
%lats1 = lats1_2d(indavl1); lats2 = lats2_2d(indavl2);
%lats3 = lats3_2d(indavl3); lats4 = lats4_2d(indavl4);
%mse01(i) = sum(mse1{i}.grid.*cosd(lats1))/sum(cosd(lats1));
%mse02(i) = sum(mse2{i}.grid.*cosd(lats2))/sum(cosd(lats2));
%mse03(i) = sum(mse3{i}.grid.*cosd(lats3))/sum(cosd(lats3));
%mse04(i) = sum(mse4{i}.grid.*cosd(lats4))/sum(cosd(lats4));
%end


%load infilled examples to obtain useful meta data and calculate kcv indicies
%PW1
index1 = PW1inf{1}.PW1_lsat.land;
nstation1 = length(index1);
train1 = PW1_CV.train; test1 = PW1_CV.test;
%indCol1 = [1:nstation1];
%[train1,test1,nin1] = kcv_indices(indCol1,10);

%PW2
index2 = PW2inf{1}.PW2_lsat.land;
nstation2 = length(index2);
train2 = PW2_CV.train; test2 = PW2_CV.test;
%indCol2 = [1:nstation2];
%[train2,test2,nin2] = kcv_indices(indCol2,10);

%PW3
index3 = PW3inf{1}.PW3_lsat.land;
nstation3 = length(index3);
train3 = PW3_CV.train; test3 = PW3_CV.test;
%indCol3 = [1:nstation

%PW4
index4 = PW4inf{1}.PW4_lsat.land;
nstation4 = length(index4);
train4 = PW4_CV.train; test4 = PW4_CV.test;

%tpe
for r = 1:Ncases1
lats_in1 = lats1_2d(:,index1);
msegrid1 = (PW1_truth(:,index1) - PW1inf{r}.grid_2d(:,index1)).^2;
indavl_t1 = ~isnan(msegrid1);
msegrid1_t = msegrid1(indavl_t1); lats_t1 = lats_in1(indavl_t1);
tpe1(r) = nsum(msegrid1_t.*cosd(lats_t1))/nsum(cosd(lats_t1));
end

for r = 1:Ncases2
lats_in2 = lats2_2d(:,index2);
msegrid2 = (PW2_truth(:,index2) - PW2inf{r}.grid_2d(:,index2)).^2;
indavl_t2 = ~isnan(msegrid2);
msegrid2_t = msegrid2(indavl_t2); lats_t2 = lats_in2(indavl_t2);
tpe2(r) = nsum(msegrid2_t.*cosd(lats_t2))/nsum(cosd(lats_t2));
end

for r = 1:Ncases3
lats_in3 = lats3_2d(:,index3);
msegrid3 = (PW3_truth(:,index3) - PW3inf{r}.grid_2d(:,index3)).^2;
indavl_t3 = ~isnan(msegrid3);
msegrid3_t = msegrid3(indavl_t3); lats_t3 = lats_in3(indavl_t3);
tpe3(r) = nsum(msegrid3_t.*cosd(lats_t3))/nsum(cosd(lats_t3));
end

for r = 1:Ncases4
lats_in4 = lats4_2d(:,index4);
msegrid4 = (PW4_truth(:,index4) - PW4inf{r}.grid_2d(:,index4)).^2;
indavl_t4 = ~isnan(msegrid4);
msegrid4_t = msegrid4(indavl_t4); lats_t4 = lats_in4(indavl_t4);
tpe4(r) = nsum(msegrid4_t.*cosd(lats_t4))/nsum(cosd(lats_t4));
end

Kcv = 10;
for i = 1:Kcv
for r = 1:Ncases1
Xin1 = PW1_truth(:,index1); Xa1 = Xin1(:,train1{i});
Xm1 = Xin1(:,test1{i}); 
B1 = ols(PW1inf{r}.Cf, train1{i}, test1{i});
Y1{r} = PW1inf{r}.Xc(:,train1{i})*B1;
mse1 = (Xm1 - Y1{r}).^2;
ind_t1 = ~isnan(mse1); mse1 = mse1(ind_t1);
lats1 = lats1_2d(:,index1); lats1 = lats1(:,test1{i});
lats1 = lats1(ind_t1);
f_num1(r,i) = nsum(nsum(mse1.*cosd(lats1)));
f_den1(r,i) = nsum(nsum(cosd(lats1)));
f_mse1(r,i) = f_num1(r,i)/f_den1(r,i);
end
end

for i = 1:Kcv
for r = 1:Ncases2
Xin2 = PW2_truth(:,index2); Xa2 = Xin2(:,train2{i});
Xm2 = Xin2(:,test2{i}); 
B2 = ols(PW2inf{r}.Cf, train2{i}, test2{i});
Y2{r} = PW2inf{r}.Xc(:,train2{i})*B2;
mse2 = (Xm2 - Y2{r}).^2;
ind_t2 = ~isnan(mse2); mse2 = mse2(ind_t2);
lats2 = lats2_2d(:,index2); lats2 = lats2(:,test2{i});
lats2 = lats2(ind_t2);
f_num2(r,i) = nsum(nsum(mse2.*cosd(lats2)));
f_den2(r,i) = nsum(nsum(cosd(lats2)));
f_mse2(r,i) = f_num2(r,i)/f_den2(r,i);
end
end

for i = 1:Kcv
for r = 1:Ncases3
Xin3 = PW3_truth(:,index3); Xa3 = Xin3(:,train3{i});
Xm3 = Xin3(:,test3{i}); 
B3 = ols(PW3inf{r}.Cf, train3{i}, test3{i});
Y3{r} = PW3inf{r}.Xc(:,train3{i})*B3;
mse3 = (Xm3 - Y3{r}).^2;
ind_t3 = ~isnan(mse3); mse3 = mse3(ind_t3);
lats3 = lats3_2d(:,index3); lats3 = lats3(:,test3{i});
lats3 = lats3(ind_t3);
f_num3(r,i) = nsum(nsum(mse3.*cosd(lats3)));
f_den3(r,i) = nsum(nsum(cosd(lats3)));
f_mse3(r,i) = f_num3(r,i)/f_den3(r,i);
end
end

for i = 1:Kcv
for r = 1:Ncases4
Xin4 = PW4_truth(:,index4); Xa4 = Xin4(:,train4{i});
Xm4 = Xin4(:,test4{i}); 
B4 = ols(PW4inf{r}.Cf, train4{i}, test4{i});
Y4{r} = PW4inf{r}.Xc(:,train4{i})*B4;
mse4 = (Xm4 - Y4{r}).^2;
ind_t4 = ~isnan(mse4); mse4 = mse4(ind_t4);
lats4 = lats4_2d(:,index4); lats4 = lats4(:,test4{i});
lats4 = lats4(ind_t4);
f_num4(r,i) = nsum(nsum(mse4.*cosd(lats4)));
f_den4(r,i) = nsum(nsum(cosd(lats4)));
f_mse4(r,i) = f_num4(r,i)/f_den4(r,i);
end
end

for r = 1:Ncases1
epe1(r) = (1/Kcv) * sum(f_mse1(r,:));
sigg1(r) = std(f_mse1(r,:));
end

for r = 1:Ncases2
epe2(r) = (1/Kcv) * sum(f_mse2(r,:));
sigg2(r) = std(f_mse2(r,:));
end

for r = 1:Ncases3
epe3(r) = (1/Kcv) * sum(f_mse3(r,:));
sigg3(r) = std(f_mse3(r,:));
end

for r = 1:Ncases4
epe4(r) = (1/Kcv) * sum(f_mse4(r,:));
sigg4(r) = std(f_mse4(r,:));
end

mse01 = epe1; mse02 = epe2;
mse03 = epe3; mse04 = epe4;


%% plotting
fig('pseudoworlds lsat graphem sp CV scores'); clf;
hold on;

%p1 = [PW1_CV.epe-PW1_CV.sigg, PW1_CV.epe+PW1_CV.sigg];
%p1 = [PW1_CV.Scases,PW1_CV.epe-PW1_CV.sigg,'k'];
%envelopes
%hp1 = patch(PW1_CV.epe-PW1_CV.sigg,PW1_CV.epe+PW1_CV.sigg,'k');
%hp1 = patch(Scases2,p1,'k')
%hp1 = patch(vertx,pw1y,'k'); hp2 = patch(vertx,pw2y,'r');
%hp3 = patch(vertx,pw3y,'b'); hp4 = patch(vertx,pw4y,'g');
%hp1 = patch(vertx2, pw1y2, 'k'); hp2 = patch(vertx2, pw2y2,'r');
%hp3 = patch(vertx2, pw3y2, 'b'); hp4 = patch(vertx2, pw4y2,'g');
hp1 = fill3(vertxsq1,pw1y2,Z1,'k'); hp2 = fill3(vertxsq2,pw2y2,Z2,'r');
hp3 = fill3(vertxsq3,pw3y2,Z3,'b'); hp4 = fill3(vertxsq4,pw4y2,Z4,'g');
alpha(hp1,.3); alpha(hp2,.3); alpha(hp3,.3); alpha(hp4,.3);
set(hp1,'EdgeAlpha',0);
set(hp2,'EdgeAlpha',0);
set(hp3,'EdgeAlpha',0);
set(hp4,'EdgeAlpha',0);

%ciplot_a(PW1_CV.epe-PW1_CV.sigg,PW1_CV.epe+PW1_CV.sigg,PW1_CV.Scases,'k',.7);
%ciplot_a(PW2_CV.epe-PW2_CV.sigg,PW2_CV.epe+PW2_CV.sigg,PW2_CV.Scases,'r',.7);
%ciplot_a(PW3_CV.epe-PW3_CV.sigg,PW3_CV.epe+PW3_CV.sigg,PW3_CV.Scases,'b',.7);
%ciplot_a(PW4_CV.epe-PW4_CV.sigg,PW4_CV.epe+PW4_CV.sigg,PW4_CV.Scases,'g',.7);

%ciplot(PW1_CV.epe-PW1_CV.sigg,PW1_CV.epe+PW1_CV.sigg,PW1_CV.Scases,'k');
%ciplot(PW2_CV.epe-PW2_CV.sigg,PW2_CV.epe+PW2_CV.sigg,PW2_CV.Scases,'r');
%ciplot(PW3_CV.epe-PW3_CV.sigg,PW3_CV.epe+PW3_CV.sigg,PW3_CV.Scases,'b');
%ciplot(PW4_CV.epe-PW4_CV.sigg,PW4_CV.epe+PW4_CV.sigg,PW4_CV.Scases,'g');

%ciplot_maud(PW1_CV.epe-PW1_CV.sigg,PW1_CV.epe+PW1_CV.sigg,PW1_CV.Scases,'k');
%ciplot_maud(PW2_CV.epe-PW2_CV.sigg,PW2_CV.epe+PW2_CV.sigg,PW2_CV.Scases,'r');
%ciplot_maud(PW3_CV.epe-PW3_CV.sigg,PW3_CV.epe+PW3_CV.sigg,PW3_CV.Scases,'b');
%ciplot_maud(PW4_CV.epe-PW4_CV.sigg,PW4_CV.epe+PW4_CV.sigg,PW4_CV.Scases,'g');




%pseudoworld1
h1 = plot(PW1_CV.Scases, PW1_CV.epe3, 'ko-');
t1 = plot(PW1_CV.Scases, mse01, 'ko--');
%tp1 = plot(PW1_CV.Scases,tpe1,'kx-');
%t1 = plot(PW1_CV.Scases, tpe1, 'ko--');
%plot(PW1_CV.Scases, PW1_CV.epe + PW1_CV.sigg, 'k--')
%plot(PW1_CV.Scases, PW1_CV.epe - PW1_CV.sigg, 'k--')
%ciplot(PW1_CV.epe-PW1_CV.sigg,PW1_CV.epe+PW1_CV.sigg,PW1_CV.Scases,'k')

%pseudoworld2
h2 = plot(PW2_CV.Scases, PW2_CV.epe3, 'ro-');
t2 = plot(PW2_CV.Scases, mse02, 'ro--');
%tp2 = plot(PW2_CV.Scases,tpe2,'rx-');
%t2 = plot(PW2_CV.Scases, tpe2, 'ro--');
%plot(PW2_CV.Scases, PW2_CV.epe + PW2_CV.sigg, 'r--')
%plot(PW2_CV.Scases, PW2_CV.epe - PW2_CV.sigg, 'r--')
%ciplot(PW2_CV.epe-PW2_CV.sigg,PW2_CV.epe+PW2_CV.sigg,PW2_CV.Scases,'r')

%pseudoworld3
h3 = plot(PW3_CV.Scases, PW3_CV.epe3, 'bo-');
t3 = plot(PW3_CV.Scases, mse03, 'bo--');
%tp3 = plot(PW3_CV.Scases,tpe3,'bx-');
%t3 = plot(PW3_CV.Scases, tpe3, 'bo--');
%plot(PW3_CV.Scases, PW3_CV.epe + PW3_CV.sigg, 'b--')
%plot(PW3_CV.Scases, PW3_CV.epe - PW3_CV.sigg, 'b--')
%ciplot(PW3_CV.epe-PW3_CV.sigg,PW3_CV.epe+PW3_CV.sigg,PW3_CV.Scases,'b')

%pseudoworld4
h4 = plot(PW4_CV.Scases, PW4_CV.epe3, 'go-');
t4 = plot(PW4_CV.Scases, mse04, 'go--');
%tp4 = plot(PW4_CV.Scases,tpe4,'bx-');
%t4 = plot(PW4_CV.Scases, tpe4, 'go--');
%plot(PW4_CV.Scases, PW4_CV.epe + PW4_CV.sigg, 'g--')
%plot(PW4_CV.Scases, PW4_CV.epe - PW4_CV.sigg, 'g--')
%ciplot(PW4_CV.epe-PW4_CV.sigg,PW4_CV.epe+PW4_CV.sigg,PW4_CV.Scases,'g')

hleg = legend([h1 h2 h3 h4], {'Pseudo-world 1', 'Pseudo-world 2', 'Pseudo-world 3', 'Pseudo-world 4'});
legend('boxoff')

%fancyplot_deco('10-fold CV scores for choosing target sparsity (Pseudo-worlds lsat)', 'Target sparsity', 'Average MSE', 14, 'Helvetica');
fancyplot_deco('10-fold CV scores for choosing target sparsity (Pseudo-worlds LSAT)', 'Target sparsity (%)', ['Average MSE (' char(176) 'C^{2})'], 14, 'Helvetica');


%Highlight minimum values
%true prediction error
min_ind1 = find(mse01 == min(mse01)); min_ind1 = min_ind1(1);
min_ind2 = find(mse02 == min(mse02)); min_ind2 = min_ind2(1);
min_ind3 = find(mse03 == min(mse03)); min_ind3 = min_ind3(1);
min_ind4 = find(mse04 == min(mse04)); min_ind4 = min_ind4(1);


plot(PW1_CV.Scases(min_ind1),mse01(min_ind1),'kx','MarkerSize',20,'LineWidth',5)
plot(PW2_CV.Scases(min_ind2),mse02(min_ind2),'rx','MarkerSize',20,'LineWidth',5)
plot(PW3_CV.Scases(min_ind3),mse03(min_ind3),'bx','MarkerSize',20,'LineWidth',5)
plot(PW4_CV.Scases(min_ind4),mse04(min_ind4),'gx','MarkerSize',20,'LineWidth',5)


%mse
m_ind1 = find(PW1_CV.epe3 == min(PW1_CV.epe3)); m_ind1 = m_ind1(1);
m_ind2 = find(PW2_CV.epe3 == min(PW2_CV.epe3)); m_ind2 = m_ind2(1);
m_ind3 = find(PW3_CV.epe3 == min(PW3_CV.epe3)); m_ind3 = m_ind3(1);
m_ind4 = find(PW4_CV.epe3 == min(PW4_CV.epe3)); m_ind4 = m_ind4(1);

sd1_ind1 = find(PW1_CV.epe3 < PW1_CV.epe3(m_ind1) + PW1_CV.sigg3(m_ind1),1);
sd1_ind2 = find(PW2_CV.epe3 < PW2_CV.epe3(m_ind2) + PW2_CV.sigg3(m_ind2),1);
sd1_ind3 = find(PW3_CV.epe3 < PW3_CV.epe3(m_ind3) + PW3_CV.sigg3(m_ind3),1);
sd1_ind4 = find(PW4_CV.epe3 < PW4_CV.epe3(m_ind4) + PW4_CV.sigg3(m_ind4),1);


plot(PW1_CV.Scases(sd1_ind1),PW1_CV.epe3(sd1_ind1),'kx','MarkerSize',20,'LineWidth',5)
plot(PW2_CV.Scases(sd1_ind2),PW2_CV.epe3(sd1_ind2),'rx','MarkerSize',20,'LineWidth',5)
plot(PW3_CV.Scases(sd1_ind3),PW3_CV.epe3(sd1_ind3),'bx','MarkerSize',20,'LineWidth',5)
plot(PW4_CV.Scases(sd1_ind4),PW4_CV.epe3(sd1_ind4),'gx','MarkerSize',20,'LineWidth',5)










%hepta_figprint('./figs/pseudoworlds_lsat_graphem_sp_CVscores5.eps')
%hepta_figprint('./figs/pseudoworlds_lsat_graphem_sp_CVscores.eps')
%hepta_figprint('./figs/pseudoworlds_lsat_graphem_sp_CVscores4.eps')
%pause(5)

%add error on to plot
%plot(PW1_CV.Scases, PW1_CV.epe + PW1_CV.sigg, 'k--')
%plot(PW1_CV.Scases, PW1_CV.epe - PW1_CV.sigg, 'k--')
%plot(PW2_CV.Scases, PW2_CV.epe + PW2_CV.sigg, 'r--')
%plot(PW2_CV.Scases, PW2_CV.epe - PW2_CV.sigg, 'r--')
%plot(PW3_CV.Scases, PW3_CV.epe + PW3_CV.sigg, 'b--')
%plot(PW3_CV.Scases, PW3_CV.epe - PW3_CV.sigg, 'b--')
%plot(PW4_CV.Scases, PW4_CV.epe + PW4_CV.sigg, 'g--')
%plot(PW4_CV.Scases, PW4_CV.epe - PW4_CV.sigg, 'g--')

%hepta_figprint('./figs/pseudoworlds_lsat_graphem_sp_CVscores5.eps')

%pause(5)



%hepta_figprint('./figs/pseudoworlds_lsat_graphem_sp_CVscores3.eps')

%% SAVE AS .TIFF THEN CONVERT TO PDF/JPEG/etc THIS WILL ELIMINATE ANNOYING POLYGONS
filen = './figs/pseudoworlds_lsat_graphem_sp_CVscores02'; 
print('-dtiff', '-noui', '-r250', filen)

