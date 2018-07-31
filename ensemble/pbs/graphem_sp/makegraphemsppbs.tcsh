#!/bin/tcsh -f

echo $1

setenv FILE_NUM $1

setenv PBS_FILENAME "RUN_had46ens_graphem_merra_krig_sp80_file$1.pbs"
setenv OUT_FILENAME "had46ens_graphem_merra_krig_sp80_file$1"
touch $PBS_FILENAME

echo "#PBS -N $OUT_FILENAME" >> $PBS_FILENAME
echo "#PBS -l mem=14gb" >> $PBS_FILENAME
echo "#PBS -k oe" >> $PBS_FILENAME



echo "cd /home/geovault-02/avaccaro/hadCRUT4.6/ensemble/" >> $PBS_FILENAME

echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$OUT_FILENAME.out << EOF" >> $PBS_FILENAME
echo "filenum = $FILE_NUM" >> $PBS_FILENAME
echo "had46ens_graphem_merra_krig_sp80_main" >> $PBS_FILENAME
echo "exit" >> $PBS_FILENAME

echo "EOF" >> $PBS_FILENAME



