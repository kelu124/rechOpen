##############################################################################
start=`date +%s`
#echo $start
#dumps files

scp -r -C /mnt/storage/Dump3 manojgulati@192.168.10.6:Databin > /dev/null && rm -rf /mnt/storage/Dump3


end=`date +%s`
#echo $end
runtime=$((end-start))
echo 'COPY3_RT'+$runtime
##############################################################################
