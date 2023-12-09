#!/bin/bash

# 1. Specify the desired input in the file parameter to read the parking_data.csv file
	# In the bash terminal, type ./assignment_1.sh parking_data.csv
	# The source file parking_data.csv is located in the cd parking folder
file=$1

# 2a. Print all (unique) types of parking infractions (infraction_description)
cut -d, -f4 < $1 | sort | uniq

# 2b. Print mean, min and max set_fine_amount
function stats {
	# source: https://www.baeldung.com/linux/bash-count-lines-in-file
	# counts all rows minus the first one (column name)
	count=$(awk 'END { print NR - 1 }' < $1) 	#alternatively: var1=$(wc -l < $1)
	echo count: $count

	# source: https://www.baeldung.com/linux/add-column-of-numbers
	sum=$(awk -F "," '{Total=Total+$5} END {print Total}' < $1)
	echo sum: $sum

	# source: https://linuxconfig.org/calculate-column-average-using-bash-shell
	mean=$(awk -F "," '{ total+=$5; count++ } END { print total / (count -1) }' < $1 )
	echo mean: $mean

	# source: https://stackoverflow.com/questions/16212410/finding-the-max-and-min-values-and-printing-the-line-from-a-file
	min=$(cut -f5 -d"," < $1 | sort -n | head -1)
	echo min: $min

	# source: https://stackoverflow.com/questions/16212410/finding-the-max-and-min-values-and-printing-the-line-from-a-file
	max=$(cut -f5 -d"," < $1 | sort -n | tail -1)
	echo max: $max
}
stats $1

# 2c. Save parking_infraction = 8 and export it to a new csv file
# Source: https://stackoverflow.com/questions/32067361/how-to-extract-the-nth-column-of-csv-file-with-condition-in-linux-bash
# Source: https://stackoverflow.com/questions/72646610/bash-for-loop-save-each-output-as-a-new-column-in-a-csv

echo "infraction_description,set_fine_amount,location2" > parking_infraction_8.csv
while IFS="," read col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11; do 
	if [[ "$col3" == 8 ]]; then
		echo "$col4,$col5,$col8"
	fi 
done < $1 >> parking_infraction_8.csv

echo "Data successfully exported."