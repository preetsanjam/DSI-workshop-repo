#!/bin/bash

#Assignment 1: Unix and Data

# parse parking_data.csv as positional parameter from terminal
#build a function or multiple function into the script that:
#a) Prints all types of parking infractions (infraction_description) #col 4
#b) Prints the mean, min and max set_fine_amount - these calculations can either be in the same function or multiple functions
#c) Saves one type of parking infraction of your choosing to a separate csv file (this file should contain all observations of the chosen infraction_description, set_fine_amount, and location2 with the same headings as original csv)
#The script should be able to navigate to the directory housing the csv file

# assumes file is located in ~/Desktop/ default path for macos
#default_file_path=~/"Desktop"
# assumes file is in ../inputs
default_file_path=$PWD/../inputs
# default output location
default_out_path=$PWD/../outputs
parking_csv=$default_file_path/$1 
#parking_csv=$1
echo $parking_csv
#check input file
if [ ! -e "$parking_csv" ]; then
    echo $parking_csv do not exist! Check your path.
    exit 1
fi

#function to print set_fine_amount summary
#expects set_fine_amount is in column 5
run_summary() {

    local _input_=$1

    #sum numbers in file
    #https://stackoverflow.com/questions/2702564/how-can-i-quickly-sum-all-numbers-in-a-file
    _sum_=$(awk -F "," '{ sum += $5 } END { print sum }' $_input_)
    
    #get total number of lines. Minus header then get number of rows from wc
    _count_=$(($(wc -l $_input_ | awk '{print $1}') - 1)) # 
    #mean
    _mean_=$(( $_sum_ / $_count_))
    #min
    _min_=$(cut -d, -f5 $_input_ | sort | head -1)
    #max
    _max_=$(cut -d, -f5 $_input_ | sed '1d' | sort -r | head -1)

    ##output#
    echo Mean: $_mean_
    echo Min: $_min_
    echo Max: $_max_

}

#function to extract column from input file based on user choice
extract_column(){
    local input_file=$1

    #save parking infraction of your choosing to separate csv file.
    echo 'Saving one of the options to separate file: "infraction_description", "set_fine_amount", and "location2"'
    read choice

    echo you have entered "$choice"

    #check if choice is one of the allowed columns
    if [[ "$choice" =~ ^(infraction_description|set_fine_amount|location2)$ ]]; then
        #get row number with grep https://stackoverflow.com/questions/3213748/get-line-number-while-using-grep
        choice_col=$(head -1 $input_file | sed 's/,/\n/g' | grep -w -n $choice | cut -d: -f1)

        echo output to $default_out_path/$choice".out"
        #get column based on user's choice
        awk -v colnum="$choice_col" -F "," '{print $colnum}' $input_file > $default_out_path/$choice".out"
    else
        echo choice is not valid! Must be one of "infraction_description", "set_fine_amount", and "location2"
        exit 1
    fi


}

#Prints all types of parking infractions (infraction_description)
echo Printing \"infraction_description\"
cut -d, -f4 $parking_csv | sort | uniq | head

#run number summary
run_summary $parking_csv

extract_column $parking_csv
