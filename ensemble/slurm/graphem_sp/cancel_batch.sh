#!/bin/bash

for i in $(seq 403 437); 

do 
	scancel $i;
	sleep 2s;

done
