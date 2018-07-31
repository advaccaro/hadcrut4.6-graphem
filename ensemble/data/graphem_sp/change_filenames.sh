#!/bin/bash

for file in graphem_sp*;
do
	mv "$file" "${file#graphem_sp}"
done
