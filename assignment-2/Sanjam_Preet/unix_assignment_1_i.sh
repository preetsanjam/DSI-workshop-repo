#!/bin/bash

parking_data=$1
echo "print all the lines"
while read -r line; do
	        echo $line
done < "$parking_data"

# Usage example: ./script_name.sh data.csv
# This will print the parking dataset

# Source: https://www.baeldung.com/linux/csv-parsing
