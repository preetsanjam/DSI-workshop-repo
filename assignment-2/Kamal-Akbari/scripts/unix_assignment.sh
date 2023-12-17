#!/bin/bash

# Check if a file path is provided as a parameter
if [ "$#" -ne 1 ]; then
	echo "Only insert the directory of your csv file as parameter with this structure: $0 ~/Desktop/parking_data.csv"
	exit 1
fi

# Assign the first parameter to a variable
input_file="$1"

# Check if the file exists or the directory is correct
if [ ! -f "$input_file" ]; then
	echo "File not found in this directory: $input_file"
	exit 1
fi


# Read and process the input file
echo "Input file: $input_file"
# Add your data processing commands here. For now, just printing the file content.
head -n 5 "$input_file"


#Function for infraction analysis
infraction_analysis() {
	echo "Types of Infractions:"
	cut -d, -f4 "$input_file" |sort|uniq


	echo "Fine Statistics:"

# Calculate and print mean, min, max of set fine amount
awk -F, 'NR > 1 {sum+=$5; if(min=="" || $5<min) min=$5; if(max=="" || $5>max) max=$5} END {print "Mean:", sum/(NR-1), "Min:", min, "Max:", max}' "$input_file"


# Save a specific type of infraction to a separate CSV file

infraction_type="PARK IN PARK NOT IN DESIG AREA" 
# Extracting infraction_description, set_fine_amount, location2 columns from parkin_toronto.csv
awk -F, -v infraction="$infraction_type" 'BEGIN {OFS=FS} NR==1 || $4==infraction {print $4, $5, $8}' "$input_file" > output.csv

}


infraction_analysis

## Sources

# for awk I used this address:  https://unix.stackexchange.com/questions/558270/how-to-get-max-min-and-mean-from-values-in-column-
# https://unix.stackexchange.com/questions/710558/output-in-csv-format-using-awk-command
# I used chatGPT for some of the technical issues