#!/bin/bash

echo "
Suzanne's assignment 1 for the DSI: Introduction to Unix Shell, Git, and GitHub is starting..."

# Specify the file path
file="parking_data.csv"

# test-file: Evaluate the status of a file and check that it exists
function checkfile {
    echo "
First the script will evaulate the status of the file and check that it exists:"
    if [ -e "$file" ]; then
        if [ -f "$file" ]; then
            echo "$file is a regular file"
        fi
        if [ -d "$file" ]; then
            echo "$file is a directory"
        fi
    else
        echo "$file does not exist"
        exit 1
    fi
}

# Print all types of parking infractions
function infractions {
	echo "
Now the script will print all the types of parking infractions in the file:"
	echo | cut -d',' -f4 < "$file" | sort | uniq
}

# Print the max fine amount from column 5
function meanminmax {
    echo "
Now the script will calculate the max, min and mean of all parking infractions in the file:"
    awk -F ',' '
        NR > 1  {
            if (min == "" || $5 < min) {
                min = $5
            }
            if ($5 > max) {
                max = $5
            }
        sum += $5
    }
    END {
        print "The maximum fine for all parking infractions is:", max
        print "The minimum fine for all parking infractions is:", min
        print "The mean fine for all parking infractions is:", sum / NR
  }' $file
  return
}

# Save the parking infractions related to time with the infraction_description, set_fine_amount, and location2 (fields 4, 5, and 8) headings from the original file to a seperate csv file
function infactionTIME {
    echo "
Now the script will create a new csv file named 'parking_data_time.csv' in the directory that will only contain parking 
infractions related to time, with the 'infraction_description', 'set_fine_amount', and 'location2' headings from the original file:"
    echo | cut -d',' -f4,5,8 < "$file" | cat | grep -e 'TIME' -e 'infraction_description' > parking_data_time.csv
    return
    }

checkfile
infractions
meanminmax
infactionTIME

# Prepared by: Suzanne Michie Chalambalacis on 7 Dec 2023

# Source: git_slides.pdf from https://github.com/UofT-DSI/01-shell_git_github/tree/main/slides/pdf
# Source: https://opensource.com/article/19/11/loops-awk#:~:text=Awk%20scripts%20have%20three%20main,functions%20run%20for%20each%20record.
# Source: https://unix.stackexchange.com/questions/558270/how-to-get-max-min-and-mean-from-values-in-column-4
# Source: https://unix.stackexchange.com/questions/641219/using-awk-how-can-i-find-the-max-value-in-a-column-then-print-a-different-fiel