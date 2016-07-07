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
echo "###########################   Small OverNight Report   ##########################" > Report.txt
echo " " >> Report.txt
sed -i 's/|/ /g' Dynamic/Plots/resultOverV_0_0.txt
sed -i 's/"/ /g' Dynamic/Plots/resultOverV_0_0.txt 
Version=`awk '/Version/ {print $2,$3,$4}' ./Dynamic/Plots/resultOverV_0_0.txt`
Compiler=`awk '/Compiler/ {print $6,$7,$8}' ./Dynamic/Plots/resultOverV_0_0.txt`
echo -n "Version: " >> Report.txt 
echo "$Version" >> Report.txt
echo -n "Compiler: " >> Report.txt
echo "$Compiler" >> Report.txt
echo -n "Date: " >> Report.txt
date >> Report.txt
echo " " >> Report.txt
# Takes start and stop information located in Summary.txt 
grep -A8 'Pyxis Test' Summary.txt >> Report.txt
echo " " >> Report.txt
rm Summary.txt
echo "Run Performance: " >> Report.txt
echo " " >> Report.txt
echo "MAX2769 Sampfreq-6864e6 26min x86 StaticSim:	" >> Report.txt
echo "MAX2769 Sampfreq-6864e6 52min Static:		" >> Report.txt
echo "MAX2769 Sampfreq-6864e6 52min ARM Static:		" >> Report.txt
echo "MAX2769 Sampfreq-6864e6 34hours x86 StaticLong:	" >> Report.txt
echo "URSP-N210 Sampfreq-4e6 54min x86 Dynamic:		" >> Report.txt

echo " " >> Report.txt
echo "#############################   GPS-Performance   #############################" >> Report.txt
echo " " >> Report.txt
echo "			Actual			 Comp Yesterday		 Comp Last Week" >> Report.txt
## GPS PERFORMANCE STATICSIM
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 26min x86 StaticSim ----------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' StaticSim/Plots/resultOverV_0_0.txt
sed -i 's/"//g' StaticSim/Plots/resultOverV_0_0.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticSim/Plots/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./StaticSim/Plots/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /StaticSim/Plots/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY1=`awk '/Mean 3D/ {print $5}' ./StaticSim/Plots/resultOverV_0_0.txt`
availabilityvalY1=`awk '/Availability/ {print $4}' /StaticSim/Plots/resultOverV_0_0.txt`
PerfMess1=`../ShScripts/PerfCmp.sh $mean3dvalY1 $availabilityvalY1`
sed -i "/MAX2769 Sampfreq-6864e6 26min x86 StaticSim:/c\MAX2769 Sampfreq-6864e6 26min x86 StaticSim:		$PerfMess1" Report.txt

## GPS PERFORMANCE STATIC
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min x86 Static -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' Static/Plots/resultOverV_0_0.txt
sed -i 's/"//g' Static/Plots/resultOverV_0_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./Static/Plots/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./Static/Plots/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./Static/Plots/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY2=`awk '/Mean 3D/ {print $5}' ./Static/Plots/resultOverV_0_0.txt`
availabilityvalY2=`awk '/Availability/ {print $4}' ./Static/Plots/resultOverV_0_0.txt`
PerfMess2=`../ShScripts/PerfCmp.sh $mean3dvalY2 $availabilityvalY2`
sed -i "/MAX2769 Sampfreq-6864e6 52min Static:/c\MAX2769 Sampfreq-6864e6 52min Static:			$PerfMess2" Report.txt

## GPS PERFORMANCE ARM STATIC
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min ARM Static -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt
sed -i 's/"//g' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY3=`awk '/Mean 3D/ {print $5}' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt`
availabilityvalY3=`awk '/Availability/ {print $4}' /6TB/nfsshare/nightly-results/resultOverV_0_0.txt`
PerfMess3=`../ShScripts/PerfCmp.sh $mean3dvalY3 $availabilityvalY3`
sed -i "/MAX2769 Sampfreq-6864e6 52min ARM Static:/c\MAX2769 Sampfreq-6864e6 52min ARM Static:		$PerfMess3" Report.txt

## GPS PERFORMANCE STATICLONG
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 34hours x86 StaticLong -------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
echo "0_0" >> Report.txt
sed -i 's/|//g' StaticLong/Plots/resultOverV_0_0.txt
sed -i 's/"//g' StaticLong/Plots/resultOverV_0_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY4a=`awk '/Mean 3D/ {print $5}' ./StaticLong/Plots/resultOverV_0_0.txt`
availabilityvalY4a=`awk '/Availability/ {print $4}' ./StaticLong/Plots/resultOverV_0_0.txt`
PerfMess4a=`../ShScripts/PerfCmp.sh $mean3dvalY4a $availabilityvalY4a`

## STATIC LONG CONTINUED 1859_518400
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
echo "1859_518400" >> Report.txt
sed -i 's/|//g' StaticLong/Plots/resultOverV_1859_518400.txt
sed -i 's/"//g' StaticLong/Plots/resultOverV_1859_518400.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOverV_1859_518400.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOverV_1859_518400.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOverV_1859_518400.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY4b=`awk '/Mean 3D/ {print $5}' ./StaticLong/Plots/resultOverV_1859_518400.txt`
availabilityvalY4b=`awk '/Availability/ {print $4}' ./StaticLong/Plots/resultOverV_1859_518400.txt`
PerfMess4b=`../ShScripts/PerfCmp.sh $mean3dvalY4b $availabilityvalY4b`

## STATIC LONG CONTINUED 1860_0
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
echo "1860_0" >> Report.txt
sed -i 's/|//g' StaticLong/Plots/resultOverV_1860_0.txt
sed -i 's/"//g' StaticLong/Plots/resultOverV_1860_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./StaticLong/Plots/resultOverV_1860_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./StaticLong/Plots/resultOverV_1860_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOverV_1860_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY4c=`awk '/Mean 3D/ {print $5}' ./StaticLong/Plots/resultOverV_1860_0.txt`
availabilityvalY4c=`awk '/Availability/ {print $4}' ./StaticLong/Plots/resultOverV_1860_0.txt`
PerfMess4c=`../ShScripts/PerfCmp.sh $mean3dvalY4c $availabilityvalY4c`
if [ "$PerfMess4a" == "Test Not Run" ]
	then
	#echo "Hi"
	PerfMess4b=" "
	PerfMess4c=" "
fi
sed -i "/MAX2769 Sampfreq-6864e6 34hours x86 StaticLong:/c\MAX2769 Sampfreq-6864e6 34hours x86 StaticLong:		$PerfMess4a $PerfMess4b $PerfMess4c" Report.txt

## GPS PERFORMANCE DYNAMIC
echo " " >> Report.txt
echo "- URSP-N210 Sampfreq:4e6 54min x86 Dynamic -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' Dynamic/Plots/resultOverV_0_0.txt
sed -i 's/"//g' Dynamic/Plots/resultOverV_0_0.txt
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' ./Dynamic/Plots/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./Dynamic/Plots/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./Dynamic/Plots/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY5=`awk '/Mean 3D/ {print $5}' ./Dynamic/Plots/resultOverV_0_0.txt`
availabilityvalY5=`awk '/Availability/ {print $4}' ./Dynamic/Plots/resultOverV_0_0.txt`
PerfMess5=`../ShScripts/PerfCmp.sh $mean3dvalY5 $availabilityvalY5`
sed -i "/URSP-N210 Sampfreq-4e6 54min x86 Dynamic:/c\URSP-N210 Sampfreq-4e6 54min x86 Dynamic:		$PerfMess5" Report.txt
echo " " >> Report.txt

# Change yestedays results for todays results
mv StaticSim/Plots/results_0_0.txt StaticSim/Plots/ResY.txt
mv Static/Plots/results_0_0.txt Static/Plots/ResY.txt
mv /6TB/nfsshare/nightly-results/Plots/results_0_0.txt /6TB/nfsshare/nightly-results/Plots/ResY.txt
mv StaticLong/Plots/results_0_0.bin StaticLong/Plots/ResY1.txt
mv StaticLong/Plots/results_1859_518400.bin StaticLong/Plots/ResY2.txt
mv StaticLong/Plots/results_1860_0.bin StaticLong/Plots/ResY3.txt
mv Dynamic/Plots/results_0_0.txt Dynamic/Plots/ResY.txt



echo " " >> Report.txt
echo "############################   Code-Performance   #############################" >> Report.txt
echo " " >> Report.txt
echo "--------------------------------   Run Times   --------------------------------" >> Report.txt
echo " " >> Report.txt
echo "						Actual	 Comp Yesterday	 Comp Last Week" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE STATICSIM
echo -n "MAX2769 Sampfreq:6864e6 26min x86 StaticSim:	" >> Report.txt
RunTime4=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' times.txt`
RTf4=`../ShScripts/timeFormat.sh $RunTime4`
RunTimeY4=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' ytimes.txt`
diffyRunTime4=`expr $RunTime4 - $RunTimeY4`
diffyRTf4=`../ShScripts/timeFormat.sh $diffyRunTime4`
echo -n "$RTf4      $diffyRTf4      " >> Report.txt
RunTimeW4=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' wtimes.txt`
diffwRunTime4=`expr $RunTime4 - $RunTimeW4`
diffwRTf4=`../ShScripts/timeFormat.sh $diffwRunTime4`
echo "$diffwRTf4" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE STATIC
echo -n "MAX2769 Sampfreq:6864e6 52min Static:		" >> Report.txt
RunTime3=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' times.txt`
RTf3=`../ShScripts/timeFormat.sh $RunTime3`
RunTimeY3=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' ytimes.txt`
diffyRunTime3=`expr $RunTime3 - $RunTimeY3`
diffyRTf3=`../ShScripts/timeFormat.sh $diffyRunTime3`
echo -n "$RTf3      $diffyRTf3      " >> Report.txt
RunTimeW3=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' wtimes.txt`
diffwRunTime3=`expr $RunTime3 - $RunTimeW3`
diffwRTf3=`../ShScripts/timeFormat.sh $diffwRunTime3`
echo "$diffwRTf3" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE ARM STATIC
echo -n "MAX2769 Sampfreq:6864e6 52min ARM Static:	" >> Report.txt
RunTime1=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' times.txt`
RTf1=`../ShScripts/timeFormat.sh $RunTime1`
RunTimeY1=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' ytimes.txt`
diffyRunTime1=`expr $RunTime1 - $RunTimeY1`
diffyRTf1=`../ShScripts/timeFormat.sh $diffyRunTime1`
echo -n "$RTf1      $diffyRTf1      " >> Report.txt
RunTimeW1=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' wtimes.txt`
diffwRunTime1=`expr $RunTime1 - $RunTimeW1`
diffwRTf1=`../ShScripts/timeFormat.sh $diffwRunTime1`
echo "$diffwRTf1" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE STATICLONG
echo -n "MAX2769 Sampfreq:6864e6 34hours x86 StaticLong:	" >> Report.txt
RunTime5=`awk '/MAX2769 Sampfreq:6864e6 34hours x86 StaticLong/ {print $6}' times.txt`
RTf5=`../ShScripts/timeFormat.sh $RunTime5`
RunTimeY5=`awk '/MAX2769 Sampfreq:6864e6 34hours x86 StaticLong/ {print $6}' ytimes.txt`
diffyRunTime5=`expr $RunTime5 - $RunTimeY5`
diffyRTf5=`../ShScripts/timeFormat.sh $diffyRunTime1`
echo -n "$RTf5      $diffyRTf5      " >> Report.txt
RunTimeW5=`awk '/MAX2769 Sampfreq:6864e6 34hours x86 StaticLong/ {print $6}' wtimes.txt`
diffwRunTime5=`expr $RunTime5 - $RunTimeW5`
diffwRTf5=`../ShScripts/timeFormat.sh $diffwRunTime5`
echo "$diffwRTf5" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE DYNAMIC
echo -n "URSP-N210 Sampfreq:4e6 54min x86 Dynamic:	" >> Report.txt
RunTime2=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' times.txt`
RTf2=`../ShScripts/timeFormat.sh $RunTime2`
RunTimeY2=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' ytimes.txt`
diffyRunTime2=`expr $RunTime2 - $RunTimeY2`
diffyRTf2=`../ShScripts/timeFormat.sh $diffyRunTime2`
echo -n "$RTf2      $diffyRTf2      " >> Report.txt
RunTimeW2=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' wtimes.txt`
diffwRunTime2=`expr $RunTime2 - $RunTimeW2`
diffwRTf2=`../ShScripts/timeFormat.sh $diffwRunTime2`
echo "$diffwRTf2" >> Report.txt
echo " " >> Report.txt
# Move current times.txt and make it new ytimes.txt
mv times.txt ytimes.txt



echo " " >> Report.txt
echo "------------------------------   Deterministic   ------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Not deterministic tests are:" >> Report.txt
echo " " >> Report.txt
# Check if either rnx or apt are un-deterministic
## DETERMINISTIC STATIC
if [ -s Static/DetermStat.txt ]
	then 
	if [ -s Static/DetermStat2.txt ]
		then
		if [ "$(grep -i 'apt' Static/DetermStat2.txt)" == "apt" ] && [ "$(grep -i 'rnx' Static/DetermStat2.txt)" == "rnx" ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static	apt & rnx" >> Report.txt
		elif [ "$(grep -i 'apt' Static/DetermStat2.txt)" == "apt" ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static	rnx" >> Report.txt
		fi
		echo "error" > error.txt
	fi
fi
## DETERMINISTIC ARM STATIC
if [ -s /6TB/nfsshare/nightly-results/DetermARM.txt ]
	then 
	if [ "$(grep -i 'apt' /6TB/nfsshare/nightly-results/DetermARM2.txt)" == "apt" ] && [ "$(grep -i 'rnx' /6TB/nfsshare/nightly-results/DetermARM2.txt)" == "rnx" ]
		then
		echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	apt & rnx" >> Report.txt
	elif [ "$(grep -i 'apt' /6TB/nfsshare/nightly-results/DetermARM2.txt)" == "apt" ]
		then
		echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	apt" >> Report.txt
	else
		echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	rnx" >> Report.txt
	fi
	echo "error" > error.txt
fi
## DETERMINISTIC STATICLONG
if [ -s StaticLong/DetermStatL.txt ]
	then
	if [ "$(grep -i 'apt' StaticLong/DetermStatL.txt)" == "apt" ] && [ "$(grep -i 'rnx' StaticLong/DetermStatL.txt)" == "rnx" ]
		then
		echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	apt & rnx" >> Report.txt
	elif [ "$(grep -i 'apt' StaticLong/DetermStatL.txt)" == "apt" ]
		then
		echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	apt" >> Report.txt
	else
		echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	rnx" >> Report.txt
	fi
	echo "error" > error.txt
fi
## DETERMINISTIC DYNAMIC
if [ -s Dynamic/DetermDyn.txt ]
	then 
	if [ -s Dynamic/DetermDyn2.txt ]
		then
		if [ "$(grep -i 'apt' Dynamic/DetermDyn2.txt)" == "apt" ] && [ "$(grep -i 'rnx' Dynamic/DetermDyn2.txt)" == "rnx" ]
			then
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	apt & rnx" >> Report.txt
		elif [ "$(grep -i 'apt' Dynamic/DetermDyn2.txt)" == "apt" ]
			then
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	apt" >> Report.txt
		else
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	rnx" >> Report.txt
		fi
		echo "error" > error.txt
	fi
fi



echo " " >> Report.txt
echo "------------------------------   GCC Warnings   -------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Files with GCC warnings:" >> Report.txt
echo " " >> Report.txt
## GCC WARNINGS STATICSIM
if tail StaticSim/screenout.txt | grep -q -i "Segmentation Fault";
	then 
	echo "	MAX2769 Sampfreq:6864e6 26min x86 StaticSim	Segmentation Fault" >> Report.txt
	echo "error" > error.txt
fi
## GCC WARNINGS STATIC
grep "warning:" Static/stderr.txt > Static/Wwarning.txt
if [ -s Static/Wwarning.txt ] || tail Static/screenout.txt | grep -q -i "Segmentation Fault";
	then
	if tail Static/screenout.txt | grep -q -i "Segmentation Fault";
		then
		echo " MAX2769 Sampfreq:6864e6 52min x86 Static		Segmentation Fault" >> Report.txt
	else
		echo "	MAX2769 Sampfreq:6864e6 52min x86 Static" >> Report.txt
	fi
	echo "error" > error.txt
fi
## GCC WARNINGS STATIC ARM
grep "warning:" /6TB/nfsshare/nightly-results/stderr.txt > /6TB/nfsshare/nightly-results/Wwarning.txt
if [ -s /6TB/nfsshare/nightly-results/Wwarning.txt ] || tail /6TB/nfsshare/nightly-results/screenout.txt | grep -q -i "Segmentation Fault";
	then
	if tail /6TB/nfsshare/nightly-results/screenout.txt | grep -q -i "Segmentation Fault";
		then
		echo "	MAX2769 Sampfreq:6864e6 52min ARM Static	Segmentation Fault" >> Report.txt
	else
		echo "	MAX2769 Sampfreq:6864e6 52min ARM Static" >> Report.txt
	fi
	echo "error" > error.txt
fi
## GCC WARNINGS STATICLONG
if tail StaticLong/screenout.txt | grep -q -i "Segmentation Fault";
	then 
	echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	Segmentation Fault" >> Report.txt
	echo "error" > error.txt
fi
## GCC WARNINGS DYNAMIC
grep "warning:" Dynamic/stderr.txt > Dynamic/Wwarning.txt
if [ -s Dynamic/Wwarning.txt ] || tail Dynamic/screenout.txt | grep -i -q "Segmentation Fault";
	then
	if tail Dynamic/screenout.txt | grep -q -i "Segmentation Fault";
		then
		echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic	Segmentation Fault" >> Report.txt
	else
		echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic" >> Report.txt
	fi
	echo "error" > error.txt
fi



echo " " >> Report.txt
echo "---------------------------------   Valgrind   --------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Files with leaks or other Valgrind warnings:" >> Report.txt
echo " " >> Report.txt
## VALGRIND STATIC
FileDes1=`awk '/FILE DESCRIPTORS/ {print $4}' Static/valwar.txt`
if [ $FileDes1 -ne 4 ] || grep -q -i "LEAK SUMMARY" Static/valwar.txt
	then
	echo " MAX2769 Sampfreq:6864e6 52min Static" >> Report.txt
	echo "error" > error.txt
fi
## VALGRIND DYNAMIC
FileDes2=`awk '/FILE DESCRIPTORS/ {print $4}' Dynamic/valwar.txt`
if [ $FileDes2 -ne 4 ] || grep -q -i "LEAK SUMMARY" Dynamic/valwar.txt;
	then
	echo " URSP-N210 Sampfreq:4e6 54min x86 Dynamic" >> Report.txt
	echo "error" > error.txt
fi

if [ -s error.txt ]
	then
	sed -i "/Run Performance:/c\Run Performance: Errors!" Report.txt
else
	sed -i "/Run Performance:/c\Run Performance: No Errors." Report.txt
fi

echo " " >> Report.txt
## Prints Completion Message
echo "########################   Short OverNight Report End   #########################" >> Report.txt

sleep 2s
