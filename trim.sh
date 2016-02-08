#!/bin/bash

alphabet=`ls *jpeg`

for letter in $alphabet 
do

convert -trim $letter $letter
done

