#!/bin/bash
alphabet=`ls | grep q1_`
count=0					# Initialise a counter
for letter in $alphabet			# Set up a loop control
do					# Begin the loop
    count=`expr $count + 1`		# Increment the counter
    cd  $letter
    echo ~/snoopy.sh
    cd ..
		  done					# End of loop
