#!/bin/bash

#assignment 1 completed by Taslimul Hoque

# 1 accepts input of parking data file
data_file=$1
searchword="PARK ON PRIVATE PROPERTY"
locationword="2 COOPER ST"

#2a creates and outputs all unique infractions

function uniqueInfrac { 

    cut -d, -f4 < $1 | sort | uniq > uniqueInfractions.txt

    cat uniqueInfractions.txt
    wc -l uniqueInfractions.txt
    return
}

echo "Printing Unique Infractions: "
uniqueInfrac "$data_file"
#https://stackoverflow.com/questions/16212410/finding-the-max-and-min-values-and-printing-the-line-from-a-file

function max {
    touch max.txt
    cut -d, -f5 < $1 | sort -n | tail -1 > max.txt
    cat max.txt
    return
}

echo "max is:"; max "$data_file"

function min {
    touch min.txt
    cut -d, -f5 < $1 | sort -n | head -1 > min.txt
    cat min.txt

    return
}

echo "min is: "; min "$data_file"

#https://stackoverflow.com/questions/3122442/how-do-i-calculate-the-mean-of-a-column
function mean {
    touch fine_amounts.csv
    cut -d, -f5 $1 > fine_amounts.csv
    awk '{ total += $1 } END { print total/NR }' fine_amounts.csv

    return
}

echo "mean is: "; mean "$data_file"

# https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# https://www.baeldung.com/linux/ifs-shell-variable

function filterRecords {
    touch parking_infraction.txt
    while IFS=',' read -r line; do
        if [[ "$line" == *"$2"* && "$line" == *"$3"* ]]; then
            echo "$line" >> parking_infraction.txt
        fi
    done < $1
}

filterRecords $data_file $searchword $locationword

echo "Printing all parking infractions with $searchword at the location of $locationword"
cat parking_infraction.txt 