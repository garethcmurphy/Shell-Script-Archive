#!/bin/bash

alphabet=`ls *.ppm`

for letter in $alphabet 
do

y=${letter%.ppm}
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
convert $letter $y.jpg
echo "Converting"
fi

#convert -trim $letter.jpg $letter.jpg
done

