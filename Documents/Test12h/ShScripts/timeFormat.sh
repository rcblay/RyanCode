#STARTTIME=$(date +%s)
#ENDTIME=$(date +%s)
#diff=$(($ENDTIME-$STARTTIME))
diff=$1
plmi=$2
hours=$(($diff / 3600))
min=$(($(($diff / 60)) % 60))
sec=$(($diff % 60))
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

echo "$plmi$hours:$min:$sec"
