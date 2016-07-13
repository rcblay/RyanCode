#!/bin/bash
#################################################
#      		   timeRatio			#
# Finds last time ratio in each Screenout.txt	#
# and saves them in tratio.txt.			#
#						#
# Input: Screenout.txt files			#
#						#
# Output:  tratio.txt				#
#################################################

# Change directory
cd ../output

# StaticSim
echo -n "MAX2769 Sampfreq:6864e6 26min x86 StaticSim: " >> tratio.txt
timeRatioSS=`grep 'times as fast as' ./StaticSim/screenout.txt | tail -1`
echo "$timeRatioSS" >> tratio.txt

# Static
echo -n "MAX2769 Sampfreq:6864e6 52min Static: " >> tratio.txt
timeRatioS=`grep 'times as fast as' ./Static/screenout.txt | tail -1`
echo "$timeRatioS" >> tratio.txt

# ARM Static
echo -n "MAX2769 Sampfreq:6864e6 52min ARM Static: " >> tratio.txt
timeRatioAS=`grep 'times as fast as' /6TB/nfsshare/nightly-results/screenout.txt | tail -1`
echo "$timeRatioAS" >> tratio.txt

# Static Long
echo -n "MAX2769 Sampfreq:6864e6 24hours x86 StaticLong: " >> tratio.txt
timeRatioSL=`grep 'times as fast as' ./StaticLong/screenout.txt | tail -1`
echo "$timeRatioSL" >> tratio.txt

# Dynamic
echo -n "URSP-N210 Sampfreq:4e6 54min x86 Dynamic: " >> tratio.txt
timeRatioD=`grep 'times as fast as' ./Dynamic/screenout.txt | tail -1`
echo "$timeRatioD" >> tratio.txt

