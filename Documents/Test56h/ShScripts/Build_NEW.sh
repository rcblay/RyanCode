#!/bin/bash
#################################################
#      		Build				#
# Compiles all pyxis and distributes it to all	#
# appropriate folders for all tests.	 	#
#						#
# Input: conf files and other build files.	#
#						#
# Output: pyxis builds in all cases 		#
#	  Wwarning.txt,				#
#	  apt and rnx binaries.			#
#################################################

#
# Set correct Test Case Parameters
cd ../Pyxis_current/pyxis/src/conf
sed -i '/#define NAVDEBUG/c\#define NAVDEBUG 0		\/\/\/< NAV debugging mode: run with APT' conf.h
sed -i '/#define LOGCOR/c\#define LOGCOR 0 		\/\/\/< Log the correlator data to a file' conf.h
sed -i '/#define LOGCOR/!b;n;c\#define LOGAPT 1 		\/\/\/< Log the navigation data to a file' conf.h
sed -i '/#define LOGKML/c\#define LOGKML 0 		\/\/\/< Log the KML data for Google Earth' conf.h
sed -i '/#define LOGRNX/c\#define LOGRNX 1 		\/\/\/< Log the LSS structure in navigation' conf.h

### DYNAMIC COMPLEX

## Set correct input values and replace conf_swc.h with DynamicComplex's conf_swc.h file # BUILDING DYNAMICCOMPLEX
# Exchange for testing sampling rate, carrier frequency and acquisition threshold.
sed -i '/#define SAMPLINGRATE/c\#define SAMPLINGRATE (ui64 )4e6       \/*Sampling frequency, default is a 40MHz sampling rate*\/' conf.h
sed -i '/#define CARRFREQ/c\#define CARRFREQ 20e3		\/*Intermediate frequency*\/' conf.h
sed -i '/NUMSAMPLEINBUFF/c\#define NUMSAMPLEINBUFF ( (NUMSAMPLE1MSEC \/ 10) * 9)\/\/6178 65536 \/\/2^16, should be more than 1msec of data (depends on sampling freq), more has more latency' conf.h
sed -i '/ACQTHRESHOLD/c\#define ACQTHRESHOLD (ui64) 9e7\/\/2.5e8\/\/9e7\/\/2e8 for all the other ones.' conf_chn.h
# Replace conf_swc.h with DynamicComplex's conf_swc.h file (already preset with correct values)
cp ../../../../conf_swc/conf_dynamicComplex.h conf_swc.h
# Set File usage, complex, L2, linking in conf.mk file
cd ../../build/conf
sed -i '/FRONTENDTYPE=/c\FRONTENDTYPE=FILE#USB\/FILE' conf.mk
sed -i '/FILETYPE/c\FILETYPE=2' conf.mk
sed -i '/USEL2C/c\USEL2C=FALSE' conf.mk
sed -i '/LINKING=/c\LINKING=DYNAMIC' conf.mk

## Build Pyxis for DynamicComplex and save stderr and stdout
cd ..
make clean &> /dev/null
make 2> ../../../output/DynamicComplex/stderr.txt 1> ../../../output/DynamicComplex/stdout.txt

## Move pyxis into DynamicComplex output directory
mv ../bin/rcv/pyxis ../../../output/DynamicComplex/




