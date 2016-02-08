#!/bin/bash

i="1"

while [ $i -lt 17 ]
do
   echo "SSH'ing to leda$i"
#   ssh -x leda$i "pkill -U gmurphy athena ; pkill -U gmurphy zeusmp ;/home/leda1/gmurphy/sbin/cleanipcs;"
   ssh -x leda$i "uname -n ; ls /scratch-local ;"
i=$[$i+1]
done
