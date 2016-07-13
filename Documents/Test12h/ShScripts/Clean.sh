#!/bin/bash
#################################################
#      	         Clean			        #
# Deletes at start-up all unnecessary files.	#
#						#
# Input: Summary.txt, results_0_0.txt,       	#
#	 Wwarning.txt, valwar.txt for both 	#
#	 Static and Dynamic and 		#
#	 DetermDyn.txt and DetermStat.txt.	#
#						#
# Output: none.					#
#################################################

cd ../output

rm times.txt &> /dev/null
rm error.txt &> /dev/null

cd Dynamic

## Remove all unnecessary files
rm pyxis &> /dev/null
rm REVISEDtimingrnxBinaries_0_0.bin &> /dev/null
rm REVISEDtimingaptBinaries_0_0.bin &> /dev/null
rm timingrnxBinaries_0_0.bin &> /dev/null
rm timingaptBinaries_0_0.bin &> /dev/null
rm screenout.txt &> /dev/null
rm valwar.txt &> /dev/null
rm Wwarning.txt &> /dev/null
rm DetermDyn.txt &> /dev/null
rm DetermDyn2.txt &> /dev/null
rm stdout.txt &> /dev/null
rm stderr.txt &> /dev/null

cd Plots
rm results_0_0.txt &> /dev/null

cd ../../Static

## Remove all unnecessary files
rm pyxis &> /dev/null
rm REVISEDtimingrnxBinaries_0_0.bin &> /dev/null
rm REVISEDtimingaptBinaries_0_0.bin &> /dev/null
rm timingrnxBinaries_0_0.bin &> /dev/null
rm timingaptBinaries_0_0.bin &> /dev/null
rm screenout.txt &> /dev/null
rm valwar.txt &> /dev/null
rm Wwarning.txt &> /dev/null
rm DetermStat.txt &> /dev/null
rm DetermStat2.txt &> /dev/null
rm stdout.txt &> /dev/null
rm stderr.txt &> /dev/null

cd Plots
rm results_0_0.txt &> /dev/null

cd ../../StaticLong

## Remove all unnecessary files
rm pyxis &> /dev/null
rm timingrnxBinaries_0_0.bin &> /dev/null
rm timingaptBinaries_0_0.bin &> /dev/null
rm timingrnxBinaries_1859_518400.bin &> /dev/null
rm timingaptBinaries_1859_518400.bin &> /dev/null
rm timingrnxBinaries_1860_0.bin &> /dev/null
rm timingaptBinaries_1860_0.bin &> /dev/null
rm screenout.txt &> /dev/null
rm Wwarning.txt &> /dev/null
rm DetermStatL.txt &> /dev/null

cd Plots
rm results_0_0.txt &> /dev/null
rm results_1859_518400.bin &> /dev/null
rm results_1860_0.bin &> /dev/null

cd ../../StaticSim

## Remove all unnecessary files
rm pyxis &> /dev/null
rm timingrnxBinaries_0_0.bin &> /dev/null
rm timingaptBinaries_0_0.bin &> /dev/null
rm screenout.txt &> /dev/null
rm Wwarning.txt &> /dev/null
rm DetermStatSim.txt &> /dev/null

cd Plots
rm results_0_0.txt &> /dev/null

## Will need to do same for arm test
loc=`pwd`
cd /6TB/nfsshare
rm pyxis &> /dev/null

cd nightly-results
rm REVISEDtimingrnxBinaries_0_0.bin &> /dev/null
rm REVISEDtimingaptBinaries_0_0.bin &> /dev/null
rm timingrnxBinaries_0_0.bin &> /dev/null
rm timingaptBinaries_0_0.bin &> /dev/null
rm screenout.txt &> /dev/null
rm Wwarning.txt &> /dev/null
rm DetermARM.txt &> /dev/null
rm stdout.txt &> /dev/null
rm stderr.txt &> /dev/null

## Clean matlab files
cd $loc
cd ../../../MATLAB
rm AnalysisRNXScript1.m &> /dev/null
rm AnalysisRNXScript2.m &> /dev/null
rm AnalysisRNXScript3.m &> /dev/null

## Clean completion message printed to terminal
echo "Clean is finished"
sleep 1s
