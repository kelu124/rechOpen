##############################################################################
start=`date +%s`
#echo $start
mkdir /mnt/storage/Dump1 && mkdir /mnt/storage/Dump2 && mkdir /mnt/storage/Dump3 && mkdir /mnt/storage/Dump4
mkdir /mnt/storage/Dump5 && mkdir /mnt/storage/Dump6 && mkdir /mnt/storage/Dump7 && mkdir /mnt/storage/Dump8
mkdir /mnt/storage/Dump9 && mkdir /mnt/storage/Dump10

echo 'Dump Started !!'
#dumps files

a=1
while [ "$a" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump1/"tmp_1_$a".csv
 a=`expr $a + 1`
done
sh 1k_copy_script1.sh &

b=1
while [ "$b" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump2/"tmp_2_$b".csv
 b=`expr $b + 1`
done
sh 1k_copy_script2.sh &

c=1
while [ "$c" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump3/"tmp_3_$c".csv
 c=`expr $c + 1`
done
sh 1k_copy_script3.sh &

d=1
while [ "$d" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump4/"tmp_4_$d".csv
 d=`expr $d + 1`
done
sh 1k_copy_script4.sh &

e=1
while [ "$e" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump5/"tmp_5_$e".csv
 e=`expr $e + 1`
done
sh 1k_copy_script5.sh &

f=1
while [ "$f" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump6/"tmp_6_$f".csv
 f=`expr $f + 1`
done
sh 1k_copy_script6.sh &

g=1
while [ "$g" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump7/"tmp_7_$g".csv
 g=`expr $g + 1`
done
sh 1k_copy_script7.sh &

h=1
while [ "$h" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump8/"tmp_8_$h".csv
 h=`expr $h + 1`
done
sh 1k_copy_script8.sh &

i=1
while [ "$i" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump9/"tmp_9_$i".csv
 i=`expr $i + 1`
done
sh 1k_copy_script9.sh &

j=1
while [ "$j" -lt 5001 ]  
do 
 acquire 16384 8 > /mnt/storage/Dump10/"tmp_10_$j".csv
 j=`expr $j + 1`
done
sh 1k_copy_script10.sh &

end=`date +%s`
runtime=$((end-start))
#echo $end
echo 'Dump_RT' + $runtime

##############################################################################

#copies those 100 files, when you are on host machine

#a=1
#while [ "$a" -lt 5001 ]  
#do 
#  pscp -pw root root@192.168.1.100:/mnt/"tmp$a".csv /tmp/
# a=`expr $a + 1`
#done

################################################################################
