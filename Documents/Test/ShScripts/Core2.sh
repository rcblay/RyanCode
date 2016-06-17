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
cd ../output/Dynamic1
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis
./pyxis

## Checks whether the Pyxis results are the same as the previous test, if they are then it breaks. If not, then it runs the test again and confirms that its deterministic.
while [ true ]
	do
	cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermDyn.txt
	cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermDyn.txt
	if ! [ -s DetermDyn.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		mv timingaptBinaries_0_0.bin REVISEDtimingaptBinaries_0_0.bin
		mv timingrnxBinaries_0_0.bin REVISEDtimingrnxBinaries_0_0.bin
		./pyxis
		cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin >> DetermDyn2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermDyn2.txt
		if ! [ -s DetermDyn2.txt ]
			then
			echo "Not Deterministic!"
			echo " " >> DetermDyn.txt
			echo "New Pyxis Run not Deterministic with itself" >> DetermDyn.txt
			sleep 5s
			exit
		fi
		break
	fi
done

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript1.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/';" AnalysisRNXScript1.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/Plots\/';" AnalysisRNXScript1.m
sed -i "/truthStr = /c\truthStr = 'test2.txt';" AnalysisRNXScript1.m

# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript1.m; exit;"



## Execute Pyxis with Valgrind
cd ../output/Static1
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis
./pyxis

while [ true ]
	do
	cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStat.txt
	cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStat.txt
	if ! [ -s DetermDyn.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		mv timingaptBinaries_0_0.bin REVISEDtimingaptBinaries_0_0.bin
		mv timingrnxBinaries_0_0.bin REVISEDtimingrnxBinaries_0_0.bin
		./pyxis
		cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStat2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStat2.txt
		if ! [ -s DetermStat2.txt ]
			then
			echo "Not Deterministic!"
			echo " " >> DetermStat.txt
			echo "New Pyxis Run not Deterministic with itself" >> DetermStat.txt
			sleep 5s
			exit
		fi
		break
	fi
done

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Static1\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Static1\/Plots\/';" AnalysisRNXScript2.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript2.m

# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

## Time when Core 2 was finished is printed to Summary.txt
cd ../output
echo 'Core 2 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core2 completion message printed to terminal
echo "Core 2 is finished"
sleep 3s
