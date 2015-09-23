##############################################################################
start=`date +%s`
echo $start
#dumps files

scp -r -C /mnt/storage/Dump8 manojgulati@192.168.10.6:Databin > /dev/null && rm -rf /mnt/storage/Dump8


end=`date +%s`
echo $end
runtime=$((end-start))
echo $runtime
##############################################################################
