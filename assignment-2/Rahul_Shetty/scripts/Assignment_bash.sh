
# Home work Assignment No 1.
#!/bin/bash

# CSV file path
csv_file="parking_data.csv"

# Column positions for 'infraction_description', 'set_fine_amount', and 'location2'
infraction_desc_col=4
fine_amount_col=5
location2_col=8

# a) Function to print all types of parking infractions
print_infraction_types() {
    echo "Infraction Types:"
    cut -d, -f$infraction_desc_col "$csv_file" | sort | uniq
}

# b) Function to print mean, min, and max of set_fine_amount
print_fine_statistics() {
    awk -F, 'BEGIN {sum=0; count=0; min=0; max=0} NR>1 {sum+=$'$fine_amount_col'; if(min==0 || $'$fine_amount_col'<min) min=$'$fine_amount_col'; if($'$fine_amount_col'>max) max=$'$fine_amount_col'; count++} END {if(count>0) print "Mean:", sum/count, "\nMin:", min, "\nMax:", max}' "$csv_file"
}

# c) Function to save specific infraction type to a separate CSV file
save_specific_infraction() {
    local infraction_type="$1"
    local output_file="/mnt/c/Users/rahul/specific_infraction.csv" # Updated  for user 'rahul'
    echo "Saving records of infraction type '$infraction_type' to $output_file"
    # Print headers for selected columns
    head -n 1 "$csv_file" | cut -d, -f$infraction_desc_col,$fine_amount_col,$location2_col > "$output_file"
    # Add matching rows for selected columns
    awk -F, -v type="$infraction_type" -v col=$infraction_desc_col -v OFS=',' '{if(NR>1 && $col == type) print $'$infraction_desc_col','$'$fine_amount_col','$'$location2_col'}' "$csv_file" >> "$output_file"
}

# Final  execution
print_infraction_types
print_fine_statistics
save_specific_infraction "PARK PROHIBITED TIME NO PERMIT" # csv file type

#Source
# https://www.gnu.org/software/coreutils/manual/html_node/uniq-invocation.html
# Advanced Bash-Scripting Guide- https://tldp.org/LDP/abs/html/
# https://www.gnu.org/software/gawk/manual/gawk.html
