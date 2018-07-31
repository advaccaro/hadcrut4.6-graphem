#!/bin/bash -f

echo $1

export FILE_NUM=$1

export SLURM_FILENAME="RUN_had46ens_graphem_merra_krig_sp80_file$1.txt"
export OUT_FILENAME="had46ens_graphem_merra_krig_sp80_file$1"

touch $SLURM_FILENAME

echo '#!/bin/bash -f' >> $SLURM_FILENAME

echo "#SBATCH --job-name=$OUT_FILENAME" >> $SLURM_FILENAME
echo "#SBATCH --mem=14GB" >> $SLURM_FILENAME
echo "#SBATCH --output=$OUT_FILENAME.o" >> $SLURM_FILENAME
echo "#SBATCH --error=$OUT_FILENAME.e" >> $SLURM_FILENAME


echo "cd /home/geovault-02/avaccaro/hadCRUT4.6/ensemble/" >> $SLURM_FILENAME

echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$OUT_FILENAME.out << EOF" >> $SLURM_FILENAME
echo "filenum = $FILE_NUM" >> $SLURM_FILENAME
echo "had46ens_graphem_merra_krig_sp80_main" >> $SLURM_FILENAME
echo "exit" >> $SLURM_FILENAME

echo "EOF" >> $SLURM_FILENAME



