#!/bin/bash -f
#SBATCH --job-name=CR1000
#SBATCH --output=CR1000.o
#SBATCH --error=CR1000.e
cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/
/usr/bin/matlab -nodesktop -nosplash > ./out/CR1000.out << EOF
had46med_graphem_merra_krig_cr1000_full
exit
EOF
