#!/bin/bash

# This script prints unique infractions, basic descritpive parking ticket statistics, and outputs data for "PARK - LONGER THAN 3 HOURS" infraction to a separate csv file 

parking_data=$(locate $1) #passes a csv file to a locate command so the script can be run from any location


# function Infraction prints uniqe infractions

function infraction {
        # we use awk to find column positon of "infraction_description"
        column_name1="infraction_description"
        column_position1=$(awk -F',' '{
                for (i = 1; i <= NF; i++) {
                        if ($i == "'"$column_name1"'") {
                                print i;
                                exit;
                        }
                }
        }' $parking_data)
        # we use column position to extract infractions
        cut -d',' -f"$column_position1" < $parking_data | sort | uniq
}

# this function performs calculations on the column "set_fine_amount"

function fine_amount {
        # we use awk to find column position of column "set_fine_amount"
        column_name2="set_fine_amount"
        column_position2=$(awk -F',' '{
                for (i = 1; i <= NF; i++) {
                        if ($i == "'"$column_name2"'") {
                                print i;
                                exit;
                        }
                }
        }' $parking_data)
        # we use awk to loop through the column to find min, max, and count and then use sum and count to find mean 
	awk -v col="$column_position2" 'BEGIN {FS=","; sum=0; count=0} NR > 1 {
    		value = $col;
    		if (value > max || NR == 2) max = value;
    		if (value < min || NR == 2) min = value;
		sum += $col;
		count++;
		mean = sum / count	
	}
	END {
    		print "Max: ", max;
    		print "Min: ", min;
		print "Mean: ", mean;
	}' $parking_data
}

function new_csv {
        # we use awk to find column positon of "location2"
        column_name3="location2"
        column_position3=$(awk -F',' '{
                for (i = 1; i <= NF; i++) {
                        if ($i == "'"$column_name3"'") {
                                print i;
                                exit;
                        }
                }
        }' $parking_data)
	
	# using awk we output columns "infraction_description, set_fine_amount, location2" for the specified infraction to a new file
	 awk -F ',' '{ if (NR==1 || $column_position1=="PARK - LONGER THAN 3 HOURS") print $column_position1, $column_position2, $column_position3 }' "$parking_data" >> new_file.csv
}


echo "Unique infractions: "
infraction
echo -e "\\nBasic parking ticket statistics: "
fine_amount
new_csv
echo -e "\\nnew_file.csv is created"


# Sources used:
# https://unix.stackexchange.com/questions/25138/how-to-print-certain-columns-by-name
# https://ronreiter.medium.com/data-science-with-bash-f83b779dfbde
# https://stackoverflow.com/questions/28905083/how-to-sum-a-column-in-awk
# https://www.youtube.com/watch?v=KZ9Oj4XZ8d8
