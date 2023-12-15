#!/bin/bash

data=() 
# Ideas and code from here: https://www.baeldung.com/linux/source-include-files
file=../inputs/Test_parking_data_1001_slice.csv
# Function to read the CSV file and store the data in an array
read_csv() {
  while IFS=, read -r line; do
    data+=("$line")
  done < "$file"
}

# a) Function to print all types of unique categories stored in column infraction_description (parking infractions)
## Code and ideas from: https://stackoverflow.com/questions/57585770/bash-for-loop-skip-first-element-of-array
print_categories() {
  categories=()
  for row in "${data[@] : 1}"; do
    category=$(echo "$row" | cut -d, -f4)
    if [[ ! " ${categories[@]} " =~ " $category " ]]; then
      categories+=("$category")
    fi
  done

  echo "#############################################"

  for category in "${categories[@]}"; do
    echo "$category"
  done
}

# b) Function to calculate the mean, max and min values in column set_fine_amount
## Ideas from: https://unix.stackexchange.com/questions/13731/is-there-a-way-to-get-the-min-max-median-and-average-of-a-list-of-numbers-in
## is a variable a number? https://www.geeksforgeeks.org/how-to-check-if-a-variable-is-a-number-in-bash/
## decimal presicion in bash (bc): https://unix.stackexchange.com/questions/175744/bash-limiting-precision-of-floating-point-variables
calculate_statistics() {
  sum=0
  max=0
  min=9999999
  for row in "${data[@]}"; do
    value=$(echo "$row" | cut -d, -f5)
    if [[ $value =~ ^[0-9]+$ ]]; then
      sum=$((sum + value))
      if ((value > max)); then
        max=$value
      fi
      if ((value < min)); then
        min=$value
      fi
    fi
  done
  mean=$(echo "scale=2; $sum / ${#data[@]}" | bc)
  echo "#############################################"
  echo "Mean of column set_fine_amount:"
  echo "$mean"
  echo "Maximum value of column set_fine_amount:"
  echo "$max"
  echo "Minimum value of column set_fine_amount:"
  echo "$min"
  echo "#############################################"
}

# Function to save one type of (user-defined) category stored in column infraction_description in a separate CSV file
## code and ideas from: https://stackoverflow.com/questions/9533679/how-to-insert-a-text-at-the-beginning-of-a-file

save_category() {
  category=$1
  filtered_data=()
  header=""

  # Extract header
  ## Sugestion from ChatGPT3.5, how to paste the header back in the saved array and save the corresponding CSV?
  
  # Extract header
  for ((i = 0; i < 1; i++)); do
    header="${data[i]}"
  done

  for row in "${data[@]}"; do
    if [[ $(echo "$row" | cut -d, -f4) == "$category" ]]; then
      filtered_data+=("$row")
    fi
  done
  
  output_file="../outputs/${category// /_}.csv"
  echo "Saving category $category to $output_file"
  > "$output_file"

  # Include header in the output file 
  ## This is what ChatGPT3.5 suggested
  echo "$header" | awk -F ',' '{print $4","$5","$8}' >> "$output_file"
  
  # Save filtered data to the output file only columns infraction_description, set_fine_ammount, location2
  for row in "${filtered_data[@]}"; do
    echo "$row" | awk -F ',' '{print $4","$5","$8}' >> "$output_file"
  done
}

# Read the CSV file
read_csv $file
# Print all the infraction names, stored in parking infractions
print_categories

# Perform the required statistics:
calculate_statistics
 
# Save one type of (user-defined) category stored in column 3 in a separate CSV file
## 
read -p "Enter the category to save: " category
save_category "$category"
