#!/usr/bin/env bash

#Creating Temp file with date,speedtest statistics, ping statistcs
date > tempm.txt
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 - | grep 'from\|Download\|Upload\|Retrieving\|Hosted' >> tempm.txt
ping 1.1.1.1 -c10 -i0.2 -q| tail -n3 >> tempm.txt
ping 8.8.8.8 -c10 -i0.2 -q| tail -n3 >> tempm.txt
ping 10.1.1.1 -c10 -i0.2 -q| tail -n3 >> tempm.txt
echo "--------------------------------------" >> tempm.txt

#export the temp file to CSV file
date=$(sed -n 1p tempm.txt)
testfrom=$(sed -n 3p tempm.txt | awk -F "from" '{print $2}')
hostedby=$(sed -n 5p tempm.txt | awk -F "by" '{print $2}')
download=$(sed -n 6p tempm.txt | awk -F ":" '{print $2}')
upload=$(sed -n 7p tempm.txt | awk -F ":" '{print $2}')
loss11=$(sed -n 9p tempm.txt | awk -F "," '{print $3}')
stat11=$(sed -n 10p tempm.txt | awk -F "=" '{print $2}' | awk -F "," '{print $1}')
loss88=$(sed -n 12p tempm.txt | awk -F "," '{print $3}')
stat88=$(sed -n 13p tempm.txt | awk -F "=" '{print $2}')
loss10=$(sed -n 15p tempm.txt | awk -F "," '{print $3}')
stat10=$(sed -n 16p tempm.txt | awk -F "=" '{print $2}')
echo "$date,$testfrom,$hostedby,$download,$upload,$loss11,$stat11,$loss88,$stat88,$loss10,$stat10" >> netmesure.csv

#Saving the temp file in permanent file
cat tempm.txt >> netmesurescores.txt
