#!/bin/bash
#################################################
#      	Pyxis Test Core 1			#
# Tests the current build of Pyxis for the	#
# ARM test and gives results as plots from 	#
# matlab and other info regarding execution of 	#
# the file.					#
#						#
# Input: Raw Intermediate Frequency (IF) files  #
#	that are static, dynamic, real and	#
#	complex, and apt and rnx binaries. 	#
#						#
# Output:  MATLAB plots, DetermARM.txt		#
#################################################

cd ../output/nfsshare

./pyxis

while [ true ]
	do
	#cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermARM.txt
	cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermARM.txt
	if ! [ -s DetermARM.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		#mv timingaptBinaries_0_0.bin REVISEDtimingaptBinaries_0_0.bin
		mv timingrnxBinaries_0_0.bin REVISEDtimingrnxBinaries_0_0.bin
		./pyxis
		#cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermARM2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermARM2.txt
		if ! [ -s DetermARM2.txt ]
			then
			echo "Not Deterministic!"
			echo " " >> DetermARM.txt
			echo "New Pyxis Run not Deterministic with itself" >> DetermARM.txt
			sleep 5s
			exit
		fi
		break
	fi
done

cd /home/dma/Documents/Test/MATLAB

## Time when Core 1 was finished is printed to Summary.txt
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core1 completion message printed to terminal
echo "Core 1 is finished"
sleep 3s
