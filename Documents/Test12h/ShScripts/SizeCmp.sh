#!/bin/bash

cd ../output

echo -n "MAX2769 Sampfreq:6864e6 26min x86 StaticSim: " > APTsize.txt
du -b StaticSim/timingaptBinaries_0_0.bin >> APTsize.txt
echo -n "MAX2769 Sampfreq:6864e6 26min x86 StaticSim: " > RNXsize.txt
du -b StaticSim/timingrnxBinaries_0_0.bin >> RNXsize.txt

echo " " >> APTsize.txt
echo " " >> RNXsize.txt

echo -n "URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic: " >> APTsize.txt
du -b Dynamic/timingaptBinaries_0_0.bin >> APTsize.txt
echo -n "URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic: " >> RNXsize.txt
du -b Dynamic/timingrnxBinaries_0_0.bin >> RNXsize.txt

echo " " >> APTsize.txt
echo " " >> RNXsize.txt

echo -n "MAX2769 Sampfreq:6864e6 52min Static: " >> APTsize.txt
du -b Static/timingaptBinaries_0_0.bin >> APTsize.txt
echo -n "MAX2769 Sampfreq:6864e6 52min Static: " >> RNXsize.txt
du -b Static/timingrnxBinaries_0_0.bin >> RNXsize.txt

echo " " >> APTsize.txt
echo " " >> RNXsize.txt

echo -n "MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1: " >> APTsize.txt
du -b StaticLong/timingaptBinaries_0_0.bin >> APTsize.txt
echo -n "MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1: " >> RNXsize.txt
du -b StaticLong/timingrnxBinaries_0_0.bin >> RNXsize.txt

echo " " >> APTsize.txt
echo " " >> RNXsize.txt

echo -n "MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2: " >> APTsize.txt
du -b StaticLong/timingaptBinaries_1860_0.bin >> APTsize.txt
echo -n "MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2: " >> RNXsize.txt
du -b StaticLong/timingrnxBinaries_1860_0.bin >> RNXsize.txt

echo " " >> APTsize.txt
echo " " >> RNXsize.txt

echo -n "MAX2769 Sampfreq:6864e6 52min ARM Static: " >> APTsize.txt
du -b /6TB/nfsshare/nightly-results/timingaptBinaries_0_0.bin >> APTsize.txt
echo -n "MAX2769 Sampfreq:6864e6 52min ARM Static: " >> RNXsize.txt
du -b /6TB/nfsshare/nightly-results/timingrnxBinaries_0_0.bin >> RNXsize.txt

