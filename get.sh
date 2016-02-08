#!/bin/bash

machine=comp
machine=dune
machine=astro06

rpath=/astro/gmurphy/photonplasma/Experiments/lkh/Data
rpath=/astro/gmurphy/photonplasma/Experiments/lkh/Data
rpath=PLUTO/zanromdisk
rpath=pluto41/
result=scratch/${PWD##*/} 
printf '%q\n' $result

SYNC="rsync -avz --progress"
$SYNC  $machine:${result}/*.jpg .
