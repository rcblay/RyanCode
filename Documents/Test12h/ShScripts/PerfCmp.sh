mean3dval=$1
availability=$2

# Gets rid of scientific notation
mean3dval=`echo ${mean3dval} | sed -e 's/[eE]+*/\\*10\\^/'`
availability=`echo ${availability} | sed -e 's/[eE]+*/\\*10\\^/'`

if [ $(echo "$mean3dval < 0.2" | bc -l) -eq 1 ] && [ $(echo "$mean3dval > 0" | bc -l) -eq 1 ]
	then
	mean3dval=0
fi

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






