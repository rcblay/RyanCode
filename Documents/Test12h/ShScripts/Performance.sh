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
echo -n "CPU " >> Report.txt
less /proc/cpuinfo | grep "model name" | tail -1 >> Report.txt # Current cpu model
echo " " >> Report.txt
echo "Reference data was generated using:" >> Report.txt
echo " Version: 	-" >> Report.txt 
echo " Compiler: 	-" >> Report.txt
echo " ARM Compiler: 	-" >> Report.txt
echo " CPU model name: 	-" >> Report.txt

# Includes info regarding what equipment was used to generate the reference data
if [ -s REFbuild.txt ]
	then
	versREF=`grep "Version" REFbuild.txt`
	sed -i "/ Version: 	-/c\ $versREF " Report.txt
	compREF=`grep "Compiler" REFbuild.txt`
	sed -i "/ Compiler: 	-/c\ $compREF " Report.txt
	ARMcompREF=`grep "ARM Compiler" REFbuild.txt`
	sed -i "/ ARM Compiler: 	-/c\ $ARMcompREF " Report.txt
	cpuREF=`grep "model name" REFbuild.txt`
	sed -i "/ CPU model name: 	-/c\ $cpuREF " Report.txt
fi
echo " " >> Report.txt

# Takes start and stop information 
echo -n "Test started: " >> Report.txt
date -d @$Teststart >> Report.txt
Testend=$(date +%s)

echo -n "Test ended: " >> Report.txt
date -d @$Testend >> Report.txt

diffT=`expr $Testend - $Teststart`
echo -n "Duration: " >> Report.txt
echo `../ShScripts/timeFormat.sh $diffT` >> Report.txt
#date -d @`expr $diffT + 25200` +%T >> Report.txt # adds seven hour to first epoch to express difference in time. Only works when below 24 hours
rm Summary.txt # needed?

echo " " >> Report.txt
echo " " >> Report.txt
echo "###############################################################################" >> Report.txt
echo " " >> Report.txt
echo " Build/Run Performance: " >> Report.txt
echo " " >> Report.txt

######################################### Deterministic ############################################
echo "------------------------------   Deterministic   ------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Not deterministic tests are:" >> Report.txt
echo " " >> Report.txt

det=0 # Changes to 1 if file is non-deterministic

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
		det=1
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
	det=1
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
	det=1
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
		det=1
		echo "error" > error.txt
	fi
fi

# Change warning if deterministic

if [ $det -eq 0 ]
	then
	sed -i "/Not deterministic tests are:/c\ All Files deterministic!" Report.txt
fi


######################################## GCC Warnings ##############################################
echo " " >> Report.txt
echo "------------------------------   GCC Warnings   -------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Files with GCC warnings:" >> Report.txt
echo " " >> Report.txt

gccw=0 # changes to 1 if builds have GCC warnings

## GCC WARNINGS STATICSIM
if tail StaticSim/screenout.txt | grep -q -i "Segmentation Fault";
	then 
	echo "	MAX2769 Sampfreq:6864e6 26min x86 StaticSim	Segmentation Fault" >> Report.txt
	gccw=1
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
	gccw=1
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
	gccw=1
	echo "error" > error.txt
fi

## GCC WARNINGS STATICLONG
if tail StaticLong/screenout.txt | grep -q -i "Segmentation Fault";
	then 
	echo "	MAX2769 Sampfreq:6864e6 24hours x86 StaticLong	Segmentation Fault" >> Report.txt
	gccw=1
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
	gccw=1
	echo "error" > error.txt
fi

# Change warning if there are no GCC warnings

if [ $gccw -eq 0 ]
	then
	sed -i "/Files with GCC warnings:/c\ No GCC warnings!" Report.txt
fi

########################################## Valgrind ##############################################
echo " " >> Report.txt
echo "---------------------------------   Valgrind   --------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Files with leaks or other Valgrind warnings:" >> Report.txt
echo " " >> Report.txt

valw=0 # Changes to 1 if a file doesn't pass a valgrind test

## VALGRIND STATIC
FileDes1=`awk '/FILE DESCRIPTORS/ {print $4}' Static/valwar.txt`
if [ $FileDes1 -ne 4 ] || grep -q -i "LEAK SUMMARY" Static/valwar.txt
	then
	echo " MAX2769 Sampfreq:6864e6 52min Static" >> Report.txt
	valw=1
	echo "error" > error.txt
fi

## VALGRIND DYNAMIC
FileDes2=`awk '/FILE DESCRIPTORS/ {print $4}' Dynamic/valwar.txt`
if [ $FileDes2 -ne 4 ] || grep -q -i "LEAK SUMMARY" Dynamic/valwar.txt;
	then
	echo " URSP-N210 Sampfreq:4e6 54min x86 Dynamic" >> Report.txt
	valw=1
	echo "error" > error.txt
fi

# Change warning if there are no Valgrind warnings

if [ $valw -eq 0 ]
	then
	sed -i "/Files with leaks or other Valgrind warnings:/c\ No detected leaks!" Report.txt
fi

echo "---------------------------------   Doxygen   ---------------------------------" >> Report.txt
echo " " >> Report.txt
echo " Doxygen warnings regarding undocumented code: " >> Report.txt
echo " " >> Report.txt

dox=0

if [ s ../Pyxis_current/pyxis/doc/chn/codedocs/pyxis_chn_warn.log ]
	then
	echo "		Chn " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/chn/codedocs/html/* /var/www/chn/

if [ s ../Pyxis_current/pyxis/doc/com/codedocs/pyxis_com_warn.log ]
	then
	echo "		Com " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/com/codedocs/html/* /var/www/com/

if [ s ../Pyxis_current/pyxis/doc/conf/codedocs/pyxis_conf_warn.log ]
	then
	echo "		Conf " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/conf/codedocs/html/* /var/www/conf/

if [ s ../Pyxis_current/pyxis/doc/cor/codedocs/pyxis_cor_warn.log ]
	then
	echo "		Cor " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/cor/codedocs/html/* /var/www/cor/

if [ s ../Pyxis_current/pyxis/doc/ibc/codedocs/pyxis_ibc_warn.log ]
	then
	echo "		Ibc " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/ibc/codedocs/html/* /var/www/ibc/

if [ s ../Pyxis_current/pyxis/doc/include/codedocs/pyxis_include_warn.log ]
	then
	echo "		Inclunde " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/include/codedocs/html/* /var/www/include/

if [ s ../Pyxis_current/pyxis/doc/kal/codedocs/pyxis_kal_warn.log ]
	then
	echo "		Kal " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/kal/codedocs/html/* /var/www/kal/

if [ s ../Pyxis_current/pyxis/doc/mea/codedocs/pyxis_mea_warn.log ]
	then
	echo "		Mea " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/mea/codedocs/html/* /var/www/mea/

if [ s ../Pyxis_current/pyxis/doc/nav/codedocs/pyxis_nav_warn.log ]
	then
	echo "		Nav " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/nav/codedocs/html/* /var/www/nav/

if [ s ../Pyxis_current/pyxis/doc/rcv/codedocs/pyxis_rcv_warn.log ]
	then
	echo "		Rcv " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/rcv/codedocs/html/* /var/www/rcv/

if [ s ../Pyxis_current/pyxis/doc/sch/codedocs/pyxis_sch_warn.log ]
	then
	echo "		Sch " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/sch/codedocs/html/* /var/www/sch/

if [ s ../Pyxis_current/pyxis/doc/swc/codedocs/pyxis_swc_warn.log ]
	then
	echo "		Swc " >> Report.txt
	dox=1
fi
mv -f ../Pyxis_current/pyxis/doc/swc/codedocs/html/* /var/www/swc/

if [ $dox -eq 0 ]
	then
	sed -i "/Doxygen warnings regarding undocumented code:/c\ Code documentation has reached doxygen standards." Report.txt
fi
echo " " >> Report.txt
echo "###############################################################################" >> Report.txt

######################################## Static Sim
echo " " >> Report.txt
echo " MAX2769 Sampfreq:6864e6 26min x86 StaticSim " >> Report.txt

echo "	Name:		StaticSimBinaries.bin " >> Report.txt
echo "	Duration:	00h:25m:39s" >> Report.txt
echo "	Size:		10.562 GB " >> Report.txt
echo "	Why:		Compare our static to the simulators" >> Report.txt
echo " " >> Report.txt


echo " Performance:" >> Report.txt
echo " " >> Report.txt

# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' StaticSim/Plots/resultOverV_0_0.txt
sed -i 's/"//g' StaticSim/Plots/resultOverV_0_0.txt

# Get data for Report
runtime=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' times.txt`
RTf=`../ShScripts/timeFormat.sh $runtime`
runtimeR=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' rtimes.txt`
diffRunTime=`expr $runtime - $runtimeR`
diffRTf=`../ShScripts/timeFormat.sh $diffRunTime`
ratio=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $8}' tratio.txt`
ratioR=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $8}' rtratio.txt`
difftimeRatio=`echo "$ratio - $ratioR" | bc`
sizeapt=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' APTsize.txt`
rsizeapt=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' rAPTsize.txt`
diffapt=`expr $sizeapt - $rsizeapt`
sizernx=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' RNXsize.txt`
rsizernx=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' rRNXsize.txt`
diffrnx=`expr $sizernx - $rsizernx`
durationfile=`awk '/MAX2769 Sampfreq:6864e6 26min x86 StaticSim/ {print $6}' durationtestfile.txt`
aptmbhr=`echo "($sizeapt / $durationfile) * 0.0036" | bc`
diffaptmbhr=`echo "($diffapt / $durationfile) * 0.0036" | bc`
rnxmbhr=`echo "($sizernx / $durationfile) * 0.0036" | bc`
diffrnxmbhr=`echo "($diffrnx / $durationfile) * 0.0036" | bc`

if [ -s StaticSim/DetermStatSim.txt ] && [ "$(grep -i 'rnx' StaticSim/DetermStatSim.txt)" == "rnx" ]
	then 
	echo "   RNX reference is: Different" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt
 
	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3, "				", $5}' ./StaticSim/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4, "				", $8}' ./StaticSim/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2, "				", $4}' ./StaticSim/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr			$diffaptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr			$diffrnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)		$diffRTf ($difftimeRatio)" >> Report.txt






else
	echo "   RNX reference is: Equal" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3}' ./StaticSim/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4}' ./StaticSim/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2}' ./StaticSim/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)" >> Report.txt





fi





echo "-------------------------------------------------------------------------------" >> Report.txt

######################################## Static
echo " " >> Report.txt
echo " MAX2769 Sampfreq:6864e6 52min x86 Static " >> Report.txt

echo "	Name:		MAX2769_L1_20150828_20150831_fs_6864e6_if21912e6_schar_20GB.bin " >> Report.txt
echo "	Duration:	00h:52m:09s" >> Report.txt
echo "	Size:		21.475 GB " >> Report.txt
echo "	Why:		Valgrind to check for memory leaks" >> Report.txt
echo " " >> Report.txt


echo " Performance:" >> Report.txt
echo " " >> Report.txt

# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' Static/Plots/resultOverV_0_0.txt
sed -i 's/"//g' Static/Plots/resultOverV_0_0.txt

# Get data for Report
runtime=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' times.txt`
RTf=`../ShScripts/timeFormat.sh $runtime`
runtimeR=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' rtimes.txt`
diffRunTime=`expr $runtime - $runtimeR`
diffRTf=`../ShScripts/timeFormat.sh $diffRunTime`
ratio=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $8}' tratio.txt`
ratioR=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $8}' rtratio.txt`
difftimeRatio=`echo "$ratio - $ratioR" | bc`
sizeapt=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' APTsize.txt`
rsizeapt=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' rAPTsize.txt`
diffapt=`expr $sizeapt - $rsizeapt`
sizernx=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' RNXsize.txt`
rsizernx=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' rRNXsize.txt`
diffrnx=`expr $sizernx - $rsizernx`
durationfile=`awk '/MAX2769 Sampfreq:6864e6 52min x86 Static/ {print $6}' durationtestfile.txt`
aptmbhr=`echo "($sizeapt / $durationfile) * 0.0036" | bc`
diffaptmbhr=`echo "($diffapt / $durationfile) * 0.0036" | bc`
rnxmbhr=`echo "($sizernx / $durationfile) * 0.0036" | bc`
diffrnxmbhr=`echo "($diffrnx / $durationfile) * 0.0036" | bc`

if [ -s Static/DetermStat.txt ] && [ "$(grep -i 'rnx' Static/DetermStat.txt)" == "rnx" ]
	then 
	echo "   RNX reference is: Different" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

 	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3, "				", $5}' ./Static/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4, "				", $8}' ./Static/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2, "				", $4}' ./Static/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr			$diffaptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr			$diffrnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)		$diffRTf ($difftimeRatio)" >> Report.txt






else
	echo "   RNX reference is: Equal" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3}' ./Static/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4}' ./Static/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2}' ./Static/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)" >> Report.txt





fi


echo "-------------------------------------------------------------------------------" >> Report.txt

######################################## Static ARM
echo " " >> Report.txt
echo " MAX2769 Sampfreq:6864e6 30min ARM Static " >> Report.txt

echo "	Name:		MAX2769_L1_20150828_20150831_fs_6864e6_if21912e6_nightARM.bin " >> Report.txt
echo "	Duration:	00h:30m:00s" >> Report.txt
echo "	Size:		12.357 GB " >> Report.txt
echo "	Why:		Run on the Zed-board" >> Report.txt
echo " " >> Report.txt


echo " Performance:" >> Report.txt
echo " " >> Report.txt

# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|/ /g' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt
sed -i 's/"/ /g' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt 

# Get data for Report
runtime=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' times.txt`
RTf=`../ShScripts/timeFormat.sh $runtime`
runtimeR=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' rtimes.txt`
diffRunTime=`expr $runtime - $runtimeR`
diffRTf=`../ShScripts/timeFormat.sh $diffRunTime`
ratio=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $8}' tratio.txt`
ratioR=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $8}' rtratio.txt`
difftimeRatio=`echo "$ratio - $ratioR" | bc`
sizeapt=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' APTsize.txt`
rsizeapt=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' rAPTsize.txt`
diffapt=`expr $sizeapt - $rsizeapt`
sizernx=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' RNXsize.txt`
rsizernx=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' rRNXsize.txt`
diffrnx=`expr $sizernx - $rsizernx`
durationfile=`awk '/MAX2769 Sampfreq:6864e6 30min ARM Static/ {print $6}' durationtestfile.txt`
aptmbhr=`echo "($sizeapt / $durationfile) * 0.0036" | bc`
diffaptmbhr=`echo "($diffapt / $durationfile) * 0.0036" | bc`
rnxmbhr=`echo "($sizernx / $durationfile) * 0.0036" | bc`
diffrnxmbhr=`echo "($diffrnx / $durationfile) * 0.0036" | bc`

if [ -s /6TB/nfsshare/nightly-results/DetermARM.txt ] && [ "$(grep -i 'rnx' /6TB/nfsshare/nightly-results/DetermARM2.txt)" == "rnx" ]
	then 
	echo "   RNX reference is: Different" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt
 
	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3, "				", $5}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4, "				", $8}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2, "				", $4}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr			$diffaptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr			$diffrnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)		$diffRTf ($difftimeRatio)" >> Report.txt






else
	echo "   RNX reference is: Equal" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2}' /6TB/nfsshare/nightly-results/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)" >> Report.txt





fi





echo "-------------------------------------------------------------------------------" >> Report.txt


######################################## Static Long

echo " " >> Report.txt
echo " MAX2769 Sampfreq:6864e6 24hours x86 StaticLong " >> Report.txt

echo "	Name:		MAX2769_L1_20150828_20150831_fs_6864e6_if21912e6_schar_WRoverBIG.bin " >> Report.txt
echo "	Duration:	24h:00m:00s" >> Report.txt
echo "	Size:		593.05 GB " >> Report.txt
echo "	Why:		Long test for weekend rollover and other long test failures" >> Report.txt
echo " " >> Report.txt


echo " Performance:" >> Report.txt
echo " " >> Report.txt

# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' StaticLong/Plots/resultOverV_0_0.txt
sed -i 's/"//g' StaticLong/Plots/resultOverV_0_0.txt

# Get data for Report
runtime=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' times.txt`
RTf=`../ShScripts/timeFormat.sh $runtime`
runtimeR=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' rtimes.txt`
diffRunTime=`expr $runtime - $runtimeR`
diffRTf=`../ShScripts/timeFormat.sh $diffRunTime`
ratio=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $8}' tratio.txt`
ratioR=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $8}' rtratio.txt`
difftimeRatio=`echo "$ratio - $ratioR" | bc`

sizeapt1=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' APTsize.txt`
rsizeapt1=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' rAPTsize.txt`
diffapt1=`expr $sizeapt1 - $rsizeapt1`
sizeapt2=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' APTsize.txt`
rsizeapt2=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' rAPTsize.txt`
diffapt2=`expr $sizeapt2 - $rsizeapt2`

sizernx1=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' RNXsize.txt`
rsizernx1=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong1/ {print $6}' rRNXsize.txt`
diffrnx1=`expr $sizernx1 - $rsizernx1`
sizernx2=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' RNXsize.txt`
rsizernx2=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong2/ {print $6}' rRNXsize.txt`
diffrnx2=`expr $sizernx2 - $rsizernx2`

durationfile=`awk '/MAX2769 Sampfreq:6864e6 24hours x86 StaticLong/ {print $6}' durationtestfile.txt`
aptmbhr=`echo "(($sizeapt1 + $sizeapt2) / $durationfile) * 0.0036" | bc`
diffaptmbhr=`echo "(($diffapt1 + $diffapt2) / $durationfile) * 0.0036" | bc`
rnxmbhr=`echo "(($sizernx1 + $sizernx2) / $durationfile) * 0.0036" | bc`
diffrnxmbhr=`echo "(($diffrnx1 + $diffrnx2) / $durationfile) * 0.0036" | bc`

if [ -s StaticLong/DetermStatL.txt ] && [ "$(grep -i 'rnx' StaticLong/DetermStatL.txt)" == "rnx" ]
	then 
	echo "   RNX reference is: Different" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

 	# Extracts the values needed and prints them to the report
	mean3dval1=`awk '/Mean 3D/ {print $3, "				", $5}' ./StaticLong/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D 1 (m)			$mean3dval1" >> Report.txt
	mean3dval2=`awk '/Mean 3D/ {print $3, "				", $5}' ./StaticLong/Plots/resultOverV_1860_0.txt`
	echo "	Mean 3D 2 (m)			$mean3dval2" >> Report.txt
	
	max3dval1=`awk '/Max 3D Error/ {print $4, "				", $8}' ./StaticLong/Plots/resultOverV_0_0.txt`
	echo "	Max 3D 1 (m)			$max3dval1" >> Report.txt
	max3dval2=`awk '/Max 3D Error/ {print $4, "				", $8}' ./StaticLong/Plots/resultOverV_1860_0.txt`
	echo "	Max 3D 2 (m)			$max3dval2" >> Report.txt

	availabilityval1=`awk '/Availability/ {print $2, "				", $4}' ./StaticLong/Plots/resultOverV_0_0.txt`
	echo "	Avail 1 (%)				$availabilityval1" >> Report.txt
	availabilityval2=`awk '/Availability/ {print $2, "				", $4}' ./StaticLong/Plots/resultOverV_1860_0.txt`
	echo "	Avail 2 (%)				$availabilityval2" >> Report.txt

	echo " " >> Report.txt

	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr			$diffaptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr			$diffrnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)		$diffRTf ($difftimeRatio)" >> Report.txt






else
	echo "   RNX reference is: Equal" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

	# Extracts the values needed and prints them to the report
	mean3dval1=`awk '/Mean 3D/ {print $3}' ./StaticLong/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D 1 (m)			$mean3dval1" >> Report.txt
	mean3dval2=`awk '/Mean 3D/ {print $3}' ./StaticLong/Plots/resultOverV_1860_0.txt`
	echo "	Mean 3D 2 (m)			$mean3dval2" >> Report.txt

	max3dval1=`awk '/Max 3D Error/ {print $4}' ./StaticLong/Plots/resultOverV_0_0.txt`
	echo "	Max 3D 1 (m)			$max3dval1" >> Report.txt
	max3dval2=`awk '/Max 3D Error/ {print $4}' ./StaticLong/Plots/resultOverV_1860_0.txt`
	echo "	Max 3D 2 (m)			$max3dval2" >> Report.txt

	availabilityval1=`awk '/Availability/ {print $2}' ./StaticLong/Plots/resultOverV_0_0.txt`
	echo "	Avail 1 (%)				$availabilityval1" >> Report.txt
	availabilityval2=`awk '/Availability/ {print $2}' ./StaticLong/Plots/resultOverV_1860_0.txt`
	echo "	Avail 2 (%)				$availabilityval2" >> Report.txt
	
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)" >> Report.txt





fi


######################################## Dynamic
echo " " >> Report.txt
echo " URSP-N210 Sampfreq:4e6 54min x86 Dynamic " >> Report.txt

echo "	Name:		L1_201510161135_fs_4e6_if20e3_schar1bit.bin " >> Report.txt
echo "			L2_201510161135_fs_4e6_if20e3_schar1bit.bin " >> Report.txt
echo "	Duration:	00h:53m:38s" >> Report.txt
echo "	Size:		25.797 GB + 25.735 GB " >> Report.txt
echo "	Why:		Valgrind to check for memory leaks as well as " >> Report.txt
echo "			a dynamic run to check change in availability. " >> Report.txt
echo " " >> Report.txt


echo " Performance:" >> Report.txt
echo " " >> Report.txt

# Cleans out the expanded resultOver_-_-.txt file of | and " symbols
sed -i 's/|//g' Dynamic/Plots/resultOverV_0_0.txt
sed -i 's/"//g' Dynamic/Plots/resultOverV_0_0.txt

# Get data for Report
runtime=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' times.txt`
RTf=`../ShScripts/timeFormat.sh $runtime`
runtimeR=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' rtimes.txt`
diffRunTime=`expr $runtime - $runtimeR`
diffRTf=`../ShScripts/timeFormat.sh $diffRunTime`
ratio=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $8}' tratio.txt`
ratioR=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $8}' rtratio.txt`
difftimeRatio=`echo "$ratio - $ratioR" | bc`
sizeapt=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' APTsize.txt`
rsizeapt=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' rAPTsize.txt`
diffapt=`expr $sizeapt - $rsizeapt`
sizernx=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' RNXsize.txt`
rsizernx=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' rRNXsize.txt`
diffrnx=`expr $sizernx - $rsizernx`
durationfile=`awk '/URSP-N210 Sampfreq:4e6 54min x86 Dynamic/ {print $6}' durationtestfile.txt`
aptmbhr=`echo "($sizeapt / $durationfile) * 0.0036" | bc`
diffaptmbhr=`echo "($diffapt / $durationfile) * 0.0036" | bc`
rnxmbhr=`echo "($sizernx / $durationfile) * 0.0036" | bc`
diffrnxmbhr=`echo "($diffrnx / $durationfile) * 0.0036" | bc`

if [ -s Dynamic/DetermDyn.txt ] && [ "$(grep -i 'rnx' Dynamic/DetermDyn.txt)" == "rnx" ]
	then 
	echo "   RNX reference is: Different" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

 	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3, "				", $5}' ./Dynamic/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4, "				", $8}' ./Dynamic/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2, "				", $4}' ./Dynamic/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr			$diffaptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr			$diffrnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)		$diffRTf ($difftimeRatio)" >> Report.txt

else
	echo "   RNX reference is: Equal" >> Report.txt
	echo " " >> Report.txt
	echo "					Actual				Comp Reference" >> Report.txt
	echo " " >> Report.txt

	# Extracts the values needed and prints them to the report
	mean3dval=`awk '/Mean 3D/ {print $3}' Dynamic/Plots/resultOverV_0_0.txt`
	echo "	Mean 3D (m)			$mean3dval" >> Report.txt
	max3dval=`awk '/Max 3D Error/ {print $4}' Dynamic/Plots/resultOverV_0_0.txt`
	echo "	Max 3D (m)			$max3dval" >> Report.txt
	availabilityval=`awk '/Availability/ {print $2}' Dynamic/Plots/resultOverV_0_0.txt`
	echo "	Avail (%)				$availabilityval" >> Report.txt
	echo " " >> Report.txt
	echo -n "	apt (MB/hr)			" >> Report.txt
	echo "$aptmbhr" >> Report.txt
	echo -n "	rnx (MB/hr)			" >> Report.txt
	echo "$rnxmbhr" >> Report.txt
	echo -n "	run time (ratio)		" >> Report.txt
	echo "$RTf ($ratio)" >> Report.txt

fi

########################################## Error check ##########################################
# Checks whether error.txt exists
if [ -s error.txt ]
	then
	sed -i "/Run Performance:/c\Build\/Run Performance: Errors!" Report.txt
else
	sed -i "/Run Performance:/c\Build\/Run Performance: No Errors." Report.txt
fi

echo " " >> Report.txt
## Prints Completion Message
echo "########################   Short OverNight Report End   #########################" >> Report.txt

sleep 2m

########################################################################################################
########################################################################################################
########################################################################################################
