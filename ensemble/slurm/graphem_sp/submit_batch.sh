#!/bin/bash

for i in $(seq 46 80); 

do 
	sbatch --ntasks=4  RUN_had46ens_graphem_merra_krig_sp80_file$i.txt; 
	sleep 10s;

done
