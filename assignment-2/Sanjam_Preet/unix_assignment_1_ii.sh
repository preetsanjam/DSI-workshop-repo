#!/bin/bash

if [ $# -eq 0 ]; then
	            echo "Usage: $0 <csv_file> <unique_column_number> <stats_column_number>"
		                    exit 1
fi

csv_file=$1
unique_column_number=$2
stats_column_number=$3

# Check if the file exists
if [ ! -f "$csv_file" ]; then
	            echo "File not found: $csv_file"
		                    exit 1
fi

# Check if column numbers are provided
if [ -z "$unique_column_number" ] || [ -z "$stats_column_number" ]; then
	            echo "Please provide both the unique column number and the stats column number"
		                    exit 1
fi

# Find unique values in the specified column
unique_values=$(awk -F',' -v col="$unique_column_number" 'NR>1 { print $col }' "$csv_file" | sort | uniq)

echo "Unique values in column $unique_column_number:"
echo "$unique_values"

# Calculate mean, min, and max using awk

# Source: https://linuxconfig.org/calculate-column-average-using-bash-shell
mean=$(awk -F',' -v col="$stats_column_number" 'NR>1 { total += $col; count++ } END { print total / count }' "$csv_file")

# Source: https://stackoverflow.com/questions/29783990/awk-find-minimum-and-maximum-in-column
min=$(awk -F',' -v col="$stats_column_number" 'NR==2 { min = $col } $col < min && NR>1 { min = $col } END { print min }' "$csv_file")
max=$(awk -F',' -v col="$stats_column_number" 'NR==2 { max = $col } $col > max && NR>1 { max = $col } END { print max }' "$csv_file")

# Printing the mean, min and max of the specified column
echo "---------------------------------------------------------"
echo "Mean of set_fine_amount column $stats_column_number: $mean"
echo "Minimum value in set_fine_amount column $stats_column_number: $min"
echo "Maximum value in set_fine_amount column $stats_column_number: $max"

# Usage example: script_name.sh data.csv 4 5
# This will print the unique vlaues fom column 4 and also print mean, min, max from column 5 of parking_data.csv

