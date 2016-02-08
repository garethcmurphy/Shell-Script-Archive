#!/bin/bash
for i in `seq -f "%02g" 49 57` 
do
rsync -avz rowan:/store/gfs1.rowan.ucd.ie/rowan-home1/gmurphy/3d/mhd/L1551_2/athena-graphics-3d/application/chombo_plt_cnt_00$i.hdf5 .
rsync -avz chombo_plt_cnt_00$i.hdf5 anubis:/mnt/gmurphy2/
rm -rf chombo_plt_cnt_00$i.hdf5
done
