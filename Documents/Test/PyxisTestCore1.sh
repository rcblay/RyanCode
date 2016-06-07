#!/bin/bash
#################################################
#      	Pyxis Test Core 1			#
# Tests the current build of Pyxis and shows	#
# results.					#
#################################################

## Time of starting operation
cd /home/dma/Documents/Test/output
echo 'Pyxis Test was started at the local time of:' > Summary.txt
date >> Summary.txt

## Set Dynamic1 as test file with Valgrind and set output
cd ../Pyxis_current/pyxis/src/conf
# Exchange for testing sampling rate, carrier frequency and acquisition threshold.
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )4e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 20e3		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 9e7\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Exchange input and output files
sed -i '/#define DATAFILEIN/c\#define DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Dynamic1\/L1_201510161135_fs_4e6_if20e3_schar1bit.bin"' conf_swc.h
sed -i '/#define L2DATAFILEIN/c\\/\/#define L2DATAFILEIN "\/home\/dma\/Documents\/Test\/input\/Dynamic1\/L2_201510161135_fs_4e6_if20e3_schar1bit.bin"' conf_swc.h

sed -i '/FAPT/c\#define APTOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/timingaptBinaries_%d_%d.bin" \/\/FAPT' conf_swc.h
sed -i '/FKML/c\#define KMLOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/data.kml" \/\/FKML' conf_swc.h
sed -i '/FPOS/c\#define POSOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/posBinaries.bin" \/\/FPOS' conf_swc.h
sed -i '/FOBS/c\#define OBSOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/obsBinaries.bin" \/\/FOBS' conf_swc.h
sed -i '/FRNX/c\#define RNXOUT "\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/timingrnxBinaries_%d_%d.bin" \/\/FRNX' conf_swc.h
# Set File usage, complex, L2, linking 
cd ../../build/conf

sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=2' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk
# Building Pyxis
cd ..
make clean
make 2> ../../../output/Dynamic1Heavy/Wwarning.txt
# Moving and  Starts the Core2.sh file
mv ../bin/rcv/pyxis ../../../output/Dynamic1Heavy/
gnome-terminal -x ../../../Core2.sh
# Executing Pyxis with Valgrind
cd ../../../output/Dynamic1Heavy

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
#sed -i '/dateVector =/c\dateVector = [0 0];' AnalysisRNXScriptC1.m
sed -i "/parentpath =/c\parentpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/';" AnalysisRNXScript.m
sed -i "/plotpath =/c\plotpath = '\/home\/dma\/Documents\/Test\/output\/Dynamic1Heavy\/Plots\/';" AnalysisRNXScript.m
#sed -i "/fileStrTitles =/c\fileStrTitles = 'rnxBinaries\_0\_0.bin'" AnalysisRNXScript.m

matlab -nodesktop -r "run /home/dma/Documents/Test/MATLAB/AnalysisRNXScript.m; exit;"

## Time when Core 1 was finished
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

echo "Core 1 is finished"

# Check if Core2 is running
if [ `pgrep -c Core2.sh` -gt 0 ]
then
echo "Wait for Core 2 to finish"
while [ `pgrep -c Core2.sh` -gt 0 ]
do
sleep 1s
done
fi

# Run Performance.sh once Core2 is finished
../Performance.sh

## Finished script
echo "Test is finished"
sleep 5s
