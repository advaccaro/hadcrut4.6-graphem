function Xg = run_pw_graphem_sp_full(target_spars)
  worldnums = [1:4];
  datatypes = {'lsat', 'sst'};

  for wn = worldnums
    for i = 1:2
      datatype = datatypes{i};
      Xg = pseudoworld_graphem_sp_full(wn, datatype, target_spars);
    end
  end
end
