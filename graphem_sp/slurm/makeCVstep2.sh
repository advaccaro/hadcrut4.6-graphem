#!/bin/bash

export TARGET_SPARS=$1
export KFOLD=$2


export SLURM_FILENAME="RUN_H46MED_SP$1_K$2.txt"
export RUN_FILENAME="H46MED_SP$1_K$2"
export OUT_FILENAME="had46med_graphem_sp$1_k$2"
touch $SLURM_FILENAME

echo '#!/bin/bash' >> $SLURM_FILENAME


echo "#SBATCH --job-name=$RUN_FILENAME" >> $SLURM_FILENAME
echo "#SBATCH --mem=14GB" >> $SLURM_FILENAME
echo "#SBATCH --output=$OUT_FILENAME.o" >> $SLURM_FILENAME
echo "#SBATCH --error=$OUT_FILENAME.e" >> $SLURM_FILENAME

echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/" >> $SLURM_FILENAME

echo "/usr/bin/matlab -nodesktop -nosplash > ./graphem_sp/out/$OUT_FILENAME.out << EOF" >> $SLURM_FILENAME
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))" >> $SLURM_FILENAME
echo "target_spars = $TARGET_SPARS" >> $SLURM_FILENAME
echo "target_spars = target_spars/100;" >> $SLURM_FILENAME
echo "Kfold = $KFOLD" >> $SLURM_FILENAME
echo "had46med_graphem_sp_CV_step2(target_spars, Kfold)" >> $SLURM_FILENAME
echo "exit" >> $SLURM_FILENAME

echo "EOF" >> $SLURM_FILENAME

