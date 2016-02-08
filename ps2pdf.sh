#!/bin/bash

alphabet=`ls *.eps`

for letter in $alphabet 
do

y=${letter%.eps}
echo $y
# 
cond=1
 if [ -f $y.pdf ]; then
 if [ "$y.pdf"  -nt "$letter" ]; then
echo  $y.pdf newer than $letter
cond=0
fi
 fi

if [ "$cond"   = "1" ]; then
ps2pdf -dEPSCrop $letter
echo "Converting"
fi

#convert -trim $letter.pdf $letter.pdf
done

