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


## Set Dynamic1 (no L2C) as test file and set output
cd /home/dma/Documents/Test/Pyxis_current/pyxis/src/conf
# Exchange for testing sampling rate and carrier frequency
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )4e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 20e3		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 9e7\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Exchange input and output files
sed -i '/#define DATAFILEIN/c\#define DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Dynamic1\/L1_201510161135_fs_4e6_if20e3_schar1bit.bin"' conf_swc.h
sed -i '/#define L2DATAFILEIN/c\\/\/#define L2DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Dynamic1\/L2_201510161135_fs_4e6_if20e3_schar1bit.bin"' conf_swc.h

sed -i '/FAPT/c\#define APTOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1\/timingaptBinaries_%d_%d.bin" \/\/FAPT' conf_swc.h
sed -i '/FKML/c\#define KMLOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1\/data.kml" \/\/FKML' conf_swc.h
sed -i '/FPOS/c\#define POSOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1\/posBinaries.bin" \/\/FPOS' conf_swc.h
sed -i '/FOBS/c\#define OBSOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1\/obsBinaries.bin" \/\/FOBS' conf_swc.h
sed -i '/FRNX/c\#define RNXOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1\/timingrnxBinaries_%d_%d.bin" \/\/FRNX' conf_swc.h
# Set File usage, complex and L1 and linking
cd ../../build/conf

sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=2' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

# Building Pyxis
cd ..
make clean
make
# Moving and  Starts the Core3.sh file
mv ../bin/rcv/pyxis ../../../output/Dynamic1/
#gnome-terminal -x ./core3.sh
# Executing Pyxis
cd ../../../output/Dynamic1
./pyxis &> screenout.txt

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
#sed -i '/dateVector =/c\dateVector = [0 0];' AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1\/Plots\/';" AnalysisRNXScript2.m
#sed -i "/fileStrTitles =/c\fileStrTitles = 'rnxBinaries\_0\_0.bin'" AnalysisRNXScript2.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

## Set MAX2769 static1Heavy file as input
cd ../Pyxis_current/pyxis/src/conf
# Exchange for testing sampling rate and carrier frequency
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )6.864e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 2.1912e6		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF 6178 \/\/ ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 2.5e8\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Exchange input and output files
sed -i '/#define DATAFILEIN/c\#define DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Static_6864e6\/MAX2769_L1_20150828_20150831_fs_6864e6_if21912e6_schar_20GB.bin"' conf_swc.h
sed -i '/#define L2DATAFILEIN/c\\/\/#define L2DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Dynamic1\/L2_201510161135_fs_4e6_if20e3_schar1bit.bin"' conf_swc.h

sed -i '/FAPT/c\#define APTOUT "\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/timingaptBinaries_%d_%d.bin" \/\/FAPT' conf_swc.h
sed -i '/FKML/c\#define KMLOUT "\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/data.kml" \/\/FKML' conf_swc.h
sed -i '/FPOS/c\#define POSOUT "\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/posBinaries.bin" \/\/FPOS' conf_swc.h
sed -i '/FOBS/c\#define OBSOUT "\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/obsBinaries.bin" \/\/FOBS' conf_swc.h
sed -i '/FRNX/c\#define RNXOUT "\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/timingrnxBinaries_%d_%d.bin" \/\/FRNX' conf_swc.h
# Set File usage, real, no L2 and linking
cd ../../build/conf

sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=1' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

# Building Pyxis
cd ..
make clean
make 2> ../../../output/Static1Heavy/Wwarning.txt
# Moving and  Starts the Core3.sh file
mv ../bin/rcv/pyxis ../../../output/Static1Heavy/
#gnome-terminal -x ./core3.sh
# Executing Pyxis
cd ../../../output/Static1Heavy
#valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --log-file="valwar.txt" ./pyxis

./pyxis

## Set input, execute matlab code and save output (Make sure that the path is saved, even at restart).
cd ../../MATLAB
sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript2.m
#sed -i '/dateVector =/c\dateVector = [0 0];' AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Static1Heavy\/Plots\/';" AnalysisRNXScript2.m
#sed -i "/fileStrTitles =/c\fileStrTitles = 'rnxBinaries\_0\_0.bin'" AnalysisRNXScript2.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"


## Set MAX2769 static1 file as input
cd ../Pyxis_current/pyxis/src/conf
# Exchange for testing sampling rate and carrier frequency
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )6.864e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 2.1912e6		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF 6178 \/\/ ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 2.5e8\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Exchange input and output files
sed -i '/#define DATAFILEIN/c\#define DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Static_6864e6\/MAX2769_L1_20150828_20150831_fs_6864e6_if21912e6_schar_20GB.bin"' conf_swc.h
sed -i '/#define L2DATAFILEIN/c\\/\/#define L2DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Dynamic1\/L2_201510161135_fs_4e6_if20e3_schar1bit.bin"' conf_swc.h

sed -i '/FAPT/c\#define APTOUT "\/home\/dma\/Documents\/Test\/output\/Static1\/timingaptBinaries_%d_%d.bin" \/\/FAPT' conf_swc.h
sed -i '/FKML/c\#define KMLOUT "\/home\/dma\/Documents\/Test\/output\/Static1\/data.kml" \/\/FKML' conf_swc.h
sed -i '/FPOS/c\#define POSOUT "\/home\/dma\/Documents\/Test\/output\/Static1\/posBinaries.bin" \/\/FPOS' conf_swc.h
sed -i '/FOBS/c\#define OBSOUT "\/home\/dma\/Documents\/Test\/output\/Static1\/obsBinaries.bin" \/\/FOBS' conf_swc.h
sed -i '/FRNX/c\#define RNXOUT "\/home\/dma\/Documents\/Test\/output\/Static1\/timingrnxBinaries_%d_%d.bin" \/\/FRNX' conf_swc.h
# Set File usage, real, no L2 and linking
cd ../../build/conf

sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=1' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

# Building Pyxis
cd ..
make clean
make
# Moving and  Starts the Core3.sh file
mv ../bin/rcv/pyxis ../../../output/Static1/
#gnome-terminal -x ./core3.sh
# Executing Pyxis
cd ../../../output/Static1
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
#sed -i '/dateVector =/c\dateVector = [0 0];' AnalysisRNXScript2.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Static1\/';" AnalysisRNXScript2.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Static1\/Plots\/';" AnalysisRNXScript2.m
#sed -i "/fileStrTitles =/c\fileStrTitles = 'rnxBinaries\_0\_0.bin'" AnalysisRNXScript2.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript2.m; exit;"

## Time when Core 1 was finished
cd ../output
echo 'Core 2 was done at the local time of:' >> Summary.txt
date >> Summary.txt

# # Finished script
echo "Core 2 is finished"
sleep 5s
