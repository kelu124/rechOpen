##############################################################################
start=`date +%s`
echo $start
#dumps 100 files

a=1
while [ "$a" -lt 101 ]  
do 
 acquire 16384 8 > /mnt/"tmp$a".csv
 a=`expr $a + 1`
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
