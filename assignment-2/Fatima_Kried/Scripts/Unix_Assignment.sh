#!/bin/bash

# Change to the directory containing the CSV file
cd /Users/fatima/desktop/Data_Science_Course

# Specify the file name with extension
parking_data_22="parking_data_22.csv"
selected_infraction="PARK ON PRIVATE PROPERTY"

# Check if the file exists 
if [ ! -f "$parking_data_22" ]; then
    echo "Error: File '$parking_data_22' not found."
    exit 1
fi

# Extracting unique parking infractions from the CSV file
infractions=$(cut -d',' -f4 "$parking_data_22" | sort -u)

# Print the unique parking infractions
echo "Parking Infractions:"
echo "$infractions"

# Function to calculate statistics for set_fine_amount (column 5) (https://pandas.pydata.org/docs/getting_started/intro_tutorials/06_calculate_statistics.html)
calculate_statistics() {
    # Extract set_fine_amount values from column 5
    fine_values=$(cut -d',' -f5 "$parking_data_22")
    
    # Calculate mean, min, and max
    mean=$(echo "$fine_values" | awk '{ total += $1 } END { print total / NR }')
    min=$(echo "$fine_values" | sort -n | head -n 1)
    max=$(echo "$fine_values" | sort -n | tail -n 1)

    # Print the results
    echo "Mean Fine Amount: $mean"
    echo "Min Fine Amount: $min"
    echo "Max Fine Amount: $max"
}

# Call the function to calculate statistics for set_fine_amount
calculate_statistics

# Creat a new CSV file for the selected infraction
output_file="selected_infraction.csv"
echo "infraction_description,set_fine_amount,location2" > "$output_file"

# Loop through the CSV file and filter rows with the selected infraction
grep "$selected_infraction" "$parking_data_22" | while IFS=, read -r col1 col2 col3 col4 col5; do
    echo "$col4,$col5,$col3" >> "$output_file"
done

# Print the content of the new CSV file
cat "$output_file"

if [ -f "$output_file" ]; then
    echo "File '$output_file' created successfully."
else
    echo "Error: File '$output_file' not created."
fi