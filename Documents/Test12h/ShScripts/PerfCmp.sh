#!/bin/bash
#################################################
#      		   PerfCmp			#
# Checks if the performance is better, normal, 	#
# worse, or better and worse (warning).		#
#						#
# Input: the difference in mean3dval and the 	#
# 	 the difference in availability.	#
#						#
# Output:  Performance message			#
#################################################

# Takes in arguments
mean3dval=$1
availability=$2

# If either of them do not exist, return Test Not Run
if [ -v $mean3dval ] || [ -v $availability ]
	then
	echo "Test Not Run"
	exit
fi

# Gets rid of scientific notation
mean3dval=`echo ${mean3dval} | sed -e 's/[eE]+*/\\*10\\^/'`
availability=`echo ${availability} | sed -e 's/[eE]+*/\\*10\\^/'`

# If mean3dval is less than 0.2 but positive then it is set to zero since it is not that bad
if [ $(echo "$mean3dval < 0.2" | bc -l) -eq 1 ] && [ $(echo "$mean3dval > -0.2" | bc -l) -eq 1 ]
	then
	mean3dval=0
fi

# Checks whether mean3dval is better, same, or worse and then checks whether availability is
# better, same, or worse. Depending on situation, it will print out message.
if [ $(echo "$mean3dval < 0" | bc -l) -eq 1 ]
	then
	if [ $(echo "$availability <= 0" | bc -l) -eq 1 ]
		then
		echo "Better"
	elif [ $(echo "$availability > 0" | bc -l) -eq 1 ]
		then
		echo "Warning"
	fi
elif [ $(echo "$mean3dval == 0" | bc -l) -eq 1 ]
	then
	if [ $(echo "$availability < 0" | bc -l) -eq 1 ]
		then
		echo "Better"
	elif [ $(echo "$availability == 0" | bc -l) -eq 1 ]
		then
		echo "Normal"
	elif [ $(echo "$availability > 0" | bc -l) -eq 1 ]
		then
		echo "Worse"
	fi
elif [ $(echo "$mean3dval > 0" | bc -l) -eq 1 ]
	then
	if [ $(echo "$availability < 0" | bc -l) -eq 1 ]
		then
		echo "Warning"
	elif [ $(echo "$availability >= 0" | bc -l) -eq 1 ]
		then
		echo "Worse"
	fi
fi






