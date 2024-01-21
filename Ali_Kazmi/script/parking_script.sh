#!/bin/bash

Filepath="$HOME/parking_data.csv"
echo "File path provided: $Filepath"

#STEP 1
# Combined function to print unique values, mean, min, and max fine amounts
process_parking_data () {
    local file=$Filepath
    local infraction_column=4  # parking infractions are in the 4th column
    local set_fine_amount_column=5  # set_fine_amount is in the 5th column

    # Print unique parking infractions
    echo "Unique Parking Infractions:"
    cut -d, -f4 < "$Filepath" | sort | uniq 
    echo

    # Print mean fine amount
    echo -n "Mean Fine Amount: "
    awk -F, 'NR>1 {total += $5; count++} END {print total/count}' $Filepath
    echo

    # Print minimum fine amount
    echo -n "Minimum Fine Amount: "
    awk -F, 'NR>1 && NF>0 {if(min=="" || $5<min) min=$5} END {print min}' $Filepath
    echo

    # Print maximum fine amount
    echo -n "Maximum Fine Amount: "
    awk -F, 'NR>1 {if($5 > max) max=$5} END {print max}' $Filepath
    echo
}

# Call the combined function - this completes the calculations for the whole column
process_parking_data

#STEP 2
# Selecting infraction of my choice and saving its information to a new CSV file...

Filepath="$HOME/parking_data.csv"
InfractionType="PARK PROHIBITED TIME NO PERMIT"  # Selected infraction type
OutputFile="$HOME/selected_infraction.csv"

# Check if the file exists
if [[ ! -f "$Filepath" ]]; then
    echo "File not found: $Filepath"
    exit 1
fi

# Extract specific columns and save to a new CSV file
awk -F, -v infraction="PARK PROHIBITED TIME NO PERMIT" 'BEGIN {OFS=FS} NR==1 {print $4, $5, $8} $4 == infraction {print $4, $5, $8}' "$Filepath" > "$OutputFile"
echo "Saved infraction data to $OutputFile"

# Function to process each line of the new CSV

process_line() {
    local infraction_description=$1
    local fine_amount=$2
    local location2=$3

    # To prevent the repeated display of processed infraction info in BASH script
    if [[ -z ${processedLines["$line"]} ]]; then
        processedLines["$line"]=1
        echo "Processing: $infraction_description, Fine: $fine_amount, Location: $location2"
    fi
    }


# Reading the new file line by line and to display in Ubuntu
while IFS=, read -r infraction_description fine_amount location2; do
    # Skips the header line in my new CSV file
    if [[ $infraction_description != "infraction_description" ]]; then
        process_line "$infraction_description" "$fine_amount" "$location2"
    fi
done < "$OutputFile"


# Work Cited
# Source troubleshooting OFS w/ AWK command; 
# https://stackoverflow.com/questions/55877410/understanding-how-ofs-works-in-awk

# Source for determing min/max formulas
# https://community.unix.com/t/awk-to-print-field-from-lookup-file-in-output/362134

# Source for parsing commands regarding repeating process lines
# https://copyprogramming.com/howto/easy-way-to-parse-stdout-from-terminal

































