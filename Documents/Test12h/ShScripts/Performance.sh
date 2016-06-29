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
sed -i 's/|/ /g' Dynamic/Plots/resultOverV_0_0.txt
sed -i 's/"/ /g' Dynamic/Plots/resultOverV_0_0.txt 
Version=`awk '/Version/ {print $2,$3,$4}' ./Dynamic/Plots/resultOverV_0_0.txt`
Compiler=`awk '/Compiler/ {print $6,$7,$8}' ./Dynamic/Plots/resultOverV_0_0.txt`
echo -n "Version: " >> Report.txt 
echo "$Version" >> Report.txt
echo -n "Compiler: " >> Report.txt
echo "$Compiler" >> Report.txt
# Takes start and stop information located in Summary.txt 
grep -A8 'Pyxis Test' Summary.txt >> PerfSummary.txt
echo " " >> Report.txt
rm Summary.txt
echo "Performance: " >> Report.txt # NEEDS TO BE FILLED IN



echo " " >> Report.txt
echo "#############################   GPS-Performance   #############################" >> Report.txt
echo " " >> Report.txt
echo "			Actual			Comp Yesterday		Comp 2 Weekend" >> Report.txt
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
echo " " >> Report.txt



echo " " >> Report.txt
echo "############################   Code-Performance   #############################" >> Report.txt
echo " " >> Report.txt
echo "--------------------------------   Run Times   --------------------------------" >> Report.txt
echo " " >> Report.txt
echo "						Actual	Comp Yesterday	Comp Last Week" >> Report.txt
## CODE PERFORMANCE STATICSIM
echo -n "MAX2769 Sampfreq:6864e6 26min x86 StaticSim:	" >> Report.txt
RunTime4=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' times.txt`
RTf4=`../ShScripts/timeFormat.sh $RunTime4`
RunTimeY4=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' ytimes.txt`
diffyRunTime4=`expr $RunTimeY4 - $RunTime4`
diffyRTf4=`../ShScripts/timeFormat.sh $diffyRunTime4`
echo -n "$RTf4	$diffyRTf4      " >> Report.txt
RunTimeW4=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' wtimes.txt`
diffwRunTime4=`expr $RunTimeW4 - $RunTime4`
diffwRTf4=`../ShScripts/timeFormat.sh $diffwRunTime4`
echo "$diffwRTf4" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE STATIC
echo -n "MAX2769 Sampfreq:6864e6 52min Static:		" >> Report.txt
RunTime3=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' times.txt`
RTf3=`../ShScripts/timeFormat.sh $RunTime3`
RunTimeY3=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' ytimes.txt`
diffyRunTime3=`expr $RunTimeY3 - $RunTime3`
diffyRTf3=`../ShScripts/timeFormat.sh $diffyRunTime3`
echo -n "$RTf3	$diffyRTf3      " >> Report.txt
RunTimeW3=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' wtimes.txt`
diffwRunTime3=`expr $RunTimeW3 - $RunTime3`
diffwRTf3=`../ShScripts/timeFormat.sh $diffwRunTime3`
echo "$diffwRTf3" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE ARM STATIC
echo -n "MAX2769 Sampfreq:6864e6 52min ARM Static:	" >> Report.txt
RunTime1=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' times.txt`
RTf1=`../ShScripts/timeFormat.sh $RunTime1`
RunTimeY1=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' ytimes.txt`
diffyRunTime1=`expr $RunTimeY1 - $RunTime1`
diffyRTf1=`../ShScripts/timeFormat.sh $diffyRunTime1`
echo -n "$RTf1	$diffyRTf1      " >> Report.txt
RunTimeW1=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' wtimes.txt`
diffwRunTime1=`expr $RunTimeW1 - $RunTime1`
diffwRTf1=`../ShScripts/timeFormat.sh $diffwRunTime1`
echo "$diffwRTf1" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE STATICLONG
echo -n "MAX2769 Sampfreq:6864e6 34hours x86 StaticLong:	" >> Report.txt
RunTime5=`awk '/MAX2769 Sampfreq:6864e6 34hours x86 StaticLong/ {print $6}' times.txt`
RTf5=`../ShScripts/timeFormat.sh $RunTime5`
RunTimeY5=`awk '/MAX2769 Sampfreq:6864e6 34hours x86 StaticLong/ {print $6}' ytimes.txt`
diffyRunTime5=`expr $RunTimeY5 - $RunTime5`
diffyRTf5=`../ShScripts/timeFormat.sh $diffyRunTime1`
echo -n "$RTf5	$diffyRTf5      " >> Report.txt
RunTimeW5=`awk '/MAX2769 Sampfreq:6864e6 34hours x86 StaticLong/ {print $6}' wtimes.txt`
diffwRunTime5=`expr $RunTimeW5 - $RunTime5`
diffwRTf5=`../ShScripts/timeFormat.sh $diffwRunTime5`
echo "$diffwRTf5" >> Report.txt
echo " " >> Report.txt
## CODE PERFORMANCE DYNAMIC
echo -n "URSP-N210 Sampfreq:4e6 54min x86 Dynamic:	" >> Report.txt
RunTime2=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' times.txt`
RTf2=`../ShScripts/timeFormat.sh $RunTime2`
RunTimeY2=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' ytimes.txt`
diffyRunTime2=`expr $RunTimeY2 - $RunTime2`
diffyRTf2=`../ShScripts/timeFormat.sh $diffyRunTime2`
echo -n "$RTf2	$diffyRTf2      " >> Report.txt
RunTimeW2=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' wtimes.txt`
diffwRunTime2=`expr $RunTimeW2 - $RunTime2`
diffwRTf2=`../ShScripts/timeFormat.sh $diffwRunTime2`
echo "$diffwRTf2" >> Report.txt
echo " " >> Report.txt
##### NEED STATIC LONG



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
## DETERMINISTIC ARM STATIC
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
## DETERMINISTIC STATICLONG
if [ -s StaticLong/DetermStatL.txt ]
	then 
	if [ -s StaticLong/DetermStatL2.txt ]
		then
		if [ grep -q -i "apt" StaticLong/DetermStatL2.txt ] && [ grep -q -i "rnx" StaticLong/DetermStatL2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	apt & rnx" >> Report.txt
		elif [ grep -q -i "apt" StaticLong/DetermStatL2.txt ]
			then
			echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 34hours x86 StaticLong	rnx" >> Report.txt
		fi
	fi
fi
## DETERMINISTIC DYNAMIC
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
if [ -s /6TB/nfsshare/nightly-results/Wwarning.txt ]
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
echo "Files with leaks or other Valgrind warnings:" >> Report.txt
echo " " >> Report.txt
## VALGRIND STATIC
FileDes1=`awk '/FILE DESCRIPTORS/ {print $4}' Static/valwar.txt`
if [ grep -q -i "LEAK SUMMARY" Static/valwar.txt ] || [ $FileDes1 -ne 4 ]
	then
	echo "MAX2769 Sampfreq:6864e6 52min Static" >> Report.txt
fi
## VALGRIND DYNAMIC
FileDes2=`awk '/FILE DESCRIPTORS/ {print $4}' Dynamic/valwar.txt`
if [ grep -q -i "LEAK SUMMARY" Dynamic/valwar.txt ] || [ $FileDes2 -ne 4 ]
	then
	echo "URSP-N210 Sampfreq:4e6 54min x86 Dynamic" >> Report.txt
fi



echo " " >> Report.txt
## Prints Completion Message
echo "########################   Short Weekend Report End   #########################" >> Report.txt

sleep 5s
