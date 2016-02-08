#!/bin/bash

i="1"

while [ $i -lt 10 ]
do
cp Cinco_*.avi Cinco$i.avi
i=$[$i+1]
done
