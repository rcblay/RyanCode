#!/bin/bash
#################################################
#      	         Performance		        #
# Cuts and pastes important results into text	#
# file.	Also checks whether the mean error has	#
# increased by a certain threshold of 20 cm.	#
#						#
# Input: Summary.txt, results_0_0.txt,       	#
#	 Wwarning.txt, valwar.txt for both 	#
#	 Static1Heavy and Dynamic1Heavy and 	#
#	 DetermDyn.txt and DetermStat.txt.	#
#						#
# Output: PerfSummary.txt			#
#################################################

## Test Characteristics Summary
cd ../output
echo "#########################################################################" > PerfSummary.txt
echo "#######################Performance Characteristics#######################" >> PerfSummary.txt
echo "#########################################################################" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Takes start and stop information located in Summary.txt 
grep -A8 'Pyxis Test' ./Summary.txt >> PerfSummary.txt
echo " " >> PerfSummary.txt
echo "##############################Dynamic Test###############################" >> PerfSummary.txt
echo " " >> PerfSummary.txt


## Obtains Dynamic Characteristics from results_0_0.txt
echo "------------------------Dynamic1 Characteristics-------------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Tidies up information from results_0_0.txt and presents it in nice format
max3dval=`awk '/Max 3D Error/ {print $5}' ./Dynamic1Heavy/Plots/results_0_0.txt | sed 's/.*|//'`
timemax3d=`awk '/Max 3D Error/ {print $7 " " $8}' ./Dynamic1Heavy/Plots/results_0_0.txt`
echo "Max 3D Error:       $max3dval meters $timemax3d" >> PerfSummary.txt
mean3dval=`awk '/Mean 3D/ {print $4}' ./Dynamic1Heavy/Plots/results_0_0.txt | sed 's/.*|//'`
echo "Mean 3D Error:      $mean3dval meters" >> PerfSummary.txt
availabilityval=`awk '/Availability/ {print $3}' ./Dynamic1Heavy/Plots/results_0_0.txt | sed 's/.*|//'`
echo "Availability:       $availabilityval %" >> PerfSummary.txt
# If there is no information from dynamic characteristics, print that to PerfSummary.txt
if [ $? -ne 0 ]
then 
echo "No Dynamic Characteristics Found" >> PerfSummary.txt
fi
echo " " >> PerfSummary.txt

## Check Performance vs Previous Test
# Using two files, check performance of file 1 against file 2 and print out warning if exceeds tolerance
File1=./Dynamic1Heavy/Plots/results_0_0.txt
File2=./Dynamic1Heavy/Plots/ref.txt
Tolerance=0.2 #meters
# Gleans numbers from both files and compares them
var=`awk '/Mean 3D/ {print $4}' $File1`
mean3d=`echo $var | sed 's/.*|//'`
num=$mean3d
varRef=`awk '/Mean 3D/ {print $4}' $File2`
mean3dRef=`echo $varRef | sed 's/.*|//'`
numRef=$mean3dRef
rv=`bc -l <<< "$num > ($numRef + $Tolerance)"`
# If new file is greater than reference file by more than the tolerance, warning is printed
if [ $rv -eq 1 ]
then
echo "***Warning: Mean 3D Error has increased by more than 20 cm***" >> PerfSummary.txt
echo " " >> PerfSummary.txt
fi

## Obtains Dynamic Compiler Warnings from Wwarning.txt
echo "------------------------Dynamic Compiler Warnings------------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Search for 'warning:' and print to PerfSummary.txt
grep 'warning:' ./Dynamic1Heavy/Wwarning.txt >> PerfSummary.txt
# If there is no dynamic compiler warning, print that to PerfSummary.txt
if [ $? -ne 0 ]
then 
echo "No Dynamic Compiler Warnings Found" >> PerfSummary.txt
fi
echo " " >> PerfSummary.txt

## Obtains Dynamic Valgrind Information from valwar.txt
echo "----------------------Dynamic Valgrind Information-----------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Search for 'FILE DESCRIPTORS' and print out line to PerfSummary.txt
grep 'FILE DESCRIPTORS' ./Dynamic1Heavy/valwar.txt >> PerfSummary.txt
# Search for line with "LEAK SUMMARY" and print out the following ten lines to PerfSummary.txt
grep -A10 'LEAK SUMMARY' ./Dynamic1Heavy/valwar.txt >> PerfSummary.txt
# If there is no dynamic valgrind information, print that to PerfSummary.txt
if [ $? -ne 0 ]
then 
echo "No Dynamic Valgrind Information Found" >> PerfSummary.txt
fi
echo " " >> PerfSummary.txt

## Obtains Dynamic Deterministic Information from DetermDyn.txt
echo "-------------------Dynamic Deterministic Information---------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Search for 'apt' and print out the following four lines to PerfSummary.txt
grep -A4 'apt' ./Dynamic1Heavy/DetermDyn.txt >> PerfSummary.txt
echo " " >> PerfSummary.txt

## Static Characteristics Summary
echo "#############################Static Test#################################" >> PerfSummary.txt
echo " " >> PerfSummary.txt

## Obtains Static Characteristics from results_0_0.txt
echo "-----------------------Static1 Characteristics---------------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Tidies up information from results_0_0.txt and presents it in nice format
max3dval2=`awk '/Max 3D Error/ {print $5}' ./Static1Heavy/Plots/results_0_0.txt | sed 's/.*|//'`
timemax3d2=`awk '/Max 3D Error/ {print $7 " " $8}' ./Static1Heavy/Plots/results_0_0.txt`
echo "Max 3D Error:       $max3dval2 meters $timemax3d2" >> PerfSummary.txt
mean3dval2=`awk '/Mean 3D/ {print $4}' ./Static1Heavy/Plots/results_0_0.txt | sed 's/.*|//'`
echo "Mean 3D Error:      $mean3dval2 meters" >> PerfSummary.txt
availabilityval2=`awk '/Availability/ {print $3}' ./Static1Heavy/Plots/results_0_0.txt | sed 's/.*|//'`
echo "Availability:       $availabilityval2 %" >> PerfSummary.txt
# If there is no information from static characteristics, print that to PerfSummary.txt
if [ $? -ne 0 ]
then 
echo "No Static Characteristics Found" >> PerfSummary.txt
fi
echo " " >> PerfSummary.txt

## Check Performance vs Previous Test
# Using two files, check performance of file 1 against file 2 and print out warning if exceeds tolerance
File1=./Static1Heavy/Plots/results_0_0.txt
File2=./Static1Heavy/Plots/ref.txt
Tolerance=0.2 #meters
# Gleans numbers from both files and compares them
var=`awk '/Mean 3D/ {print $4}' $File1`
mean3d=`echo $var | sed 's/.*|//'`
num=$mean3d
varRef=`awk '/Mean 3D/ {print $4}' $File2`
mean3dRef=`echo $varRef | sed 's/.*|//'`
numRef=$mean3dRef
rv=`bc -l <<< "$num > ($numRef + $Tolerance)"`
# If new file is greater than reference file by more than the tolerance, warning is printed
if [ $rv -eq 1 ]
then
echo "***Warning: Mean 3D Error has increased by more than 20 cm***" >> PerfSummary.txt
echo " " >> PerfSummary.txt
fi

## Obtains Static Compiler Warnings from Wwarning.txt
echo "-----------------------Static Compiler Warnings--------------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Search for 'warning:' and print to PerfSummary.txt
grep 'warning:' ./Static1Heavy/Wwarning.txt >> PerfSummary.txt
# If there is no static compiler warning, print that to PerfSummary.txt
if [ $? -ne 0 ]
then 
echo "No Static Compiler Warnings Found" >> PerfSummary.txt
fi
echo " " >> PerfSummary.txt

## Obtains Static Valgrind Information from valwar.txt
echo "---------------------Static Valgrind Information-------------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Search for 'FILE DESCRIPTORS' and print out line to PerfSummary.txt
grep 'FILE DESCRIPTORS' ./Static1Heavy/valwar.txt >> PerfSummary.txt
# Search for line with "LEAK SUMMARY" and print out the following ten lines to PerfSummary.txt
grep -A10 'LEAK SUMMARY' ./Static1Heavy/valwar.txt >> PerfSummary.txt
# If there is no static valgrind information, print that to PerfSummary.txt
if [ $? -ne 0 ]
then 
echo "No Static Valgrind Information Found" >> PerfSummary.txt
fi
echo " " >> PerfSummary.txt

## Obtains Static Deterministic Information from DetermDyn.txt
echo "-------------------Static Deterministic Information----------------------" >> PerfSummary.txt
echo " " >> PerfSummary.txt
# Search for 'apt' and print out the following four lines to PerfSummary.txt
grep -A4 'apt' ./Static1Heavy/DetermStat.txt >> PerfSummary.txt
echo " " >> PerfSummary.txt

## Prints Completion Message
echo "#########################################################################" >> PerfSummary.txt
echo "##############Performance Characteristics Summary Complete###############" >> PerfSummary.txt
echo "#########################################################################" >> PerfSummary.txt
