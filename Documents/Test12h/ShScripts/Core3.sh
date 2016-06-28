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

## Execute Pyxis with Valgrind
cd ../output/StaticSim
echo "MAX2769 Sampfreq:6864e6 26min x86 StaticSim" >> ../times.txt
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis
/usr/bin/time -f "%E" -a ../times.txt ./pyxis

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticSim\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticSim\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1859_518400.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticSim\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticSim\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1860_0.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticSim\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticSim\/Plots\/';" AnalysisRNXScript3.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript3.m

# Run matlab
matlab -nodesktop -r "run AnalysisRNXScript3.m; exit;"

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_1860_86400.bin';" AnalysisRNXScript3.m
sed -i "/parentpath =/c\parentpath = '..\/output\/StaticSim\/';" AnalysisRNXScript3.m
sed -i "/plotpath =/c\plotpath = '..\/output\/StaticSim\/Plots\/';" AnalysisRNXScript3.m
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
