#!/bin/bash 
file_num=$1
chombovis ${HOME}/ionise/athena-graphics-3d/application/chombo_plt_cnt_00${file_num}.hdf5 &
chombovis ${HOME}/osrshock/athena-graphics-3d/application/chombo_plt_cnt_00${file_num}.hdf5 &
