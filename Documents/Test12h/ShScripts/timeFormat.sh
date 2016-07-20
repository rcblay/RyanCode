#!/bin/bash
#################################################
#      		   timeFormat			#
# Takes in time as seconds and outputs it into	#
# hh:mm:ss format. Also has capability for +/-	#
# being placed at the beginning of the time.	#
#						#
# Input: time in seconds			#
#						#
# Output:  time in hh:mm:ss with +/- possible	#
#################################################

# Takes in arguments
diff=$1
plmi=$2
h="h"
m="m"
s="s"

# If there is nothing inputted then it returns dashed line
if [ -v $diff ] || [ $diff == "-" ]
	then
	echo "--------"
	exit
fi

# If it is less than zero, then it adds a minus sign to the beginning
if [ $diff -lt 0 ]
	then
	diff=`expr -1 \* $diff`
	plmi=-
fi
# Finds exactly how many hours, minutes, and seconds there are
hours=$(($diff / 3600))
min=$(($(($diff / 60)) % 60))
sec=$(($diff % 60))
# If either hours, minutes, or seconds are less than ten then it adds a zero for formatting
if [ $hours -lt 10 ]
	then
	hours=0$hours
fi
if [ $min -lt 10 ]
	then
	min=0$min
fi
if [ $sec -lt 10 ]
	then
	sec=0$sec
fi
# Returns it in the correct format
echo "$plmi$hours$h:$min$m:$sec$s"
