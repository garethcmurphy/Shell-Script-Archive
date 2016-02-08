#!/bin/bash
#if [ "$1" = "" ]
#then
#  echo "Usage: $0 filename"
#fi

#for num in `seq 53 -1 40` 
#do 
export arg1=`printf "%03d" $num`
echo ${arg1}
export rowan_path="3d/hd/g1b/athena-graphics-3d/application"
ssh leda "rsync --bwlimit 5000  -avz rowan:${rowan_path}/chombo_plt_cnt_0${arg1}.hdf5 ~/c.hdf5 --progress ";  
scp leda:c.hdf5 /media/"My Book"/g1b/chombo_plt_cnt_0${arg1}.hdf5
#done
