#!/bin/bash -f
#SBATCH --job-name=gen_spars_adjs
#SBATCH --output=gen_spars_adjs.o
#SBATCH --error=gen_spars_adjs.e
cd /home/geovault-02/avaccaro/hadCRUT4.6/
/usr/bin/matlab -nodesktop -nosplash > ./out/generate_spars_adj_range.out << EOF
generate_spars_adj_range
exit
EOF
