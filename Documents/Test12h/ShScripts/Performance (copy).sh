#!/bin/bash
#################################################
#      	         Performance		        #
# Cuts and pastes important results into text	#
# file.	Also checks whether the mean error has	#
# increased by a certain threshold of 20 cm.	#
#						#
# Input: Summary.txt, results_0_0.txt,       	#
#	 Wwarning.txt, valwar.txt for both 	#
#	 Static and Dynamic and 		#
#	 DetermDyn.txt and DetermStat.txt.	#
#						#
# Output: PerfSummary.txt			#
#################################################

## Test Characteristics Summary
cd ../output
echo "###########################   Small Weekend Report   ##########################" > Report.txt
echo " " >> Report.txt
echo "Version:" >> Report.txt # NEEDS TO BE FILLED IN
echo "Compiler:" >> Report.txt # NEEDS TO BE FILLED IN
# Takes start and stop information located in Summary.txt 
grep -A8 'Pyxis Test' ./Summary.txt >> PerfSummary.txt
echo " " >> Report.txt
echo "Performance: " >> Report.txt # NEEDS TO BE FILLED IN
echo " " >> Report.txt
echo "#############################   GPS-Performance   #############################" >> Report.txt
echo " " >> Report.txt
echo "			Actual			Comp Yesterday		Comp 2 Weeks" >> Report.txt
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 26min x86 StaticSim ----------------------------------" >> Report.txt
echo " " >> Report.txt

max3dval=`awk 'NR == 1 {print $5  meters		 $9  meters		$11 meters}' /home/dlc257/Documents/resultOver_0_0.txt | sed 's/.*|//'`
echo "Max 3D Error:	$max3dval" >> Report.txt
mean3dval=`awk 'NR == 2 {print $4 " meters		" $6 " meters		" $8 " meters"}' /home/dlc257/Documents/resultOver_0_0.txt | sed 's/.*|//'`
echo "Mean 3D Error:	$mean3dval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min x86 Static -------------------------------------" >> Report.txt
echo " " >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min ARM Static -------------------------------------" >> Report.txt
echo " " >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 34hours x86 StaticLong -------------------------------" >> Report.txt
echo " " >> Report.txt

echo " " >> Report.txt
echo "- URSP-N210 Sampfreq:4e6 54min x86 Dynamic -------------------------------------" >> Report.txt
echo " " >> Report.txt



## Prints Completion Message
echo "#########################################################################" >> Report.txt
echo "###########   Performance Characteristics Summary Complete   ############" >> Report.txt
echo "#########################################################################" >> Report.txt

sleep 5m
