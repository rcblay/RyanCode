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
cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStatSim.txt
cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStatSim.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticSim\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticSim\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m
sed -i "/ResY = /c\ResY = importWeek('..\/output\/StaticSim\/Plots/ResY.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('..\/output\/StaticSim\/Plots/ResW.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

## Execute Pyxis
cd ../output/StaticLong
STARTTIME=$(date +%s)
./pyxis &> screenout.txt
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
echo "MAX2769 Sampfreq:6864e6 34hours x86 StaticLong: $diff" >> ../times.txt

## Checks whether the Pyxis results are the same as the previous test.
cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStatL.txt
cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStatL.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticLong\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticLong\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m
sed -i "/ResY = /c\ResY = importWeek('..\/output\/StaticLong\/Plots/ResY1.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('..\/output\/StaticLong\/Plots/ResW1.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1859_518400.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticLong\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticLong\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m
sed -i "/ResY = /c\ResY = importWeek('..\/output\/StaticLong\/Plots/ResY2.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('..\/output\/StaticLong\/Plots/ResW2.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1860_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticLong\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticLong\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m
sed -i "/ResY = /c\ResY = importWeek('..\/output\/StaticLong\/Plots/ResY3.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('..\/output\/StaticLong\/Plots/ResW3.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

## Time when Core 3 was finished is printed to Summary.txt
cd ../output
echo 'Core 3 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core3 completion message printed to terminal
echo "Core 3 is finished"
sleep 3s
