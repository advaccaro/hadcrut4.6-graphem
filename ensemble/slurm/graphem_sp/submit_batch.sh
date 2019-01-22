#!/bin/bash

for i in $(seq 1 100); 

do 
	sbatch --ntasks=4  RUN_had46ens_graphem_merra_krig_sp60_file$i.txt; 
	sleep 10s;

done
