#!/bin/bash
#################################################
#      		   Core 1			#
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

loc=`pwd`

cd /nfsshare

# Save run time to times.txt
echo "MAX2769 Sampfreq:6864e6 52min ARM Static" > ../../output/times.txt
STARTTIME=$(date +%s)
./pyxis
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
echo "$diff" >> ../../output/times.txt

while [ true ]
	do
	cmp nightly-results/REFtimingaptBinaries_0_0.bin nightly-results/timingaptBinaries_0_0.bin > nightly-results/DetermARM.txt
	cmp nightly-results/REFtimingrnxBinaries_0_0.bin nightly-results/timingrnxBinaries_0_0.bin >> nightly-results/DetermARM.txt
	if ! [ -s nightly-results/DetermARM.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		mv nightly-results/timingaptBinaries_0_0.bin nightly-results/REVISEDtimingaptBinaries_0_0.bin
		mv nightly-results/timingrnxBinaries_0_0.bin nightly-results/REVISEDtimingrnxBinaries_0_0.bin
		./pyxis
		cmp nightly-results/REVISEDtimingaptBinaries_0_0.bin nightly-results/timingaptBinaries_0_0.bin > nightly-results/DetermARM2.txt
		cmp nightly-results/REVISEDtimingrnxBinaries_0_0.bin nightly-results/timingrnxBinaries_0_0.bin >> nightly-results/DetermARM2.txt
		if ! [ -s nightly-results/DetermARM2.txt ]
			then
			echo "Not Deterministic!"
			echo " " >> nightly-results/DetermARM.txt
			echo "New Pyxis Run not Deterministic with itself" >> nightly-results/DetermARM.txt
			sleep 2s
		fi
		break
	fi
done
cd $loc
cd ../MATLAB

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript1.m
sed -i "/parentpath =/c\parentpath = '\/nfsshare\/nightly-results\/';" AnalysisRNXScript1.m
sed -i "/plotpath =/c\plotpath = '\/nfsshare\/nightly-results\/Plots\/';" AnalysisRNXScript1.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript1.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript1.m; exit;"



## Time when Core 1 was finished is printed to Summary.txt
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core1 completion message printed to terminal
echo "Core 1 is finished"
sleep 3s
