#!/bin/bash
#################################################
#      		Start				#
# Starts the test by running build script.	#
#################################################

## Time of starting operation
cd /home/dma/Documents/Test/output
echo 'Pyxis Test was started at the local time of:' > Summary.txt
date >> Summary.txt

cd ../ShScripts

gnome-terminal -x ./Build.sh
