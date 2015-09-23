
# Script to SCP data after collecting continous stream of real time data specifically for fusion with smart meter data
# Manoj Gulati
# Energy Group
# IIIT-Delhi 


scp /mnt/storage/Plug/*.csv manojgulati@192.168.11.2:Databin/>/dev/NULL
rm -rf /mnt/storage/Plug/*.csv