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
cd ../output/Dynamic
STARTTIME=$(date +%s)
valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis &> screenout.txt
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
echo "URSP-N210 Sampfreq:4e6 54min x86 Dynamic: $diff" >> ../times.txt

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
		./pyxis &> /dev/null
		cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermDyn2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermDyn2.txt
		break
	fi
done

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '..\/output\/Dynamic\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '..\/output\/Dynamic\/Plots\/';" AnalysisRNXScript2.m
sed -i "/truthStr = /c\truthStr = 'DriveTruth.txt';" AnalysisRNXScript2.m
sed -i "/ResY = /c\ResY = importWeek('..\/output\/Dynamic\/Plots/ResY.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('..\/output\/Dynamic\/Plots/ResW.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript2.m; exit;"

## Execute Pyxis with Valgrind
cd ../output/Static
STARTTIME=$(date +%s)
valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis &> screenout.txt
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
echo "MAX2769 Sampfreq:6864e6 52min Static: $diff" >> ../times.txt

while [ true ]
	do
	cmp ./REFaptrnx/REFtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStat.txt
	cmp ./REFaptrnx/REFtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStat.txt
	if ! [ -s DetermStat.txt ]
		then
		break
	else
		echo "Pyxis results different than Reference, running again"
		mv timingaptBinaries_0_0.bin REVISEDtimingaptBinaries_0_0.bin
		mv timingrnxBinaries_0_0.bin REVISEDtimingrnxBinaries_0_0.bin
		./pyxis &> /dev/null
		cmp REVISEDtimingaptBinaries_0_0.bin timingaptBinaries_0_0.bin > DetermStat2.txt
		cmp REVISEDtimingrnxBinaries_0_0.bin timingrnxBinaries_0_0.bin >> DetermStat2.txt
		break
	fi
done

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '..\/output\/Static\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '..\/output\/Static\/Plots\/';" AnalysisRNXScript2.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript2.m
sed -i "/ResY = /c\ResY = importWeek('..\/output\/Static\/Plots/ResY.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('..\/output\/Static\/Plots/ResW.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript2.m; exit;"

## Time when Core 2 was finished is printed to Summary.txt
cd ../output
echo 'Core 2 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core2 completion message printed to terminal
echo "Core 2 is finished"
sleep 3s
