#!/bin/bash
#################################################
#      		Start12h			#
# 						#
# Introduction:					#
# 12 Hour overnight test that test gps receiver	#
# Pyxis for coding issues: like gcc warnings,	#
# Valgrind leaks and doxygen comment warnings.	#
# It also checks for gps-performance: accuracy	#
# and accessibility.				#
#						#
# Method:					#
# Starts the current build of Pyxis by first	#
# running the Build shell script which compiles #
# pyxis for all the tests. Then	the script	#
# PyxisTestCore1 and Core2 and once Core2 is	#
# finished, it runs Performance.		#
#						#
# Input: The newest pyxis build.		#
#						#
# Output: Summary.txt and performance plots	#
#################################################

# Change to Test directory
cd /home/dma/Documents/Test

## Print time of starting operation to Summary.txt and terminal
echo 'Pyxis Test was started at the local time of:' > output/Summary.txt
date >> output/Summary.txt
echo 'Pyxis Test was started at the local time of:' `date`

## Change to ShScripts directory and start Build.sh
cd ShScripts
gnome-terminal -x ./Build.sh

sleep 5s

echo "Waiting for Build.sh to finish..."
# Keep checking whether Build is running, if so then wait
while [ `pgrep -c Build.sh` -gt 0 ]
	do
	sleep 1s
done
echo "Pyxis builds are complete"

## Starts PyxisTestCore1.sh
gnome-terminal -x ./PyxisTestCore1.sh

## Starts Core2.sh
gnome-terminal -x ./Core2.sh

sleep 3s

echo "Waiting for Core 1, 2 and 3 to finish..."
# Keep checking whether Core1 is running, if so then wait
while [ `pgrep -c PyxisTestCore1` -gt 0 ] || [ `pgrep -c Core2` -gt 0 ] #||  `pgrep -c Core3` -gt 0 ]
	do
	sleep 1s
done

## Print all cores completed message to terminal
echo "All cores are completed"

## Save Pyxis test completion time to Summary.txt
echo 'Pyxis Test was finished at the local time of:' >> ../output/Summary.txt
date >> ../output/Summary.txt

## Run Performance.sh once all cores are completed # What is it? Some echo regarding what is happening?
./Performance.sh

## Print finished Pyxis test message to terminal
echo "Test is finished"
sleep 3s
