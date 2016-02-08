#!/bin/bash
alphabet=`ls | grep q`
count=0					# Initialise a counter
for letter in $alphabet			# Set up a loop control
do					# Begin the loop
    count=`expr $count + 1`		# Increment the counter
#ps2pdf -dEPSCrop $letter

    ls $letter/usr*h5 | tail -1

		  done					# End of loop
