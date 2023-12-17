#!/bin/bash


# Requirment 1 setting Parking-data2.csv as positional parameter where the file is on desktop

#googling how to check if file exists in bash in a path
#https://www.cyberciti.biz/tips/find-out-if-file-exists-with-conditional-expressions.html

file=$1

if [ ! -f "$file" ] ;then
    echo "File '$file' exist."
 else 
    echo "File '$file' does not exist" >&2
fi

# in the command line run ./assignment_1_script.sh /Desktop/parking-data.csv (which is the path to the file)

# Requirment 2a)

function print_infraction {
    local file=~/Desktop/parking-data2.csv
    echo "all types of parking infractions:"
    cut -d, -f4 "$file" | sort | uniq
}
# call the Function print_infraction to be reflected in command line
print_infraction

# Requirement 2b) finding min and max set_fine_amount
#found on https://stackoverflow.com/questions/29783990/awk-find-minimum-and-maximum-in-column
# a non awk answer 

file=~/Desktop/parking-data2.csv

cut -d, -f5 "$file" | sort -n | { 
    read line
    echo "min_set_fine_amount=$line"
    while read line; do max=$line; done
    echo "max_set_fine_amount=$max"
}

# Requirment 2b) finding mean of set_file_amount
#https://riptutorial.com/awk/example/11443/compute-the-average-of-values-in-a-column-from-tabular-data

(awk -F',' '{ sum += $5 } END { print(sum / NR) }' "$file")


#Requirement 2c)

# create new file to include chosen infraction_description with all observations in infraction_description ,set_fine_amount and Location_2 as headings as original csv file

# creating a new csv file
touch PARK_ON_PRIVATE_PROPERTY.csv



# Function to update the new csv file with the three desired headings from original csv file(parking-data2.csv)
# https://www.unix.com/shell-programming-and-scripting/177749-put-header-text-file-all-column.html

function new_output_file {

   echo "infraction_description,set_fine_amount,location2" >> PARK_ON_PRIVATE_PROPERTY.csv

}

# call the function new_output_file to create the file with the three chosen headers
new_output_file



function chosen_infraction_file { 
    #creating local varaibles in the function and infraction_description as positional parameter and input and out put files paths to be used in the loop 
    local infraction_description=$1
    local output_file="PARK_ON_PRIVATE_PROPERTY.csv"
    local input_file=~/Desktop/parking-data2.csv

# using a loop to update the newly created file with data in the three required columns
# https://stackoverflow.com/questions/32067361/how-to-extract-the-nth-column-of-csv-file-with-condition-in-linux-bash

    while IFS=, read  col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11; do 
        if [ "$col4" == "$infraction_description" ];then 
            echo "$col4,$col5,$col8" >> "$output_file"
        fi
    done < "$input_file"

}

#call the function with one type of praking infraction (PARK ON PRIVATE PROPERTY) 
chosen_infraction_file "PARK ON PRIVATE PROPERTY"


