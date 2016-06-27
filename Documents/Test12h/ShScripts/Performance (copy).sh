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

sed -i 's/|//g' StaticSim/Plots/resultOver_0_0.txt
sed -i 's/"//g' StaticSim/Plots/resultOver_0_0.txt 
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticSim/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./StaticSim/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /StaticSim/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min x86 Static -------------------------------------" >> Report.txt
echo " " >> Report.txt

sed -i 's/|//g' Static/Plots/resultOver_0_0.txt
sed -i 's/"//g' Static/Plots/resultOver_0_0.txt 
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./Static/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./Static/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./Static/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min ARM Static -------------------------------------" >> Report.txt
echo " " >> Report.txt

sed -i 's/|//g' /6TB/nfsshare/nightly-results/resultOver_0_0.txt
sed -i 's/"//g' /6TB/nfsshare/nightly-results/resultOver_0_0.txt 
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' /6TB/nfsshare/nightly-results/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' /6TB/nfsshare/nightly-results/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /6TB/nfsshare/nightly-results/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 34hours x86 StaticLong -------------------------------" >> Report.txt
echo " " >> Report.txt

sed -i 's/|//g' StaticLong/Plots/resultOver_0_0.txt
sed -i 's/"//g' StaticLong/Plots/resultOver_0_0.txt 
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- URSP-N210 Sampfreq:4e6 54min x86 Dynamic -------------------------------------" >> Report.txt
echo " " >> Report.txt

sed -i 's/|//g' Dynamic/Plots/resultOver_0_0.txt
sed -i 's/"//g' Dynamic/Plots/resultOver_0_0.txt 
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./Dynamic/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./Dynamic/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./Dynamic/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

## Prints Completion Message
echo "#########################################################################" >> Report.txt
echo "###########   Performance Characteristics Summary Complete   ############" >> Report.txt
echo "#########################################################################" >> Report.txt

sleep 5s
