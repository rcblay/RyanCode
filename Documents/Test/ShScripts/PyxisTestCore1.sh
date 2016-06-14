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

# Change to Test directory
cd /home/dma/Documents/Test

## Execute Pyxis with Valgrind
cd ./output/Dynamic1Heavy
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis
./pyxis

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/';" AnalysisRNXScript.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/Plots\/';" AnalysisRNXScript.m
sed -i "/truthStr = /c\truthStr = 'test2.txt';" AnalysisRNXScript.m
# Set Matlab preferences: 1 indicates to run, 0 indicates to not run
sed -i "/plotWholePos =              /c\plotWholePos =              1;" AnalysisRNXScript.m
sed -i "/plotIntervalPos =           /c\plotIntervalPos =           1;" AnalysisRNXScript.m
sed -i "/plotSigParams =             /c\plotSigParams =             1;" AnalysisRNXScript.m
sed -i "/plotVelocityComponents =    /c\plotVelocityComponents =    1;" AnalysisRNXScript.m
sed -i "/plotVelocityHist =          /c\plotVelocityHist =          1;" AnalysisRNXScript.m
sed -i "/plotPRNElevation =          /c\plotPRNElevation =          1;" AnalysisRNXScript.m
sed -i "/plot2DSky =                 /c\plot2DSky =                 0;" AnalysisRNXScript.m
sed -i "/plot3DSky =                 /c\plot3DSky =                 0;" AnalysisRNXScript.m
sed -i "/performOutageAnalysis =     /c\performOutageAnalysis =     1;" AnalysisRNXScript.m
sed -i "/savePlots =                 /c\savePlots =                 1;" AnalysisRNXScript.m
sed -i "/saveResultsandSendEmail =   /c\saveResultsandSendEmail =   1;" AnalysisRNXScript.m
sed -i "/generateKMLfile =           /c\generateKMLfile =           0;" AnalysisRNXScript.m
# Set so no email is sent
sed -i "/sendmail(recipients,subject,body);/c\    %sendmail(recipients,subject,body);" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/disp('No attachments');/c\    %disp('No attachments');" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/sendmail(recipients,subject,body,attachments);/c\    %sendmail(recipients,subject,body,attachments);" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/disp('Attachments');/c\    %disp('Attachments');" ./HelperFunctions/sendLssRnxEmail.m
# Run matlab
matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript.m; exit;"

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
