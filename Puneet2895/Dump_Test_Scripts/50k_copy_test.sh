##############################################################################
start=`date +%s`
echo $start
#dumps files

scp -r -C /mnt/storage/Dump1 manojgulati@192.168.10.6:Databin && rm -rf /mnt/storage/Dump1


end=`date +%s`
echo $end
runtime=$((end-start))
echo $runtime
##############################################################################
