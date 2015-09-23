##############################################################################
start=`date +%s`
echo $start
#dumps 100 files

a=1
while [ "$a" -lt 20001 ]  
do 
 touch /mnt/storage/Dump1/"tmp_1_$a".csv
 a=`expr $a + 1`
done

b=1
while [ "$b" -lt 20001 ]  
do 
 touch /mnt/storage/Dump2/"tmp_2_$b".csv
 b=`expr $b + 1`
done

c=1
while [ "$c" -lt 10001 ]  
do 
 touch /mnt/storage/Dump3/"tmp_3_$c".csv
 c=`expr $c + 1`
done

end=`date +%s`
echo $end
runtime=$((end-start))
echo $runtime
##############################################################################

#copies those 100 files, when you are on host machine

#a=1
#while [ "$a" -lt 101 ]  
#do 
#  pscp -pw root root@192.168.1.100:/mnt/"tmp$a".csv /tmp/
# a=`expr $a + 1`
#done

################################################################################
