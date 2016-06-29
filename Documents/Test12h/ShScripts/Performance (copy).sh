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
echo "			Actual			Comp Yesterday		Comp 2 Weekend" >> Report.txt
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 26min x86 StaticSim ----------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' StaticSim/Plots/resultOver_0_0.txt
sed -i 's/"//g' StaticSim/Plots/resultOver_0_0.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticSim/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./StaticSim/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /StaticSim/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min x86 Static -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' Static/Plots/resultOver_0_0.txt
sed -i 's/"//g' Static/Plots/resultOver_0_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./Static/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./Static/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./Static/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min ARM Static -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' /6TB/nfsshare/nightly-results/resultOver_0_0.txt
sed -i 's/"//g' /6TB/nfsshare/nightly-results/resultOver_0_0.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' /6TB/nfsshare/nightly-results/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' /6TB/nfsshare/nightly-results/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /6TB/nfsshare/nightly-results/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 34hours x86 StaticLong -------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' StaticLong/Plots/resultOver_0_0.txt
sed -i 's/"//g' StaticLong/Plots/resultOver_0_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
echo "1859_518400" >> Report.txt
sed -i 's/|//g' StaticLong/Plots/resultOver_1859_518400.txt
sed -i 's/"//g' StaticLong/Plots/resultOver_1859_518400.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOver_1859_518400.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOver_1859_518400.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOver_1859_518400.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
echo "1860_0" >> Report.txt
sed -i 's/|//g' StaticLong/Plots/resultOver_1860_0.txt
sed -i 's/"//g' StaticLong/Plots/resultOver_1860_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOver_1860_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOver_1860_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOver_1860_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt

echo " " >> Report.txt
echo "- URSP-N210 Sampfreq:4e6 54min x86 Dynamic -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
echo "0_0" >> Report.txt
sed -i 's/|//g' Dynamic/Plots/resultOver_0_0.txt
sed -i 's/"//g' Dynamic/Plots/resultOver_0_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./Dynamic/Plots/resultOver_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters	", $5, " meters	", $7, " meters"}' ./Dynamic/Plots/resultOver_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./Dynamic/Plots/resultOver_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
echo " " >> Report.txt

echo " " >> Report.txt
echo "############################   Code-Performance   #############################" >> Report.txt

echo " " >> Report.txt
echo "--------------------------------   Run Times   --------------------------------" >> Report.txt
echo " " >> Report.txt
# NEEDS TO BE FILLED IN

echo -n "MAX2769 Sampfreq:6864e6 52min ARM Static:		" >> Report.txt
RunTime='awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {getline; print}' times.txt'
RTf=`../ShScripts/timeFormat.sh $RunTime`
RunTimeY='awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {getline; print}' ytimes.txt'
diffyRunTime=expr $RunTimeY - $RunTime
diffyRTf=`../ShScripts/timeFormat.sh $diffyRunTime`
echo -n "$RTf		$diffyRTf		" >> Report.txt
RunTimeW='awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {getline; print}' wtimes.txt'
diffwRunTime=expr $RunTimeW - $RunTime
diffwRTf=`../ShScripts/timeFormat.sh $diffwRunTime`
echo "$diffwRTf" >> Report.txt
echo " " >> Report.txt

echo -n "URSP-N210 Sampfreq:4e6 54min x86 Dynamic:		" >> Report.txt
RunTime='awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {getline; print}' times.txt'
RTf=`../ShScripts/timeFormat.sh $RunTime`
RunTimeY='awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {getline; print}' ytimes.txt'
diffyRunTime=expr $RunTimeY - $RunTime
diffyRTf=`../ShScripts/timeFormat.sh $diffyRunTime`
echo -n "$RTf		$diffyRTf		" >> Report.txt
RunTimeW='awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {getline; print}' wtimes.txt'
diffwRunTime=expr $RunTimeW - $RunTime
diffwRTf=`../ShScripts/timeFormat.sh $diffwRunTime`
echo "$diffwRTf" >> Report.txt
echo " " >> Report.txt

echo -n "MAX2769 Sampfreq:6864e6 52min Static:		" >> Report.txt
RunTime='awk '/MAX2769 Sampfreq:6864e6 52min Static/ {getline; print}' times.txt'
RTf=`../ShScripts/timeFormat.sh $RunTime`
RunTimeY='awk '/MAX2769 Sampfreq:6864e6 52min Static/ {getline; print}' ytimes.txt'
diffyRunTime=expr $RunTimeY - $RunTime
diffyRTf=`../ShScripts/timeFormat.sh $diffyRunTime`
echo -n "$RTf		$diffyRTf		" >> Report.txt
RunTimeW='awk '/MAX2769 Sampfreq:6864e6 52min Static/ {getline; print}' wtimes.txt'
diffwRunTime=expr $RunTimeW - $RunTime
diffwRTf=`../ShScripts/timeFormat.sh $diffwRunTime`
echo "$diffwRTf" >> Report.txt
echo " " >> Report.txt

echo -n "MAX2769 Sampfreq:6864e6 26min x86 StaticSim:		" >> Report.txt
RunTime='awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {getline; print}' times.txt'
RTf=`../ShScripts/timeFormat.sh $RunTime`
RunTimeY='awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {getline; print}' ytimes.txt'
diffyRunTime=expr $RunTimeY - $RunTime
diffyRTf=`../ShScripts/timeFormat.sh $diffyRunTime`
echo -n "$RTf		$diffyRTf		" >> Report.txt
RunTimeW='awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {getline; print}' wtimes.txt'
diffwRunTime=expr $RunTimeW - $RunTime
diffwRTf=`../ShScripts/timeFormat.sh $diffwRunTime`
echo "$diffwRTf" >> Report.txt
echo " " >> Report.txt

##### NEED STATIC LONG

echo " " >> Report.txt
echo "------------------------------   Deterministic   ------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Not deterministic tests are:" >> Report.txt
echo " " >> Report.txt
# Check if either rnx or apt are un-deterministic
if [ -s StaticSim/DetermStatSim.txt ]
	then 
	if [ -s StaticSim/DetermStatSim2.txt ]
		then
		if [ grep -q -i "apt" StaticSim/DetermStatSim2.txt ] && [ grep -q -i "rnx" StaticSim/DetermStatSim2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 26min x86 StaticSim	apt & rnx" >> Report.txt
		elif [ grep -q -i "apt" StaticSim/DetermStatSim2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 26min x86 StaticSim	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 26min x86 StaticSim	rnx" >> Report.txt
		fi
	fi
fi

if [ -s Static/DetermStat.txt ]
	then 
	if [ -s Static/DetermStat2.txt ]
		then
		if [ grep -q -i "apt" Static/DetermStat2.txt ] && [ grep -q -i "rnx" Static/DetermStat2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static	apt & rnx" >> Report.txt
		elif [ grep -q -i "apt" Static/DetermStat2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static	rnx" >> Report.txt
		fi
	fi
fi

if [ -s /6TB/nfsshare/nightly-results/DetermARM.txt ]
	then 
	if [ -s /6TB/nfsshare/nightly-results/DetermARM2.txt ]
		then
		if [ grep -q -i "apt" /6TB/nfsshare/nightly-results/DetermARM2.txt ] && [ grep -q -i "rnx" /6TB/nfsshare/nightly-results/DetermARM2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	apt & rnx" >> Report.txt
		elif [ grep -q -i "apt" /6TB/nfsshare/nightly-results/DetermARM2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	rnx" >> Report.txt
		fi
	fi
fi

if [ -s StaticLong/DetermStatL.txt ]
	then 
	if [ -s StaticLong/DetermStatL2.txt ]
		then
		if [ grep -q -i "apt" StaticLong/DetermStatL2.txt ] && [ grep -q -i "rnx" StaticLong/DetermStatL2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	apt & rnx" >> Report.txt
		elif [ grep -q -i "apt" StaticLong/DetermStat2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	rnx" >> Report.txt
		fi
	fi
fi

if [ -s Dynamic/DetermDyn.txt ]
	then 
	if [ -s Dynamic/DetermDyn2.txt ]
		then
		if [ grep -q -i "apt" Dynamic/DetermDyn2.txt ] && [ grep -q -i "rnx" Dynamic/DetermDyn2.txt ]
			then
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	apt & rnx" >> Report.txt
		elif [ grep -q -i "apt" Dynamic/DetermDyn2.txt ]
			then
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	apt" >> Report.txt
		else
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	rnx" >> Report.txt
		fi
	fi
fi

echo " " >> Report.txt
echo "------------------------------   GCC Warnings   -------------------------------" >> Report.txt
echo " " >> Report.txt

echo " Files with GCC warnings:" >> Report.txt
echo "" >> Report.txt
grep "warning:" Static/stderr.txt > Static/Wwarning.txt
if [ -s Static/Wwarning.txt ]
	then
	echo "	MAX2769 Sampfreq:6864e6 52min x86 Static" >> Report.txt
fi

grep "warning:" /6TB/nfsshare/nightly-results/stderr.txt > /6TB/nfsshare/nightly-results/Wwarning.txt
if [ -s Static/Wwarning.txt ]
	then
	echo "	MAX2769 Sampfreq:6864e6 52min ARM Static" >> Report.txt
fi

grep "warning:" Dynamic/stderr.txt > Dynamic/Wwarning.txt
if [ -s Dynamic/Wwarning.txt ]
	then
	echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic" >> Report.txt
fi

echo " " >> Report.txt
echo "---------------------------------   Valgrind   --------------------------------" >> Report.txt
echo " " >> Report.txt
# NEEDS TO BE FILLED IN
echo " " >> Report.txt
## Prints Completion Message
echo "###########   Performance Characteristics Summary Complete   ############" >> Report.txt

sleep 5s
