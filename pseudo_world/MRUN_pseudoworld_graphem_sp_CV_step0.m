%MRUN_pseudoworld_graphem_sp_CV_step0.m
%Run pseudoworld_graphem_sp_CV_step0.m for all PWs (raw and truth)
% (it was just easier to do this in a MATLAB script rather than write PBS scripts for each instance)

%pseudoworld_graphem_sp_CV_step0(dataset,datatype,worldnum,truth,Kcv)

%% PW1 
%LSAT
pseudoworld_graphem_sp_CV_step0('pseudoworld1_lsat.mat','lsat',1,0,10);

%LSAT truth
pseudoworld_graphem_sp_CV_step0('pseudoworld1_lsat_truth.mat','lsat',1,1,10);

%SST
pseudoworld_graphem_sp_CV_step0('pseudoworld1_sst.mat','sst',1,0,10);

%SST truth
pseudoworld_graphem_sp_CV_step0('pseudoworld1_sst_truth.mat','sst',1,1,10);

%% PW2
%LSAT
pseudoworld_graphem_sp_CV_step0('pseudoworld2_lsat.mat','lsat',2,0,10);

%LSAT truth
pseudoworld_graphem_sp_CV_step0('pseudoworld2_lsat_truth.mat','lsat',2,1,10);

%SST
pseudoworld_graphem_sp_CV_step0('pseudoworld2_sst.mat','sst',2,0,10);

%SST truth
pseudoworld_graphem_sp_CV_step0('pseudoworld2_sst_truth.mat','sst',2,1,10);

%% PW3
%LSAT
pseudoworld_graphem_sp_CV_step0('pseudoworld3_lsat.mat','lsat',3,0,10);

%LSAT truth
pseudoworld_graphem_sp_CV_step0('pseudoworld3_lsat_truth.mat','lsat',3,1,10);

%SST
pseudoworld_graphem_sp_CV_step0('pseudoworld3_sst.mat','sst',3,0,10);

%SST truth
pseudoworld_graphem_sp_CV_step0('pseudoworld3_sst_truth.mat','sst',3,1,10);

%% PW4
%LSAT
pseudoworld_graphem_sp_CV_step0('pseudoworld4_lsat.mat','lsat',4,0,10);

%LSAT truth
pseudoworld_graphem_sp_CV_step0('pseudoworld4_lsat_truth.mat','lsat',4,1,10);

%SST
pseudoworld_graphem_sp_CV_step0('pseudoworld4_sst.mat','sst',4,0,10);

%SST truth
pseudoworld_graphem_sp_CV_step0('pseudoworld4_sst_truth.mat','sst',4,1,10);


