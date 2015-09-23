##############################################################################
start=`date +%s`
echo $start
#dumps files

scp -r -C /mnt/storage/Dump3 manojgulati@192.168.10.6:Dustbin && rm -rf /mnt/storage/Dump3


end=`date +%s`
echo $end
runtime=$((end-start))
echo $runtime
##############################################################################
