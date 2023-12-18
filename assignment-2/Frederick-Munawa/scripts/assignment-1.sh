#!/bin/bash

#This script was created using sample code snippets from ChatGPT

# Print everything under the infraction_description column
function infraction {
    echo "Content of $csv_file:"
    cut -d, -f4 < $csv_file
    return
}

#Calculate and print the mean, min and max set_fine_amount. "NR" is used to omit headers from the calculation 
function stats {
    mean=$(awk -F',' 'NR>1 {sum += $5} END {print sum/(NR-1)}' "$csv_file")
    min=$(awk -F',' 'NR>1 {if (NR==2 || $5 < min) min=$5} END {print min}' "$csv_file")
    max=$(awk -F',' 'NR>1 {if (NR==2 || $5 > max) max=$5} END {print max}' "$csv_file")
    
# Print the results
    echo "Mean: $mean"
    echo "Min: $min"
    echo "Max: $max"
    return
}

#Save infraction code 29 to a separate csv file in the outputs folder with a "-1" suffix in the file name
function save {
    new_csv_file="$HOME/Desktop/DSI-workshop-repo/outputs/$(basename "$csv_file" .csv)"-1".csv"
    echo "Saving content to $new_csv_file"
    awk -F',' 'NR==1 || $3 == "29" {print}' $csv_file > $new_csv_file
    return
}

#Main program starts here

# Check whether a CSV file has been provided as a positional parameter
if [ $# -eq 0 ]; then
    echo "Provide csv file name as follows: $0 <csv_file>"
    exit 1
fi

# Get the CSV file path from the command line argument
csv_file="$1"

# Check whether the file exists
if [ ! -f "$csv_file" ]; then
    echo "Error: File not found - $csv_file"
    exit 1
fi

#Check whether the file is in the inputs folder
desktop_path="$HOME/Desktop/DSI-workshop-repo/inputs"

if [ ! -f "$desktop_path/$(basename "$csv_file")" ]; then
    echo "Error: File not found in the inputs folder - $csv_file"
    exit 1
fi


#Run the 3 functions
infraction
stats
save

#Confirm everything has executed as planned
echo "Script completed successfully."

