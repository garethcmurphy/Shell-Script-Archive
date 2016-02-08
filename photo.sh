#!/bin/bash
alphabet="a b c d e"			# Initialise a string
count=0					# Initialise a counter
for letter in $alphabet			# Set up a loop control
do					# Begin the loop
    count=`expr $count + 1`		# Increment the counter
	     echo "Letter $count is [$letter]"	# Display the result
		  done					# End of loop
