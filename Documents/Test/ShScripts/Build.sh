#!/bin/bash
#################################################
#      		Build				#
# Compiles all the pyxis before running it.	#
#################################################

## Set Dynamic1 as test file with Valgrind and set output
cd /home/dma/Documents/Test/Pyxis_current/pyxis/src/conf
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

mv ./Pyxis_current/pyxis/bin/rcv/pyxis ./output/Dynamic1Heavy/

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

mv ./Pyxis_current/pyxis/bin/rcv/pyxis ./output/Dynamic1/

## Set MAX2769 static1Heavy file as input
cd /home/dma/Documents/Test/Pyxis_current/pyxis/src/conf
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

## Set MAX2769 static1 file as input
cd /home/dma/Documents/Test/Pyxis_current/pyxis/src/conf
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

mv ../Pyxis_current/pyxis/bin/rcv/pyxis ../output/Static1/

cd /home/dma/Documents/Test/ShScripts

gnome-terminal -x ./PyxisTestCore1.sh
