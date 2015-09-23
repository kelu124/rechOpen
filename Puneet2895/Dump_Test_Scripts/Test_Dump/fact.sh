#!/bin/bash

d=`date +%s`
echo $d
counter=$1 #first argument
d=$((d+counter))
echo $d
factorial=1
while [ $counter -gt 0 ] #while counter > 0
do
   factorial=$(( $factorial * $counter ))
   counter=$(( $counter - 1 ))
done
echo $factorial

