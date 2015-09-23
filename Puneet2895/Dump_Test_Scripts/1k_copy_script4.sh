##############################################################################
start=`date +%s`
#echo $start
#dumps files

scp -r -C /mnt/storage/Dump4 manojgulati@192.168.10.6:Databin > /dev/null && rm -rf /mnt/storage/Dump4


end=`date +%s`
#echo $end
runtime=$((end-start))
echo 'COPY4_RT'+$runtime
##############################################################################
