%run_pseudoworld_graphem_sp_CV.m
function [wn] = run_pseudoworld_graphem_sp_CV(worldnum)

addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))

wn = num2str(worldnum)

% Sparsities to test
Scases = [.5:.05:1];

%% PW1
if wn == 1
  % LSAT
  pseudoworld_graphem_sp_CV('pseudoworld1_lsat.mat', 'lsat', 1, Scases, 10)
  % SST
  pseudoworld_graphem_sp_CV('pseudoworld1_sst.mat', 'sst', 1, Scases, 10)


%% PW2
elseif wn == 2
  % LSAT
  pseudoworld_graphem_sp_CV('pseudoworld2_lsat.mat', 'lsat', 2, Scases, 10)
  % SST
  pseudoworld_graphem_sp_CV('pseudoworld2_sst.mat', 'sst', 2, Scases, 10)

%% PW3
elseif wn == 3
  % LSAT
  pseudoworld_graphem_sp_CV('pseudoworld3_lsat.mat', 'lsat', 3, Scases, 10)
  % SST
  pseudoworld_graphem_sp_CV('pseudoworld3_sst.mat', 'sst', 3, Scases, 10)


%% PW1
elseif wn == 4
  % LSAT
  pseudoworld_graphem_sp_CV('pseudoworld4_lsat.mat', 'lsat', 4, Scases, 10)
  % SST
  pseudoworld_graphem_sp_CV('pseudoworld4_sst.mat', 'sst', 4, Scases, 10)
end
