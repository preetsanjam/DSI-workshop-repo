#!/bin/bash

# Function to print all types of parking infractions
function print_infractions {
    local infraction_descriptions=()
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10
    do
        # Skip the header row
        if [[ $col4 != "infraction_description" ]]; then
            # Check if the infraction description is not already in the array
            if [[ ! " ${infraction_descriptions[@]} " =~ " ${col4} " ]]; then
                infraction_descriptions+=("$col4")
            fi
        fi
    done < "$1"

    # Print unique infraction descriptions
    for description in "${infraction_descriptions[@]}"
    do
        echo "$description"
    done | sort -u
}

# Function to calculate and print mean, min, and max of set_fine_amount
function fine_stats {
    local min=99999
    local max=0
    local sum=0
    local count=0
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10
    do
        if [[ $col5 != "set_fine_amount" && $col5 =~ ^[0-9]+$ ]]; then
            sum=$((sum + col5))
            ((count++))
            if ((col5 < min)); then min=$col5; fi
            if ((col5 > max)); then max=$col5; fi
        fi
    done < "$1"
    local mean=$((sum / count))
    echo "Mean: $mean, Min: $min, Max: $max"
}

# Function to save a specific type of infraction to a separate CSV file
function save_specific_infraction {
    local chosen_infraction="PARK - LONGER THAN 3 HOURS"
    local header_written=false
    while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10
    do
        if [[ $header_written == false ]]; then
            echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10" > chosen_infraction.csv
            header_written=true
        fi
        if [[ $col4 == "$chosen_infraction" ]]; then
            echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10" >> chosen_infraction.csv
        fi
    done < "$1"
}

# Main execution
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [CSV file path]"
    exit 1
fi

file="$1"
if [ ! -f "$file" ]; then
    echo "File not found!"
    exit 1
fi

echo "Infraction Types:"
print_infractions "$file"

echo -e "\nFine Stats:"
fine_stats "$file"

echo -e "\nSaving specific infraction data to chosen_infraction.csv"
save_specific_infraction "$file"
