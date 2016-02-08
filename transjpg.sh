#!/bin/bash

alphabet=`ls pg*.jpg`

for letter in $alphabet 
do

y=${letter%.jpg}
echo $y
# 
cond=1
 if [ -f $y.jpg ]; then
 if [ "$y.jpg"  -nt "$letter" ]; then
echo  $y.jpg newer than $letter
cond=0
fi
 fi

if [ "$cond"   = "1" ]; then
tesseract -l dan $letter $y.txt
echo "Converting"
fi

#convert -trim $letter.jpg $letter.jpg
done

