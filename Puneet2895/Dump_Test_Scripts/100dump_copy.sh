##############################################################################
start=`date +%s`
#echo $start
#dumps 100 files

# # # # Check decimation factor before running this script # # # # 

a=1
while [ "$a" -lt 101 ]  
do 
 acquire 16384 64 > /mnt/storage/Plug/"BGN1_$a".csv
 a=`expr $a + 1`
done

end=`date +%s`
#echo $end
runtime=$((end-start))
echo 'Dump'+$runtime
##############################################################################

#copies those 100 files, when you are on host machine

scp /mnt/storage/Plug/*.csv manojgulati@192.168.11.2:Databin > /dev/null
rm -rf /mnt/storage/Plug/*.csv
#mkdir /mnt/storage/Plug

#a=1
#while [ "$a" -lt 101 ]  
#do 
#  pscp -pw root root@192.168.1.100:/mnt/"tmp$a".csv /tmp/
# a=`expr $a + 1`
#done

################################################################################
