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

## Execute Pyxis with Valgrind
cd ../output/Dynamic1Heavy
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis
./pyxis

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript1.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/';" AnalysisRNXScript1.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/Plots\/';" AnalysisRNXScript1.m
sed -i "/truthStr = /c\truthStr = 'test2.txt';" AnalysisRNXScript1.m

# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript1.m; exit;"

## Execute Pyxis and print to terminal that output is saved in txt file
echo "Printing Dynamic 1 output to screenout.txt"
cd ../output/Dynamic1
./pyxis &> screenout.txt

## Test if deterministic by comparing Dynamic1Heavy (w/valgrind) with Dynamic1 (w/o valgrind)
cd ../Dynamic1Heavy
echo 'apt Differences:' > DetermDyn.txt
cmp timingaptBinaries_0_0.bin ../Dynamic1/timingaptBinaries_0_0.bin >> DetermDyn.txt
echo ' ' >> DetermDyn.txt
echo 'rnx Differences:' >> DetermDyn.txt
cmp timingrnxBinaries_0_0.bin ../Dynamic1/timingrnxBinaries_0_0.bin >> DetermDyn.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/';" AnalysisRNXScript.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/Plots\/';" AnalysisRNXScript.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript.m
# No need for change in matlab preferences
# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript.m; exit;" 

## Time when Core 1 was finished is printed to Summary.txt
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core1 completion message printed to terminal
echo "Core 1 is finished"
sleep 3s
