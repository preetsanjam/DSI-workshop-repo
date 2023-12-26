#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 1 ]; then
	            echo "Usage: $0 input_csv_file"
		                    exit 1
fi

# Input CSV file
input_file=$1

# Output CSV file
output_file="extracted_entries.csv"

# Specific entry to extract from column 4
target_entry="PARK IN A FIRE ROUTE"

# Extracting specific entry from column 4 and two other columns (assuming columns are comma-separated)
awk -F ',' -v target="$target_entry" '$4 == target {print $4 " , " $5 " , " $8}' "$input_file" > "$output_file"

echo "Specified columns extracted. Results saved in $output_file"

# Usage example: ./script_name.sh data.csv
# This will save the three columns in extracted_entries.csv file

# Source: https://unix.stackexchange.com/questions/543149/extract-columns-from-csv-to-a-text-file
# Source: https://stackoverflow.com/questions/67917217/how-to-extract-column-from-csv-file-using-terminal
