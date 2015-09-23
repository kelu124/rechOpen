##############################################################################
start=`date +%s`
#echo $start
#dumps files

scp -r -C /mnt/storage/Dump5 manojgulati@192.168.10.6:Databin > /dev/null && rm -rf /mnt/storage/Dump5


end=`date +%s`
#echo $end
runtime=$((end-start))
echo 'COPY5_RT'+$runtime
##############################################################################
