#!/bin/bash
#################################################
#      		Build				#
# Compiles all pyxis and distributes it to all	#
# appropriate folders for four tests.	 	#
#						#
# Input: conf files and other build files.	#
#						#
# Output: pyxis builds in all four cases 	#
#         (Static1, Static1Heavy, Dynamic1,	#
#	  Dynamic1Heavy), Wwarning.txt,		#
#	  apt and rnx binaries.			#
#################################################

## Set correct input values and replace conf_swc.h with Dynamic1Heavy's conf_swc.h file
cd ../Pyxis_current/pyxis/src/conf
# Exchange for testing sampling rate, carrier frequency and acquisition threshold.
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )4e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 20e3		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 9e7\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Replace conf_swc.h with Dynamic1Heavy's conf_swc.h file (already preset with correct values)
cp ../../../../conf_swc/Dynamic1Heavy_conf_swc/conf_swc.h conf_swc.h
# Set File usage, complex, L2, linking in conf.mk file
cd ../../build/conf
sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=2' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

## Build Pyxis for Dynamic1Heavy and send warnings to Wwarning.txt
cd ..
make clean
make 2> ../../../output/Dynamic1Heavy/Wwarning.txt

## Move pyxis into Dynamic1Heavy output directory
mv ../bin/rcv/pyxis ../../../output/Dynamic1Heavy/

## Replace conf_swc.h with Dynamic1's conf_swc.h file
cd ../src/conf
cp ../../../../conf_swc/Dynamic1_conf_swc/conf_swc.h conf_swc.h

## Build Pyxis for Dynamic1 (no need to send warnings since Dynamic1Heavy is same build)
cd ../../build
make clean
make

## Move pyxis into Dynamic1 output directory
mv ../bin/rcv/pyxis ../../../output/Dynamic1/

## Set correct input values and replace conf_swc.h with Static1Heavy's conf_swc.h file
cd ../src/conf
# Exchange for testing sampling rate and carrier frequency
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )6.864e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 2.1912e6		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF 6178 \/\/ ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 2.5e8\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Replace conf_swc.h with Static1Heavy's conf_swc.h file (already preset with correct values)
cp ../../../../conf_swc/Static1Heavy_conf_swc/conf_swc.h conf_swc.h
# Set File usage, real, no L2 and linking in conf.mk file
cd ../../build/conf
sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=1' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

## Build Pyxis for Static1Heavy and send warnings to Wwarning.txt
cd ..
make clean
make 2> ../../../output/Static1Heavy/Wwarning.txt

## Move pyxis into Static1Heavy output directory
mv ../bin/rcv/pyxis ../../../output/Static1Heavy/

## Replace conf_swc.h with Static1's conf_swc.h file
cd ../src/conf
cp ../../../../conf_swc/Static1_conf_swc/conf_swc.h conf_swc.h

## Build Pyxis for Static1 (no need to send warnings since Static1Heavy is same build)
cd ../../build
make clean
make

## Move pyxis into Static1 output directory
mv ../bin/rcv/pyxis ../../../output/Static1/

## Print completion of build message to terminal
echo "All buildings of pyxis are completed"
sleep 1s
