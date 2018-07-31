#!/bin/tcsh -f

echo $1

#setenv FILE_NUM $1

setenv PBS_FILENAME "RUN_cw17_opennc_file.pbs"
setenv OUT_FILENAME "cw17_opennc_file"
touch $PBS_FILENAME

echo "#PBS -N $OUT_FILENAME" >> $PBS_FILENAME

echo "#PBS -k oe" >> $PBS_FILENAME



echo "cd /home/geovault-00/rverna/hadCRUT4.6/cw17/" >> $PBS_FILENAME

echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$OUT_FILENAME.out << EOF" >> $PBS_FILENAME
#echo "filenum = $FILE_NUM" >> $PBS_FILENAME
echo "cw17_opennc" >> $PBS_FILENAME
echo "exit" >> $PBS_FILENAME

echo "EOF" >> $PBS_FILENAME
