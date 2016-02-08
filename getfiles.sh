#!/bin/bash

machine=comp
machine=dune
machine=astro09

rpath=/astro/gmurphy/photonplasma/Experiments/lkh/Data
rpath=/astro/gmurphy/photonplasma/Experiments/lkh/Data
rpath=PLUTO/zanromdisk
rpath=pluto41/
result=pluto41/${PWD##*/} 
printf '%q\n' $result

SYNC="rsync -avz --progress"
$SYNC  $machine:${result}/*.out .
$SYNC  $machine:${result}/*0011.dbl .
