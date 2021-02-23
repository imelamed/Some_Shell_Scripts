#!/bin/bash
#
#This script is to check ethernet interface status at ifconfig&ethtool&mii-tool
 
printf "Interface\tIP-Address\tEthtool-Link\tEthtool-speed&duplex\t Mii-Status\n" >> /home/lala.txt
count=$(/sbin/ifconfig -a | grep eth -c)
#echo $count
let count=count-1
#echo $count
 
for ((  i = 0 ;  i <= count;  i++  ))
do
ipaddr=$(/sbin/ifconfig eth$i | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
lstat=$(/sbin/ethtool eth$i | grep 'Link detected:' | cut -d: -f2 | awk '{ print $1}')
ethspe=$(/sbin/ethtool eth$i | grep 'Speed:' | cut -d: -f2 | awk '{ print $1}')
ethdup=$(/sbin/ethtool eth$i | grep 'Duplex:' | cut -d: -f2 | awk '{ print $1}')
miistat=$(/sbin/mii-tool eth$i | grep eth$i: | cut -d: -f2)
 
if [[ $ipaddr ]]
then
  if [[ $ethdup == 'Unknown!' ]]
    then
     printf "eth$i\t-\t$ipaddr\t$lstat\t\t$ethspe-$ethdup\t$miistat \n" >> /home/lala.txt
    else
     printf "eth$i\t-\t$ipaddr\t$lstat\t\t$ethspe-$ethdup\t\t$miistat \n" >> /home/lala.txt
  fi
else
  if [[ $ethdup == 'Unknown!' ]]
    then 
     printf "eth$i\t-\t$ipaddr\t\t$lstat\t\t$ethspe-$ethdup\t$miistat \n" >> /home/lala.txt
    else
     printf "eth$i\t-\t$ipaddr\t\t$lstat\t\t$ethspe-$ethdup\t\t$miistat \n" >> /home/lala.txt
  fi
fi
done
 
more /home/lala.txt
rm -f /home/lala.txt
exit
