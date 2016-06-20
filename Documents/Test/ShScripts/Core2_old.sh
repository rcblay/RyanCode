#!/bin/bash
#################################################
#      	Pyxis Test Core 2			#
# Tests the current build of Pyxis for the	#
# static test and gives results as plots from 	#
# matlab and other info regarding execution of 	#
# the file.					#
#						#
# Input: Raw Intermediate Frequency (IF) files  #
#	that are static, dynamic, real and	#
#	complex, and apt and rnx binaries. 	#
#						#
# Output:  Valwar.txt, MATLAB plots, 		#
#          DetermStat.txt			#
#################################################

## Execute Pyxis with Valgrind
cd ../output/StaticHeavy
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis
./pyxis

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/StaticHeavy\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/StaticHeavy\/Plots\/';" AnalysisRNXScript2.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript2.m

# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

## Execute Pyxis and print to terminal that output is saved in txt file
echo "Printing Static 1 output to screenout.txt"
cd ../output/Static
./pyxis &> screenout.txt

## Test if deterministic by comparing StaticHeavy (w/valgrind) with Static (w/o valgrind)
cd ../StaticHeavy
echo 'apt Differences:' > DetermStat.txt
cmp timingaptBinaries_0_0.bin ../Static/timingaptBinaries_0_0.bin >> DetermStat.txt
echo ' ' >> DetermStat.txt
echo 'rnx Differences:' >> DetermStat.txt
cmp timingrnxBinaries_0_0.bin ../Static/timingrnxBinaries_0_0.bin >> DetermStat.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Static\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Static\/Plots\/';" AnalysisRNXScript2.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript2.m
# No need for change in matlab preferences
# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

## Time when Core 2 was finished is printed to Summary.txt
cd ../output
echo 'Core 2 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core2 completion message printed to terminal
echo "Core 2 is finished"
sleep 3s
