#!/bin/bash
#################################################
#      	Pyxis Test Core 1			#
# Tests the current build of Pyxis and shows	#
# results.					#
#################################################

cd /home/dma/Documents/Test

# Starts the Core2.sh file
gnome-terminal -x ./ShScripts/Core2.sh
# Executing Pyxis with Valgrind
cd ./output/Dynamic1Heavy

#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis

./pyxis

# Test if deterministic
echo 'apt Differences:' > DetermDyn.txt
cmp timingaptBinaries_0_0.bin ../Dynamic1/timingaptBinaries_0_0.bin >> DetermDyn.txt
echo ' ' >> DetermDyn.txt
echo 'rnx Differences:' >> DetermDyn.txt
cmp timingrnxBinaries_0_0.bin ../Dynamic1/timingrnxBinaries_0_0.bin >> DetermDyn.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/';" AnalysisRNXScript.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/Plots\/';" AnalysisRNXScript.m
sed -i "/truthStr = /c\truthStr = 'test2.txt';" AnalysisRNXScript.m
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

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript.m; exit;"

# Executing Pyxis
echo "Printing Dynamic 1 output to screenout.txt"
cd /home/dma/Documents/Test/output/Dynamic1
./pyxis &> screenout.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/';" AnalysisRNXScript.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/Plots\/';" AnalysisRNXScript.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript.m; exit;" 

## Time when Core 1 was finished
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

echo "Core 1 is finished"

# Check if Core2 is running
if [ `pgrep -c Core2.sh` -gt 0 ]
then
echo "Waiting for Core 2 to finish..."
while [ `pgrep -c Core2.sh` -gt 0 ]
do
sleep 1s
done
fi

# Run Performance.sh once Core2 is finished
../ShScripts/Performance.sh

## Finished script
echo "Test is finished"
sleep 5s
