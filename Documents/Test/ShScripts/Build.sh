#!/bin/bash
#################################################
#      		Build			#
# Compiles all pyxis and distributes it to all	#
# appropriate folders for four tests.	 	#
#						#
# Input: conf files and other build files.	#
#						#
# Output: pyxis builds in all three cases 	#
#         (Static1, Dynamic1, StaticSim)	#
#	  Wwarning.txt,				#
#	  apt and rnx binaries.			#
#################################################

## Set correct Test Case Parameters
cd ../Pyxis_current/pyxis/src/conf
sed -i '/#define NAVDEBUG/c\#define NAVDEBUG 0		\/\/\/< NAV debugging mode: run with APT' conf.h
sed -i '/#define LOGCOR/c\#define LOGCOR 0 		\/\/\/< Log the correlator data to a file' conf.h
sed -i '/#define LOGCOR/!b;n;c\#define LOGAPT 1 		\/\/\/< Log the navigation data to a file' conf.h
sed -i '/#define LOGKML/c\#define LOGKML 0 		\/\/\/< Log the KML data for Google Earth' conf.h
sed -i '/#define LOGRNX/c\#define LOGRNX 1 		\/\/\/< Log the LSS structure in navigation' conf.h

## Set correct input values and replace conf_swc.h with Dynamic1's conf_swc.h file
cd ../Pyxis_current/pyxis/src/conf
# Exchange for testing sampling rate, carrier frequency and acquisition threshold.
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )4e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 20e3		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 9e7\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Replace conf_swc.h with Dynamic1's conf_swc.h file (already preset with correct values)
cp ../../../../conf_swc/Dynamic1_conf_swc/conf_swc.h conf_swc.h
# Set File usage, complex, L2, linking in conf.mk file
cd ../../build/conf
sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=2' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

## Build Pyxis for Dynamic1 and send warnings to Wwarning.txt
cd ..
make clean
make 2> ../../../output/Dynamic1/Wwarning.txt

## Move pyxis into Dynamic1 output directory
mv ../bin/rcv/pyxis ../../../output/Dynamic1/

## Set correct input values and replace conf_swc.h with Static1's conf_swc.h file
cd ../src/conf
# Exchange for testing sampling rate and carrier frequency
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )6.864e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 2.1912e6		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF 6178 \/\/ ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 2.5e8\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Replace conf_swc.h with Static1's conf_swc.h file (already preset with correct values)
cp ../../../../conf_swc/Static1_conf_swc/conf_swc.h conf_swc.h
# Set File usage, real, no L2 and linking in conf.mk file
cd ../../build/conf
sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=1' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

## Build Pyxis for Static1 and send warnings to Wwarning.txt
cd ..
make clean
make 2> ../../../output/Static1/Wwarning.txt

## Move pyxis into Static1 output directory
mv ../bin/rcv/pyxis ../../../output/Static1/

## Build Pyxis for long test (make sure this is placed after Static so parameters can stay the same)
cd ../src/conf
# Replace conf_swc.h with Static1Heavy's conf_swc.h file (already preset with correct values)
cp ../../../../conf_swc/StaticSim_conf_swc/conf_swc.h conf_swc.h
# Build Pyxis for StaticSim
cd ../../build
make clean
make
# Move Pyxis into StaticSim output directory
mv ../bin/rcv/pyxis ../../../output/StaticSim/

cd ../../../MATLAB

# Set Matlab preferences: 1 indicates to run, 0 indicates to not run
sed -i "/plotWholePos =              /c\plotWholePos =              1;" AnalysisRNXScript1.m
sed -i "/plotIntervalPos =           /c\plotIntervalPos =           1;" AnalysisRNXScript1.m
sed -i "/plotSigParams =             /c\plotSigParams =             1;" AnalysisRNXScript1.m
sed -i "/plotVelocityComponents =    /c\plotVelocityComponents =    1;" AnalysisRNXScript1.m
sed -i "/plotVelocityHist =          /c\plotVelocityHist =          1;" AnalysisRNXScript1.m
sed -i "/plotPRNElevation =          /c\plotPRNElevation =          1;" AnalysisRNXScript1.m
sed -i "/plot2DSky =                 /c\plot2DSky =                 0;" AnalysisRNXScript1.m
sed -i "/plot3DSky =                 /c\plot3DSky =                 0;" AnalysisRNXScript1.m
sed -i "/performOutageAnalysis =     /c\performOutageAnalysis =     1;" AnalysisRNXScript1.m
sed -i "/savePlots =                 /c\savePlots =                 1;" AnalysisRNXScript1.m
sed -i "/saveResultsandSendEmail =   /c\saveResultsandSendEmail =   1;" AnalysisRNXScript1.m
sed -i "/generateKMLfile =           /c\generateKMLfile =           0;" AnalysisRNXScript1.m
# Set Matlab preferences: 1 indicates to run, 0 indicates to not run
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
# Set Matlab preferences: 1 indicates to run, 0 indicates to not run
sed -i "/plotWholePos =              /c\plotWholePos =              1;" AnalysisRNXScript3.m
sed -i "/plotIntervalPos =           /c\plotIntervalPos =           1;" AnalysisRNXScript3.m
sed -i "/plotSigParams =             /c\plotSigParams =             1;" AnalysisRNXScript3.m
sed -i "/plotVelocityComponents =    /c\plotVelocityComponents =    1;" AnalysisRNXScript3.m
sed -i "/plotVelocityHist =          /c\plotVelocityHist =          1;" AnalysisRNXScript3.m
sed -i "/plotPRNElevation =          /c\plotPRNElevation =          1;" AnalysisRNXScript3.m
sed -i "/plot2DSky =                 /c\plot2DSky =                 0;" AnalysisRNXScript3.m
sed -i "/plot3DSky =                 /c\plot3DSky =                 0;" AnalysisRNXScript3.m
sed -i "/performOutageAnalysis =     /c\performOutageAnalysis =     1;" AnalysisRNXScript3.m
sed -i "/savePlots =                 /c\savePlots =                 1;" AnalysisRNXScript3.m
sed -i "/saveResultsandSendEmail =   /c\saveResultsandSendEmail =   1;" AnalysisRNXScript3.m
sed -i "/generateKMLfile =           /c\generateKMLfile =           0;" AnalysisRNXScript3.m
# Set so no email is sent
sed -i "/sendmail(recipients,subject,body);/c\    %sendmail(recipients,subject,body);" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/disp('No attachments');/c\    %disp('No attachments');" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/sendmail(recipients,subject,body,attachments);/c\    %sendmail(recipients,subject,body,attachments);" ./HelperFunctions/sendLssRnxEmail.m
sed -i "/disp('Attachments');/c\    %disp('Attachments');" ./HelperFunctions/sendLssRnxEmail.m

## Print completion of build message to terminal
echo "All buildings of pyxis are completed"
sleep 1s
