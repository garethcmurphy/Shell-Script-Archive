#!/bin/bash
num=117
cd
#cd $HOME/cooling/athena-graphics-3d/application
mv  aarray_0${num}.txt  aarray_0001.txt
mv  astuff_0${num}.txt  astuff_0001.txt
./amr2uni
cp dump_0001.txt ${HOME}/src/c/two_Array/ascii_array
cd  ${HOME}/src/c/two_Array/
./bin/a.out
