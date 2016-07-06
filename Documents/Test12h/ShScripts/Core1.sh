#!/bin/bash
#################################################
#      		   Core 1			#
# Tests the current build of Pyxis for the	#
# ARM test and gives results as plots from 	#
# matlab and other info regarding execution of 	#
# the file.					#
#						#
# Input: Raw Intermediate Frequency (IF) files  #
#	that are static, dynamic, real and	#
#	complex, and apt and rnx binaries. 	#
#						#
# Output:  MATLAB plots, DetermARM.txt		#
#################################################

loc=`pwd`

cd /6TB/nfsshare
# Configuring ARM for pyxis test
my_ip=128.138.253.34
arm_ip=128.138.253.182
path_to_nfsshare=/6TB/nfsshare
path_to_largeFiles=/tmp/largeFiles
password="root"
mount_command="mount $my_ip:$path_to_nfsshare /archive"

echo 'cleaning up old keys'
ssh-keygen -R $arm_ip
ssh-keyscan $arm_ip

echo 'connecting to arm, creating archive'
sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip 'mkdir /archive'

echo 'linking nfsshare to archive'
sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip 'umount -f /archive'
sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip $mount_command

echo 'creating lookup tables'
sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip 'mkdir /tmp/largeFiles'
sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip 'mkdir /tmp/largeFiles/LookupTables'

echo 'copying lookup tables over to arm'
sshpass -p $password scp $path_to_largeFiles/LookupTables/* root@$arm_ip:/tmp/largeFiles/LookupTables/
echo 'running pyxis on zed board'

# Save run time to times.txt
STARTTIME=$(date +%s)
sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip '/archive/pyxis &> /archive/screenout.txt'
ENDTIME=$(date +%s)
diff=$(($ENDTIME-$STARTTIME))
cd $loc
echo "MAX2769 Sampfreq:6864e6 52min ARM Static: $diff" >> ../output/times.txt
cd /6TB/nfsshare

while [ true ]
	do
	cmp nightly-results/REFtimingaptBinaries_0_0.bin nightly-results/timingaptBinaries_0_0.bin > nightly-results/DetermARM.txt
	cmp nightly-results/REFtimingrnxBinaries_0_0.bin nightly-results/timingrnxBinaries_0_0.bin >> nightly-results/DetermARM.txt
	if ! [ -s nightly-results/DetermARM.txt ]
		then
		break
	else
		mv nightly-results/timingaptBinaries_0_0.bin nightly-results/REVISEDtimingaptBinaries_0_0.bin
		mv nightly-results/timingrnxBinaries_0_0.bin nightly-results/REVISEDtimingrnxBinaries_0_0.bin
		sshpass -p $password ssh -o StrictHostKeyChecking=no root@$arm_ip '/archive/pyxis &> /dev/null'
		cmp nightly-results/REVISEDtimingaptBinaries_0_0.bin nightly-results/timingaptBinaries_0_0.bin > nightly-results/DetermARM2.txt
		cmp nightly-results/REVISEDtimingrnxBinaries_0_0.bin nightly-results/timingrnxBinaries_0_0.bin >> nightly-results/DetermARM2.txt
		break
	fi
done
cd $loc
cd ../MATLAB

sed -i "/fileStr =/c\fileStr = 'timingrnxBinaries_0_0.bin';" AnalysisRNXScript1.m
sed -i "/parentpath =/c\parentpath = '\/6TB\/nfsshare\/nightly-results\/';" AnalysisRNXScript1.m
sed -i "/plotpath =/c\plotpath = '\/6TB\/nfsshare\/nightly-results\/Plots\/';" AnalysisRNXScript1.m
sed -i "/truthStr = /c\truthStr = {};" AnalysisRNXScript1.m
sed -i "/ResY = /c\ResY = importWeek('\/6TB\/nfsshare\/nightly-results\/Plots/ResY.txt');" SaveResultsDHT.m
sed -i "/ResW = /c\ResW = importWeek('\/6TB\/nfsshare\/nightly-results\/Plots/ResW.txt');" SaveResultsDHT.m

# Run matlab
/usr/local/MATLAB/R2016a/bin/matlab -nodesktop -r "run AnalysisRNXScript1.m; exit;"

## Time when Core 1 was finished is printed to Summary.txt
cd ../output
echo 'Core 1 was done at the local time of:' >> Summary.txt
date >> Summary.txt

## Core1 completion message printed to terminal
echo "Core 1 is finished"
sleep 3s
