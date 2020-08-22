#!/bin/bash
cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/slurm
dist=1000
# cd PW1sst

for worldnum in {1..4}; do
  datatype=sst
  cd PW$worldnum$datatype
  for k in {1..10}; do
    ../gen_sbatch_pseudoworld_cr_kn.sh $dist $worldnum $datatype $k
  done
  cd ..
  datatype=lsat
  cd PW$worldnum$datatype
  for k in {1..10}; do
    ../gen_sbatch_pseudoworld_cr_kn.sh $dist $worldnum $datatype $k
  done
  cd ..
done
