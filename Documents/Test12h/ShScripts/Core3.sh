#!/bin/bash
#################################################
#      	Pyxis Test Core 3			#
# Tests the current build of Pyxis for the	#
# static test and gives results as plots from 	#
# matlab and other info regarding execution of 	#
# the file.					#
#						#
# Input: Raw Intermediate Frequency (IF) files  #
#	that are static real with apt and rnx. 	#
#						#
# Output:  MATLAB plots, 			#
#          DetermStat.txt			#
#################################################

## Execute Pyxis
cd ../output/StaticSim
STARTTIME=$(date +%s)
./pyxis &> screenout.txt
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
echo "MAX2769 Sampfreq:6864e6 26min x86 StaticSim: $diff" >> ../times.txt

## Checks whether the Pyxis results are the same as the previous test, if they are then it breaks. If not, then it runs the test again and confirms that its deterministic.
while [ true ]
	do
	cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStatSim.txt
	cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStatSim.txt
	if ! [ -s DetermStatSim.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		mv timingaptBinaries_0_0.bin REVISEDtimingaptBinaries_0_0.bin
		mv timingrnxBinaries_0_0.bin REVISEDtimingrnxBinaries_0_0.bin
		#./pyxis
		cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStatSim2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStatSim2.txt
		if [ -s DetermStatSim2.txt ]
			then
			echo "Not Deterministic!"
			echo " " >> DetermStatSim.txt
			echo "New Pyxis Run not Deterministic with itself" >> DetermStatSim.txt
			sleep 2s
		fi
		break
	fi
done


## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticSim\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticSim\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

## Execute Pyxis
cd ../output/StaticLong
STARTTIME=$(date +%s)
./pyxis &> screenout.txt
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
echo "MAX2769 Sampfreq:6864e6 34hours x86 StaticLong: $diff" >> ../times.txt

## Checks whether the Pyxis results are the same as the previous test, if they are then it breaks. If not, then it runs the test again and confirms that its deterministic.
while [ true ]
	do
	cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStatL.txt
	cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStatL.txt
	if ! [ -s DetermStatL.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		mv timingaptBinaries_0_0.bin REVISEDtimingaptBinaries_0_0.bin
		mv timingrnxBinaries_0_0.bin REVISEDtimingrnxBinaries_0_0.bin
		#./pyxis
		cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStatL2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStatL2.txt
		if [ -s DetermStatL2.txt ]
			then
			echo "Not Deterministic!"
			echo " " >> DetermStatL.txt
			echo "New Pyxis Run not Deterministic with itself" >> DetermStatL.txt
			sleep 2s
		fi
		break
	fi
done

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticLong\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticLong\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1859_518400.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticLong\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticLong\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1860_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticLong\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticLong\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

## Time when Core 3 was finished is printed to Summary.txt
cd ../output
echo 'Core 3 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core3 completion message printed to terminal
echo "Core 3 is finished"
sleep 3s
