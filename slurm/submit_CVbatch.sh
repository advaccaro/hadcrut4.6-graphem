#!/bin/bash

#for i in $(seq 50 5 110); do
#	for j in $(seq 1 10); do
		#export FILENAME="RUN_H46MED_SP$i_K$j"
#		export SLURM_FILENAME="RUN_H46MED_SP$i_K$j.txt"
		#FILENAME2=($FILENAME_K)$j.txt
#		echo $SLURM_FILENAME
		#sbatch --ntasks=4 RUN_H46MED_SP$i_K$j.txt
		sleep 5s;
#	done
#done	

for FILE in $(ls RUN_H46MED_SP*_K*.txt); do
	echo $FILE
	sbatch --ntasks=4 $FILE
	sleep 2s;
done
