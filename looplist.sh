#!/bin/bash
list=`ls | grep run0`
for i in $list 
do 
cd  $i
make -j 18
pwd
cd ..
done
