##############################################################################
start=`date +%s`
#echo $start
#dumps files

scp -r -C /mnt/storage/Dump6 manojgulati@192.168.10.6:Databin > /dev/null && rm -rf /mnt/storage/Dump6


end=`date +%s`
#echo $end
runtime=$((end-start))
echo 'COPY6_RT'+$runtime
##############################################################################
