#!/bin/bash
File=parking_data.csv
if [ -f "$File" ]; then
    echo "$File exist"
else 
    echo "$File does not exist"
fi
# Print all unique parking infractions
    cut -d',' -f4 "$File" | sort -u

# Function to calculate mean, min, and max of the 5th column in parking_data.csv
function calculate_statistics() {

# Initialize variables for sum, count, min, and max
    sum=0
    count=0
    min=""
    max=""

# Read the 5th column from each line and calculate statistics
    while IFS=',' read -r _ _ _ _ value _; do
        # Check if the value is numeric
        if [[ "$value" =~ ^[0-9]+$ ]]; then
            # Update sum and count
            sum=$((sum + value))
            ((count++))

            # Update min and max
            if [ -z "$min" ] || [ "$value" -lt "$min" ]; then
                min=$value
            fi

            if [ -z "$max" ] || [ "$value" -gt "$max" ]; then
                max=$value
            fi
        fi
    done < "parking_data.csv"

# Check if there were valid numeric values
    if [ "$count" -eq 0 ]; then
        echo "No valid numeric values found in the 5th column of parking_data.csv."
    else
# Calculate mean
        mean=$((sum / count))
        echo "Mean: $mean"
        echo "Min: $min"
        echo "Max: $max"
    fi
}

# Run the function to calculate statistics for the 5th column in parking_data.csv
calculate_statistics

# Function to save one type of parking infraction to a separate CSV file
cut -d',' -f2 "parking_data.csv" > "date_of_infraction.csv"

echo "Column 2 (date_of_infraction) extracted and saved to date_of_infraction.csv."