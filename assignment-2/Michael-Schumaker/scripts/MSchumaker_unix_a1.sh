#!/bin/bash
# UNIX Assignment 1 by Michael Schumaker
#
# First positional parameter is the file to be read
# If only a file name is given, it will be assumed to be at $HOME/Desktop
# If a file name with ./ is given, the file will be expected in the current directory
# If a full path and name is given, the file will be expected at that path
#
# function print_infraction_types prints all unique types of parking infractions
# function print_mean_min_max computes these from the set_fine_amount column
# function save_one_infraction_type saves one type of parking infraction to csv file,
# with columns set by the positional parameters

# Get a file name string by removing characters before the last "/"
function get_file_name {
   local file_string=$1
   # Are there / characters before the file name?
   local name_only=${file_string##*/}
   echo ${name_only}
}

# Get a path string by removing the file name
function get_path {
   local file_string=$1
   local name_only=${file_string##*/}
   # Remove the name from the string to get the path
   local path_only=${file_string%$name_only}
   echo ${path_only}
}

function get_column_number {
   local fname="$1"
   local chead="$2"

   # Research and code from:
   # https://stackoverflow.com/questions/32612859/bash-retrieve-column-number-from-column-name
   # https://stackoverflow.com/questions/31071432/convert-comma-separated-values-into-a-list-of-values-using-shell-script
   # Get the column headers (first row), transpose to a column, number the lines,
   # find the requested column header and get the number of that line
   local col_num=$(head -1 $fname | tr , "\n" | nl -nln | grep $chead | cut -f1)
   echo $col_num
}

function print_infraction_types {
   local source="$1"
   # Get the column number of the infraction_description
   col_num=$(get_column_number $source "infraction_description")

   # Get the col_num column, omit the header row, sort, find unique values,
   # and send to standard output one line at a time
   # Piping to while loop idea found at:
   # https://www.unix.com/shell-programming-and-scripting/68984-iteration-through-results-unix-command.html
   cut -d, -f$col_num $source | tail -n +2 | sort | uniq |
   while read -r line; do
      echo $line
   done 
}

# Print the mean, min, and max fines
function print_mean_min_max {
   local source="$1"
   # Get the column number of the set_fine_amount
   col_num=$(get_column_number $source "set_fine_amount")

   # Get the col_num column, omit the header row, save to local variable
   local fine_column=$(cut -d, -f$col_num $source | tail -n +2)

   local max
   local min
   local sum=0
   local count=0
   while read -r line; do
      # Accumulate count and sum to compute mean
      ((count++))
      ((sum+=$line))
      # If unset or empty, set max min to first value
      max=${max:-$line}
      min=${min:-$line}
      # Check each val against previous max, min
      if [[ $line -gt $max ]]; then
         max=$line
      fi
      if [[ $line -lt $min ]]; then
         min=$line
      fi
   done <<< $fine_column

   # Using awk to do floating point math:
   # https://www.baeldung.com/linux/bash-variables-division 
   local meanval=$(awk "BEGIN {print $sum/$count}")

   echo "Mean fine amount (\$): $meanval"
   echo "Min fine amount (\$): $min"
   echo "Max fine amount (\$): $max"
}

# Save one infraction type, specific columns
function save_one_infraction_type {
   local source="$1"
   local output="$2"
   local type="$3"
   # Set the number of required parameters (the three above this line)
   local num_req_params=3
   local num_cols=$(($#-$num_req_params))

   if [[ num_cols -eq 0 ]]; then
      echo "In save_one_infraction_type, no output columns have been specified. Enter at least one."
      return
   fi

   # Loop over positional parameters from:
   # https://stackoverflow.com/questions/1769140/how-to-iterate-over-positional-parameters-in-a-bash-script
   # Build the -f flag for the cut command and header row
   local f_flag="-f"
   local header_row=""
   local i=1
   for param in "$@"; do
      if [[ $i -gt $num_req_params ]]; then
	 # Add to the header row text
	 header_row=$header_row$param","
	 # Get the column number corresponding to the header
         local col_num=$(get_column_number $source $param)
         f_flag=$f_flag$col_num","
      fi
      ((i++))
   done
   # Remove the final comma from the -f string and header text
   f_flag=${f_flag:0:$((${#f_flag}-1))}
   header_row=${header_row:0:$((${#header_row}-1))}

   # Overwrite the output file contents with the header row
   echo $header_row > $output

   # Grep the rows with the chosen infraction type, cut the chosen columns, append to file
   grep "$type" "$source" | cut -d, $f_flag >> $output
}

########## MAIN ##########

# The file to read is the first positional parameter
file_param=$1

# If the parameter is empty, exit with an error message
# Researched at https://linuxhandbook.com/check-variable-empty-bash/
if [ -z $file_param ]; then
   echo "A file name or a full path with file name must be provided."
   echo "Usage: $0 <file name or full path with file name>"
   exit 1
fi

# The default location to search for the input file
default_path="$HOME/Desktop/"

# Get the path from the input if non-empty, or use default path
file_path=$(get_path $file_param)
file_path=${file_path:=$default_path}
# Get the file name from the input (assume not empty)
file_name=$(get_file_name $file_param)

full_path_and_name="$file_path$file_name"

# Verify that the file exists and is readable
# Researched at https://askubuntu.com/questions/558977/checking-for-a-file-and-whether-it-is-readable-and-writable
if ! [[ -r $full_path_and_name ]]; then
   echo "The file does not exist or cannot be read by the current user"
   exit 1
fi

# Print all types of parking infractions in the csv file
print_infraction_types $full_path_and_name

# Print the mean, min, and max fines
print_mean_min_max $full_path_and_name

# File to save single infraction type to (fire hydrant infractions)
output_file_name="blocking_fire_hydrants.csv"
output_full_path="$file_path$output_file_name"
infraction_type="PARK-WITHIN 3M OF FIRE HYDRANT"

save_one_infraction_type "$full_path_and_name" "$output_full_path" "$infraction_type" "infraction_description" "set_fine_amount" "location2"



