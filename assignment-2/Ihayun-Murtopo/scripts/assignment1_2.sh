#!/bin/bash

# 1 Download file and move from download folder to Desktop and rename one of file
cd ~/Downloads/parking-tickets-2022
cp Parking_Tags_Data_2022.001.csv ~/Desktop/parking_data.csv
cd ~/Desktop

# 2a Print all types of parking Infractions (infraction_description) 
cut -d, -f4 < ./parking_data.csv | sort | uniq > assignment1_2.csv

# 2b Print only set_fine_amount column as well as calculating mean, min, and max 
rm assignment1_2.csv

## citation to sort from lowest value: # https://linuxhint.com/sort-bash-column-linux/
## citation to not include heading: https://unix.stackexchange.com/questions/96226/delete-first-line-of-a-file
### citation for min, max, and mean: https://www.d0wn.com/using-awk-to-display-the-min-the-max-and-the-average-of-a-list/

cut -d, -f5 < ./parking_data.csv | tail -n +2 | sort > assignment1_2.csv 

cat assignment1_2.csv | awk '{
	if(min==""){min=$0; max=$0};
	if($0>max) {max=$0}; 
	if($0<min) {min=$0}; 
	total+=$0; count+=1;
} END {print "avg " total/count," | max "max," | min " min}' assignment1_2.csv

# 2c Saves one type of parking infractions to your choosing to a separate csv file, infraction_description, set_fine_amount, and location2

cd ~/Downloads/parking-tickets-2022
cp Parking_Tags_Data_2022.002.csv ~/Desktop/parking_data2.csv
cd ~/Desktop

cut -d, -f4,5,8 < ./parking_data2.csv | uniq > assignment1_3.csv






