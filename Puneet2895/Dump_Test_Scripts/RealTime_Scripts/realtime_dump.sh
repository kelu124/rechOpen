# Script to log continous stream of real time data specifically for fusion with smart meter data
# Manoj Gulati
# Energy Group
# IIIT-Delhi 
##############################################################################
start=`date +%s`
ts=`date +%s`

#echo "first echo: $ts, $start"
#dumps 100 files

# # # # Check decimation factor before running this script # # # # 

a=1
#echo "init"
while [ "$a" -lt 201 ]  
do 
# acquire 16384 64 > /mnt/storage/Plug/"$start_$a".csv
 #echo "Main"
 #touch "$start.$a".csv
 acquire 16384 64 > /mnt/storage/Plug/"$start.$a".csv
 #scp /mnt/storage/Plug/"$start.$a".csv manojgulati@192.168.11.2:Databin/>/dev/NULL
 a=`expr $a + 1`
 start=`date +%s`
 if [ $start -gt $ts ]
 then
 #	echo "Case"
 	a=1 && echo $start && ts=`date +%s`
 	#statements
 fi
done

#end=`date +%s`
#echo $end
#runtime=$((end-start))
#echo 'Dump'+$runtime
##############################################################################

#copies those 100 files, when you are on host machine

#scp -r /mnt/storage/Plug manojgulati@192.168.11.2:Databin > /dev/null
#rm -rf /mnt/storage/Plug
#mkdir /mnt/storage/Plug

#a=1
#while [ "$a" -lt 101 ]  
#do 
#  pscp -pw root root@192.168.1.100:/mnt/"tmp$a".csv /tmp/
# a=`expr $a + 1`
#done

################################################################################
