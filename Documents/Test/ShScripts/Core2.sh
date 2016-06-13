#!/bin/bash
#################################################
#      	Pyxis Test Core 2			#
# Tests the current build of Pyxis and shows	#
# results as plots from matlab as well as info	#
# regarding execution of the file.		#
#						#
# Input: Raw Intermediate Frequency (IF) files  #
#	that are static, dynamic, real and	#
#	complex.				#
#						#
# Output: Wwarning.txt, Valwar.txt, 		#
# 	MATLAB plots, DetermStat.txt, apt and	#
# 	rnx Binaries.				#
#################################################

cd /home/dma/Documents/Test/MATLAB

# Set Matlab preferences
sed -i "/plotWholePos =              /c\plotWholePos =              1;" AnalysisRNXScript2.m
sed -i "/plotIntervalPos =           /c\plotIntervalPos =           1;" AnalysisRNXScript2.m
sed -i "/plotSigParams =             /c\plotSigParams =             1;" AnalysisRNXScript2.m
sed -i "/plotVelocityComponents =    /c\plotVelocityComponents =    1;" AnalysisRNXScript2.m
sed -i "/plotVelocityHist =          /c\plotVelocityHist =          1;" AnalysisRNXScript2.m
sed -i "/plotPRNElevation =          /c\plotPRNElevation =          1;" AnalysisRNXScript2.m
sed -i "/plot2DSky =                 /c\plot2DSky =                 0;" AnalysisRNXScript2.m
sed -i "/plot3DSky =                 /c\plot3DSky =                 0;" AnalysisRNXScript2.m
sed -i "/performOutageAnalysis =     /c\performOutageAnalysis =     1;" AnalysisRNXScript2.m
sed -i "/savePlots =                 /c\savePlots =                 1;" AnalysisRNXScript2.m
sed -i "/saveResultsandSendEmail =   /c\saveResultsandSendEmail =   1;" AnalysisRNXScript2.m
sed -i "/generateKMLfile =           /c\generateKMLfile =           0;" AnalysisRNXScript2.m

# Set so no email is sent
sed -i "/sendmail(recipients,subject,body);/c\    %sendmail(recipients,subject,body);" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/sendmail(recipients,subject,body,attachments);/c\    %sendmail(recipients,subject,body,attachments);" ./HelperFunctions/sendLssRnxEmail.m

# Executing Pyxis
cd ../output/Static1Heavy

#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis

./pyxis

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/Plots\/';" AnalysisRNXScript2.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

# Executing Pyxis
echo "Printing Static 1 output to screenout.txt"
cd ../output/Static1
./pyxis &> screenout.txt

# Test if deterministic
cd ../Static1Heavy
echo 'apt Differences:' > DetermStat.txt
cmp timingaptBinaries_0_0.bin ../Static1/timingaptBinaries_0_0.bin >> DetermStat.txt
echo ' ' >> DetermStat.txt
echo 'rnx Differences:' >> DetermStat.txt
cmp timingrnxBinaries_0_0.bin ../Static1/timingrnxBinaries_0_0.bin >> DetermStat.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Static1\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Static1\/Plots\/';" AnalysisRNXScript2.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

## Time when Core 2 was finished
cd ../output
echo 'Core 2 was done at the local time of:' >> Summary.txt
date >> Summary.txt

# # Finished script
echo "Core 2 is finished"
sleep 5s
