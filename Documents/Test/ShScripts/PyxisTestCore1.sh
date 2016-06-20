#!/bin/bash
#################################################
#      	Pyxis Test Core 1			#
# Tests the current build of Pyxis for the	#
# dynamic test and gives results as plots from 	#
# matlab and other info regarding execution of 	#
# the file.					#
#						#
# Input: Raw Intermediate Frequency (IF) files  #
#	that are static, dynamic, real and	#
#	complex, and apt and rnx binaries. 	#
#						#
# Output:  Valwar.txt, MATLAB plots, 		#
#          DetermDyn.txt			#
#################################################

## Nothing in right now

## Time when Core 1 was finished is printed to Summary.txt
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core1 completion message printed to terminal
echo "Core 1 is finished"
sleep 3s
