##############################################################################
start=`date +%s`
#echo $start
#dumps files

scp -r -C /mnt/storage/Dump2 manojgulati@192.168.10.6:Databin > /dev/null && rm -rf /mnt/storage/Dump2


end=`date +%s`
#echo $end
runtime=$((end-start))
echo 'COPY2_RT'+$runtime
##############################################################################
