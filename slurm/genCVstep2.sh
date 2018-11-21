#!/bin/bash

for i in $(seq 50 5 110); do
	for j in $(seq 1 10); do
		./makeCVstep2.sh $i $j
	done
done	
