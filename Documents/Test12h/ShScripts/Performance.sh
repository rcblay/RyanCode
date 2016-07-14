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

## Input name change

Teststart=$1

################################### Test Characteristics Summary ##################################
cd ../output
echo "###########################   Small OverNight Report   ##########################" > Report.txt
echo " " >> Report.txt
sed -i 's/|/ /g' Dynamic/Plots/resultOverV_0_0.txt
sed -i 's/"/ /g' Dynamic/Plots/resultOverV_0_0.txt 
Version=`awk '/Version/ {print $2,$3,$4}' ./Dynamic/Plots/resultOverV_0_0.txt`
Compiler=`awk '/Compiler/ {print $6,$7,$8}' ./Dynamic/Plots/resultOverV_0_0.txt`
CompilerARM=`awk '/Compiler/ {print $6,$7,$8}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
echo -n "Version: " >> Report.txt 
echo "$Version" >> Report.txt
echo -n "Compiler: " >> Report.txt
echo "$Compiler" >> Report.txt
echo -n "ARM Compiler: " >> Report.txt
echo "$CompilerARM" >> Report.txt
echo " " >> Report.txt

# Takes start and stop information 
echo -n "Test started: " >> Report.txt
date -d @$Teststart >> Report.txt
Testend=$(date +%s)

echo -n "Test ended: " >> Report.txt
date -d @$Testend >> Report.txt

diffT=`expr $Testend - $Teststart`
echo -n "Duration: " >> Report.txt
#echo `../ShScripts/timeFormat.sh $diffT` >> Report.txt
date -d @`expr $diffT + 25200` +%T >> Report.txt # adds seven hour to first epoch to express difference in time. Only works when below 24 hours
rm Summary.txt # needed?

echo " " >> Report.txt
echo "############################   Code-Performance   #############################" >> Report.txt
echo " " >> Report.txt
echo " Run Performance: " >> Report.txt
echo " " >> Report.txt

######################################### Deterministic ############################################
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
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static (V)	apt & rnx" >> Report.txt
		elif [ "$(grep -i 'apt' Static/DetermStat2.txt)" == "apt" ]
			then
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static (V)	apt" >> Report.txt
		else
			echo "	MAX2769 Sampfreq:6864e6 52min x86 Static (V)	rnx" >> Report.txt
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
		echo "	MAX2769 Sampfreq:6864e6 24hours x86 StaticLong	apt & rnx" >> Report.txt
	elif [ "$(grep -i 'apt' StaticLong/DetermStatL.txt)" == "apt" ]
		then
		echo "	MAX2769 Sampfreq:6864e6 24hours x86 StaticLong	apt" >> Report.txt
	else
		echo "	MAX2769 Sampfreq:6864e6 24hours x86 StaticLong	rnx" >> Report.txt
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
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V)	apt & rnx" >> Report.txt
		elif [ "$(grep -i 'apt' Dynamic/DetermDyn2.txt)" == "apt" ]
			then
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V)	apt" >> Report.txt
		else
			echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V)	rnx" >> Report.txt
		fi
		echo "error" > error.txt
	fi
fi


######################################## GCC Warnings ##############################################
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
		echo " MAX2769 Sampfreq:6864e6 52min x86 Static (V)		Segmentation Fault" >> Report.txt
	else
		echo "	MAX2769 Sampfreq:6864e6 52min x86 Static (V)" >> Report.txt
	fi
	echo "error" > error.txt
fi

## GCC WARNINGS STATIC ARM
grep "warning:" /6TB/nfsshare/nightly-results/stderr.txt > /6TB/nfsshare/nightly-results/Wwarning.txt
if [ -s /6TB/nfsshare/nightly-results/Wwarning.txt ] || tail /6TB/nfsshare/screenout.txt | grep -q -i "Segmentation Fault";
	then
	if tail /6TB/nfsshare/screenout.txt | grep -q -i "Segmentation Fault";
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
	echo "	MAX2769 Sampfreq:6864e6 24hours x86 StaticLong	Segmentation Fault" >> Report.txt
	echo "error" > error.txt
fi

## GCC WARNINGS DYNAMIC
grep "warning:" Dynamic/stderr.txt > Dynamic/Wwarning.txt
if [ -s Dynamic/Wwarning.txt ] || tail Dynamic/screenout.txt | grep -i -q "Segmentation Fault";
	then
	if tail Dynamic/screenout.txt | grep -q -i "Segmentation Fault";
		then
		echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V)	Segmentation Fault" >> Report.txt
	else
		echo "	URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V)" >> Report.txt
	fi
	echo "error" > error.txt
fi


########################################## Valgrind ##############################################
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

####################################### Output files ############################################

echo " " >> Report.txt
echo "-------------------------------   Output files   ------------------------------" >> Report.txt
echo " " >> Report.txt

echo "MAX2769 Sampfreq-6864e6 26min x86 StaticSim:	" >> Report.txt
echo "MAX2769 Sampfreq-6864e6 52min Static (V):		" >> Report.txt
echo "MAX2769 Sampfreq-6864e6 52min ARM Static:		" >> Report.txt
echo "MAX2769 Sampfreq-6864e6 24hours x86 StaticLong:	" >> Report.txt
echo "URSP-N210 Sampfreq-4e6 54min x86 Dynamic (V):	" >> Report.txt


##################################### GPS Performance ####################################
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
max3dval=`awk '/Max 3D Error/ {print $4, " meters		", $8, " meters	", $10, " meters"}' ./StaticSim/Plots/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' ./StaticSim/Plots/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' ./StaticSim/Plots/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY1=`awk '/Mean 3D/ {print $5}' ./StaticSim/Plots/resultOverV_0_0.txt`
availabilityvalY1=`awk '/Availability/ {print $4}' ./StaticSim/Plots/resultOverV_0_0.txt`
PerfMess1=`../ShScripts/PerfCmp.sh $mean3dvalY1 $availabilityvalY1`
sed -i "/MAX2769 Sampfreq-6864e6 26min x86 StaticSim:/c\MAX2769 Sampfreq-6864e6 26min x86 StaticSim:		$PerfMess1" Report.txt

## GPS PERFORMANCE STATIC
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min x86 Static (V) ---------------------------------" >> Report.txt
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
sed -i "/MAX2769 Sampfreq-6864e6 52min Static (V):/c\MAX2769 Sampfreq-6864e6 52min Static (V):		$PerfMess2" Report.txt

## GPS PERFORMANCE ARM STATIC
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 52min ARM Static -------------------------------------" >> Report.txt
echo " " >> Report.txt
# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|/ /g' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt
sed -i 's/"/ /g' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt 
# Extracts the values needed and prints them to the report
max3dval=`awk '/Max 3D Error/ {print $4, " meters	", $8, " meters	", $10, " meters"}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
echo "Max 3D Error:		$max3dval" >> Report.txt
mean3dval=`awk '/Mean 3D/ {print $3, " meters		", $5, " meters	", $7, " meters"}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
echo "Mean 3D Error:		$mean3dval" >> Report.txt
availabilityval=`awk '/Availability/ {print $2, " %			", $4, " %			", $6, " %"}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY3=`awk '/Mean 3D/ {print $5}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
availabilityvalY3=`awk '/Availability/ {print $4}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
PerfMess3=`../ShScripts/PerfCmp.sh $mean3dvalY3 $availabilityvalY3`
sed -i "/MAX2769 Sampfreq-6864e6 52min ARM Static:/c\MAX2769 Sampfreq-6864e6 52min ARM Static:		$PerfMess3" Report.txt

## GPS PERFORMANCE STATICLONG
echo " " >> Report.txt
echo "- MAX2769 Sampfreq:6864e6 24hours x86 StaticLong -------------------------------" >> Report.txt
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
availabilityval=`awk '/Availability/ {print $2, " %		", $4, " %			", $6, " %"}' ./StaticLong/Plots/resultOverV_1860_0.txt`
echo "Availability:       	$availabilityval" >> Report.txt
# Checks Performance using yesterday's results
mean3dvalY4b=`awk '/Mean 3D/ {print $5}' ./StaticLong/Plots/resultOverV_1860_0.txt`
availabilityvalY4b=`awk '/Availability/ {print $4}' ./StaticLong/Plots/resultOverV_1860_0.txt`
PerfMess4b=`../ShScripts/PerfCmp.sh $mean3dvalY4b $availabilityvalY4b`
if [ "$PerfMess4a" == "Test Not Run" ]
	then
	PerfMess4b=" "
fi
sed -i "/MAX2769 Sampfreq-6864e6 24hours x86 StaticLong:/c\MAX2769 Sampfreq-6864e6 24hours x86 StaticLong:		$PerfMess4a $PerfMess4b" Report.txt

## GPS PERFORMANCE DYNAMIC
echo " " >> Report.txt
echo "- URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V) ---------------------------------" >> Report.txt
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
sed -i "/URSP-N210 Sampfreq-4e6 54min x86 Dynamic (V):/c\URSP-N210 Sampfreq-4e6 54min x86 Dynamic (V):		$PerfMess5" Report.txt
echo " " >> Report.txt

# Change yesterday's results for today's results
mv StaticSim/Plots/results_0_0.txt StaticSim/Plots/ResY.txt
mv Static/Plots/results_0_0.txt Static/Plots/ResY.txt
mv /6TB/nfsshare/nightly-results/Plots/results_0_0.txt /6TB/nfsshare/nightly-results/Plots/ResY.txt
mv StaticLong/Plots/results_0_0.txt StaticLong/Plots/ResY1.txt
mv StaticLong/Plots/results_1860_0.txt StaticLong/Plots/ResY2.txt
mv Dynamic/Plots/results_0_0.txt Dynamic/Plots/ResY.txt


######################################## Test performance ##########################################
# compilation of lists
../ShScripts/timeRatio.sh
../ShScripts/SizeCmp.sh


echo "#############################   Test performance   #############################" >> Report.txt
echo " " >> Report.txt
echo "			Actual			Comp Yesterday		Comp Last Week" >> Report.txt
echo " " >> Report.txt

## CODE PERFORMANCE STATICSIM
echo "- MAX2769 Sampfreq:6864e6 26min x86 StaticSim ----------------------------------" >> Report.txt
echo " " >> Report.txt
echo -n "Runtime:		" >> Report.txt
RunTime1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' times.txt`
RTf1=`../ShScripts/timeFormat.sh $RunTime1`
RunTimeY1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' ytimes.txt`
diffyRunTime1=`expr $RunTime1 - $RunTimeY1`
diffyRTf1=`../ShScripts/timeFormat.sh $diffyRunTime1`
echo -n "$RTf1		$diffyRTf1		" >> Report.txt
RunTimeW1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' wtimes.txt`
diffwRunTime1=`expr $RunTime1 - $RunTimeW1`
diffwRTf1=`../ShScripts/timeFormat.sh $diffwRunTime1`
echo "$diffwRTf1" >> Report.txt

# Time Ratio
echo -n "Time Ratio		" >> Report.txt
timeRatio1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $8}' tratio.txt`
timeRatioY1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $8}' ytratio.txt`
timeRatioW1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $8}' wtratio.txt`
diffytimeRatio1=`echo "$timeRatio1 - $timeRatioY1" | bc`
diffwtimeRatio1=`echo "$timeRatio1 - $timeRatioW1" | bc`
echo "$timeRatio1			$diffytimeRatio1			$diffwtimeRatio1" >> Report.txt

# Size
echo -n "apt size		" >> Report.txt
sizeapt1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' APTsize.txt`
ysizeapt1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' yAPTsize.txt`
wsizeapt1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' wAPTsize.txt`
diffapty1=`expr $sizeapt1 - $ysizeapt1`
diffaptw1=`expr $sizeapt1 - $wsizeapt1`
echo "$sizeapt1		$diffapty1			$diffaptw1" >> Report.txt
echo -n "rnx size		" >> Report.txt
sizernx1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' RNXsize.txt`
ysizernx1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' yRNXsize.txt`
wsizernx1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' wRNXsize.txt`
diffrnxy1=`expr $sizernx1 - $ysizernx1`
diffrnxw1=`expr $sizernx1 - $wsizernx1`
echo "$sizernx1			$diffrnxy1			$diffrnxw1" >> Report.txt

# MB/hr
echo -n "MB/hr			" >> Report.txt
bytesInput1=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' inputSize.txt`
mbhr1=`echo "($bytesInput1 / $RunTime1) * 3600 / 1000000" | bc`
mbhrY1=`echo "($bytesInput1 / $RunTimeY1) * 3600 / 1000000" | bc`
diffmbhrY1=`echo "$mbhr1 - $mbhrY1" | bc` 
mbhrW1=`echo "($bytesInput1 / $RunTimeW1) * 3600 / 1000000" | bc`
diffmbhrW1=`echo "$mbhr1 - $mbhrW1" | bc`
echo "$mbhr1			$diffmbhrY1			$diffmbhrW1" >> Report.txt

echo " " >> Report.txt

## CODE PERFORMANCE STATIC
echo "- MAX2769 Sampfreq:6864e6 52min Static (V) ---------------------------------" >> Report.txt
echo " " >> Report.txt
echo -n "Runtime:		" >> Report.txt
RunTime2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' times.txt`
RTf2=`../ShScripts/timeFormat.sh $RunTime2`
RunTimeY2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' ytimes.txt`
diffyRunTime2=`expr $RunTime2 - $RunTimeY2`
diffyRTf2=`../ShScripts/timeFormat.sh $diffyRunTime2`
echo -n "$RTf2		$diffyRTf2		" >> Report.txt
RunTimeW2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' wtimes.txt`
diffwRunTime2=`expr $RunTime2 - $RunTimeW2`
diffwRTf2=`../ShScripts/timeFormat.sh $diffwRunTime2`
echo "$diffwRTf2" >> Report.txt

# Time Ratio
echo -n "Time Ratio		" >> Report.txt
timeRatio2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $7}' tratio.txt`
timeRatioY2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $7}' ytratio.txt`
timeRatioW2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $7}' wtratio.txt`
diffytimeRatio2=`echo "$timeRatio2 - $timeRatioY2" | bc`
diffwtimeRatio2=`echo "$timeRatio2 - $timeRatioW2" | bc`
echo "$timeRatio2			$diffytimeRatio2			$diffwtimeRatio2" >> Report.txt

# Size
echo -n "apt size		" >> Report.txt
sizeapt2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' APTsize.txt`
ysizeapt2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' yAPTsize.txt`
wsizeapt2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' wAPTsize.txt`
diffapty2=`expr $sizeapt2 - $ysizeapt2`
diffaptw2=`expr $sizeapt2 - $wsizeapt2`
echo "$sizeapt2		$diffapty2			$diffaptw2" >> Report.txt
echo -n "rnx size		" >> Report.txt
sizernx2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' RNXsize.txt`
ysizernx2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' yRNXsize.txt`
wsizernx2=`awk '/MAX2769 Sampfreq:6864e6 52min Static/ {print $5}' wRNXsize.txt`
diffrnxy2=`expr $sizernx2 - $ysizernx2`
diffrnxw2=`expr $sizernx2 - $wsizernx2`
echo "$sizernx2			$diffrnxy2			$diffrnxw2" >> Report.txt

# MB/hr
echo -n "MB/hr			" >> Report.txt
bytesInput2=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' inputSize.txt`
mbhr2=`echo "($bytesInput2 / $RunTime2) * 3600 / 1000000" | bc`
mbhrY2=`echo "($bytesInput2 / $RunTimeY2) * 3600 / 1000000" | bc`
diffmbhrY2=`echo "$mbhr2 - $mbhrY2" | bc` 
mbhrW2=`echo "($bytesInput2 / $RunTimeW2) * 3600 / 1000000" | bc`
diffmbhrW2=`echo "$mbhr2 - $mbhrW2" | bc`
echo "$mbhr2			$diffmbhrY2			$diffmbhrW2" >> Report.txt

echo " " >> Report.txt

## CODE PERFORMANCE ARM STATIC
echo "- MAX2769 Sampfreq:6864e6 52min ARM Static -------------------------------------" >> Report.txt
echo " " >> Report.txt
echo -n "Runtime:		" >> Report.txt
RunTime3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' times.txt`
RTf3=`../ShScripts/timeFormat.sh $RunTime3`
RunTimeY3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' ytimes.txt`
diffyRunTime3=`expr $RunTime3 - $RunTimeY3`
diffyRTf3=`../ShScripts/timeFormat.sh $diffyRunTime3`
echo -n "$RTf3		$diffyRTf3		" >> Report.txt
RunTimeW3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' wtimes.txt`
diffwRunTime3=`expr $RunTime3 - $RunTimeW3`
diffwRTf3=`../ShScripts/timeFormat.sh $diffwRunTime3`
echo "$diffwRTf3" >> Report.txt

# Time Ratio
echo -n "Time Ratio		" >> Report.txt
timeRatio3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $8}' tratio.txt`
timeRatioY3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $8}' ytratio.txt`
timeRatioW3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $8}' wtratio.txt`
diffytimeRatio3=`echo "$timeRatio3 - $timeRatioY3" | bc`
diffwtimeRatio3=`echo "$timeRatio3 - $timeRatioW3" | bc`
echo "$timeRatio3			$diffytimeRatio3			$diffwtimeRatio3" >> Report.txt

# Size
echo -n "apt size		" >> Report.txt
sizeapt3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' APTsize.txt`
ysizeapt3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' yAPTsize.txt`
wsizeapt3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' wAPTsize.txt`
diffapty3=`expr $sizeapt3 - $ysizeapt3`
diffaptw3=`expr $sizeapt3 - $wsizeapt3`
echo "$sizeapt3		$diffapty3			$diffaptw3" >> Report.txt
echo -n "rnx size		" >> Report.txt
sizernx3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' RNXsize.txt`
ysizernx3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' yRNXsize.txt`
wsizernx3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' wRNXsize.txt`
diffrnxy3=`expr $sizernx3 - $ysizernx3`
diffrnxw3=`expr $sizernx3 - $wsizernx3`
echo "$sizernx3			$diffrnxy3			$diffrnxw3" >> Report.txt

# MB/hr
echo -n "MB/hr			" >> Report.txt
bytesInput3=`awk '/MAX2769 Sampfreq:6864e6 52min ARM Static/ {print $6}' inputSize.txt`
mbhr3=`echo "($bytesInput3 / $RunTime3) * 3600 / 1000000" | bc`
mbhrY3=`echo "($bytesInput3 / $RunTimeY3) * 3600 / 1000000" | bc`
diffmbhrY3=`echo "$mbhr3 - $mbhrY3" | bc` 
mbhrW3=`echo "($bytesInput3 / $RunTimeW3) * 3600 / 1000000" | bc`
diffmbhrW3=`echo "$mbhr3 - $mbhrW3" | bc`
echo "$mbhr3			$diffmbhrY3			$diffmbhrW3" >> Report.txt

echo " " >> Report.txt

## CODE PERFORMANCE STATICLONG
echo "- MAX2769 Sampfreq:6864e6 24hours x86 StaticLong -------------------------------" >> Report.txt
echo " " >> Report.txt
echo -n "Runtime:		" >> Report.txt
RunTime4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' times.txt`
RTf4=`../ShScripts/timeFormat.sh $RunTime4`
RunTimeY4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' ytimes.txt`
diffyRunTime4=`expr $RunTime4 - $RunTimeY4`
diffyRTf4=`../ShScripts/timeFormat.sh $diffyRunTime4`
echo -n "$RTf4		$diffyRTf4		" >> Report.txt
RunTimeW4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' wtimes.txt`
diffwRunTime4=`expr $RunTime4 - $RunTimeW4`
diffwRTf4=`../ShScripts/timeFormat.sh $diffwRunTime4`
echo "$diffwRTf4" >> Report.txt

# Time Ratio
echo -n "Time Ratio		" >> Report.txt
timeRatio4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $8}' tratio.txt`
timeRatioY4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $8}' ytratio.txt`
timeRatioW4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $8}' wtratio.txt`
diffytimeRatio4=`echo "$timeRatio4 - $timeRatioY4" | bc`
diffwtimeRatio4=`echo "$timeRatio4 - $timeRatioW4" | bc`
echo "$timeRatio4			$diffytimeRatio4			$diffwtimeRatio4" >> Report.txt

# Size a
echo -n "apt1 size		" >> Report.txt
sizeapt4a=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' APTsize.txt`
ysizeapt4a=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' yAPTsize.txt`
wsizeapt4a=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' wAPTsize.txt`
diffapty4a=`expr $sizeapt4a - $ysizeapt4a`
diffaptw4a=`expr $sizeapt4a - $wsizeapt4a`
echo "$sizeapt4a		$diffapty4a			$diffaptw4a" >> Report.txt
echo -n "rnx1 size		" >> Report.txt
sizernx4a=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' RNXsize.txt`
ysizernx4a=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' yRNXsize.txt`
wsizernx4a=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' wRNXsize.txt`
diffrnxy4a=`expr $sizernx4a - $ysizernx4a`
diffrnxw4a=`expr $sizernx4a - $wsizernx4a`
echo "$sizernx4a		$diffrnxy4a			$diffrnxw4a" >> Report.txt

# Size b
echo -n "apt2 size		" >> Report.txt
sizeapt4b=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' APTsize.txt`
ysizeapt4b=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' yAPTsize.txt`
wsizeapt4b=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' wAPTsize.txt`
diffapty4b=`expr $sizeapt4b - $ysizeapt4b`
diffaptw4b=`expr $sizeapt4b - $wsizeapt4b`
echo "$sizeapt4b		$diffapty4b			$diffaptw4b" >> Report.txt
echo -n "rnx2 size		" >> Report.txt
sizernx4b=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' RNXsize.txt`
ysizernx4b=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' yRNXsize.txt`
wsizernx4b=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' wRNXsize.txt`
diffrnxy4b=`expr $sizernx4b - $ysizernx4b`
diffrnxw4b=`expr $sizernx4b - $wsizernx4b`
echo "$sizernx4b		$diffrnxy4b			$diffrnxw4b" >> Report.txt

# MB/hr
echo -n "MB/hr			" >> Report.txt
bytesInput4=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' inputSize.txt`
mbhr4=`echo "($bytesInput4 / $RunTime4) * 3600 / 1000000" | bc`
mbhrY4=`echo "($bytesInput4 / $RunTimeY4) * 3600 / 1000000" | bc`
diffmbhrY4=`echo "$mbhr4 - $mbhrY4" | bc` 
mbhrW4=`echo "($bytesInput4 / $RunTimeW4) * 3600 / 1000000" | bc`
diffmbhrW4=`echo "$mbhr4 - $mbhrW4" | bc`
echo "$mbhr4			$diffmbhrY4			$diffmbhrW4" >> Report.txt

echo " " >> Report.txt

## CODE PERFORMANCE DYNAMIC
echo "- URSP-N210 Sampfreq:4e6 54min x86 Dynamic (V) ---------------------------------" >> Report.txt
echo " " >> Report.txt
echo -n "Runtime:		" >> Report.txt
RunTime5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' times.txt`
RTf5=`../ShScripts/timeFormat.sh $RunTime5`
RunTimeY5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' ytimes.txt`
diffyRunTime5=`expr $RunTime5 - $RunTimeY5`
diffyRTf5=`../ShScripts/timeFormat.sh $diffyRunTime5`
echo -n "$RTf5		$diffyRTf5		" >> Report.txt
RunTimeW5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' wtimes.txt`
diffwRunTime5=`expr $RunTime5 - $RunTimeW5`
diffwRTf5=`../ShScripts/timeFormat.sh $diffwRunTime5`
echo "$diffwRTf5" >> Report.txt

# Time Ratio
echo -n "Time Ratio		" >> Report.txt
timeRatio5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $8}' tratio.txt`
timeRatioY5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $8}' ytratio.txt`
timeRatioW5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $8}' wtratio.txt`
diffytimeRatio5=`echo "$timeRatio5 - $timeRatioY5" | bc`
diffwtimeRatio5=`echo "$timeRatio5 - $timeRatioW5" | bc`
echo "$timeRatio5			$diffytimeRatio5			$diffwtimeRatio5" >> Report.txt

# Size
echo -n "apt size		" >> Report.txt
sizeapt5=`awk '/URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic/ {print $7}' APTsize.txt`
ysizeapt5=`awk '/URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic/ {print $7}' yAPTsize.txt`
wsizeapt5=`awk '/URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic/ {print $7}' wAPTsize.txt`
diffapty5=`expr $sizeapt5 - $ysizeapt5`
diffaptw5=`expr $sizeapt5 - $wsizeapt5`
echo "$sizeapt5		$diffapty5			$diffaptw5" >> Report.txt
echo -n "rnx size		" >> Report.txt
sizernx5=`awk '/URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic/ {print $7}' RNXsize.txt`
ysizernx5=`awk '/URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic/ {print $7}' yRNXsize.txt`
wsizernx5=`awk '/URSP-N210 L2C Sampfreq:4e6 54min x86 Dynamic/ {print $7}' wRNXsize.txt`
diffrnxy5=`expr $sizernx5 - $ysizernx5`
diffrnxw5=`expr $sizernx5 - $wsizernx5`
echo "$sizernx5			$diffrnxy5			$diffrnxw5" >> Report.txt

# MB/hr
echo -n "MB/hr			" >> Report.txt
bytesInput5=`awk '/URSP-N210 Sampfreq:4e6 54min x86 L1 Dynamic:/ {print $7}' inputSize.txt`
mbhr5=`echo "($bytesInput5 / $RunTime5) * 3600 / 1000000" | bc`
mbhrY5=`echo "($bytesInput5 / $RunTimeY5) * 3600 / 1000000" | bc`
diffmbhrY5=`echo "$mbhr5 - $mbhrY5" | bc` 
mbhrW5=`echo "($bytesInput5 / $RunTimeW5) * 3600 / 1000000" | bc`
diffmbhrW5=`echo "$mbhr5 - $mbhrW5" | bc`
echo "$mbhr5			$diffmbhrY5			$diffmbhrW5" >> Report.txt

echo " " >> Report.txt

# Move current times.txt/tratio.txt and make it new ytimes.txt/ytratio.txt
mv times.txt ytimes.txt
mv tratio.txt ytratio.txt
mv RNXsize.txt yRNXsize.txt
mv APTsize.txt yAPTsize.txt

########################################## Error check ##########################################
# Checks whether error.txt exists
if [ -s error.txt ]
	then
	sed -i "/Run Performance:/c\Run Performance: Errors!" Report.txt
else
	sed -i "/Run Performance:/c\Run Performance: No Errors." Report.txt
fi

echo " " >> Report.txt
## Prints Completion Message
echo "########################   Short OverNight Report End   #########################" >> Report.txt

sleep 2m
