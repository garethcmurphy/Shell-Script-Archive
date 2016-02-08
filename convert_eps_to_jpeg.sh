#!/bin/bash

alphabet=`ls *.eps`

for letter in $alphabet 
do

y=${letter%.eps}
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
gs -dQUIET -r200 -dEPSCrop -dBATCH -dNOPAUSE -dSAFER -sDEVICE=jpeg -sOutputFile=$y.jpg $letter
echo "Converting"
fi

#convert -trim $letter.jpg $letter.jpg
done

