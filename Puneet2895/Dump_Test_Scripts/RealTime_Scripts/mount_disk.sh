echo 'Welcome to Redpitaya!!'
echo 'Disk mount initiated on 16GB microSD'


mkdir /mnt/storage
mount -rw -t vfat /dev/mmcblk0p2 /mnt/storage


echo 'Disk mount completed!!' 
