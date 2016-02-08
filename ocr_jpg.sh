#!/bin/bash

alphabet=`ls *.jpg`

for letter in $alphabet 
do

y=${letter%.jpg}
echo $y

tesseract -l eng $letter $y
done

