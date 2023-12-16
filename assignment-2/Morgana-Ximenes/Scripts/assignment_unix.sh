#!/bin/bash

# Get the CSV file path from the command-line arguments
# reference: https://github.com/UofT-DSI/01-shell_git_github/blob/main/slides/markdown/unix_slides.md
csv_file="$1"

# If the path is relative, assume it is on the Desktop
if [[ ! "$csv_file" = /* ]]; then
    csv_file="$HOME/Desktop/$csv_file"
fi

# Function that prints all types of parking infractions (infraction_description)
# https://www.shell-tips.com/bash/how-to-parse-csv-file/#gsc.tab=0
#https://stackoverflow.com/questions/13434260/loop-through-csv-file-and-create-new-csv-file-with-while-read

function infractions() {
  while IFS=, read -r _ _ _ infraction_description _ ; do
   echo "$infraction_description"
  done < "$csv_file"
}

# Function that prints the mean, min and max set_fine_amount - these calculations can either be in the same function or multiple functions
# Reference: https://stackoverflow.com/questions/3122442/how-do-i-calculate-the-mean-of-a-column (answer 103)
# Reference: https://stackoverflow.com/questions/8402919/how-to-make-grep-select-only-numeric-values
function calc() {
  
   mean=$(awk -F ',' '{ sum += $5} END { print sum/NR }' "$csv_file")
   min=$(cut -d ',' -f 5 "$csv_file" | grep -E '^[0-9]+(\.[0-9]+)?$' | sort -n | head -n 1)
   max=$(cut -d ',' -f 5 "$csv_file" | sort -n | tail -n 1)


  echo " The mean for set_fine_amount is $ $mean"
  echo " The min of set_fine_amount is $ $min"
  echo " The max of set_fine_amount is $ $max"
}


# Function Saves one type of parking infraction of your choosing to a separate csv file (this file shouldcontain all observations of the chosen infraction_description, set_fine_amount, and location2with the same headings as original csv)
#https://stackoverflow.com/questions/40260548/filter-file-with-awk-and-keep-header-in-output
# reference: https://linuxize.com/post/bash-functions/

function single_infraction() {

  chosen_infraction="PARK ON PRIVATE PROPERTY"

  output_csv="$HOME/Desktop/curated_list.csv"

   (grep -E "^.*,$chosen_infraction,.*$|^.*$|^$" "$csv_file" | awk -F ',' 'NR==1 || $4 == "'"$chosen_infraction"'"') > "$output_csv"

  echo "Rows corresponding to '$chosen_infraction' saved to $output_csv"
  cat "$output_csv"
}

# Looping through functions
# Reference https://linuxsimply.com/bash-scripting-tutorial/loop/for-loop/

function_list=( "infractions" "calc" "single_infraction")
 
for func in "${function_list[@]}"; do 
  $func
done

# Another way to call functions:
#infractions
#echo " ---------------------------------------------------------"
#calc
#echo " ---------------------------------------------------------"
#single_infraction