#!/bin/bash

#DSI: Unix Shell, Git and GitHub 
#Assignment 1: Unix and Data


parking_data=$1


function prints_infraction () {

	echo -e '\n2. a) Prints all types of parking infractions\n'
	cut -d, -f4 $parking_data | sort | uniq
	
}
 

function set_fine_amount () {

	#MEAN : The mean is the average value in the column. It is the sum of each value divided by the number of values

	#We must subtract 1 from the number_of_fine_entries to account for the column title which isn't 
	#an applicable value but is still included in the word count

	num_of_fine_entries=$(( $(( $(cut -d, -f5 $parking_data | wc -w))) -1 ))

	# https://opensource.com/article/19/11/loops-awk#:~:text=There%20are%20two%20kinds%20of,while%20the%20test%20is%20true.&text=Another%20kind%20of%20for%20loop,of%20commands%20for%20each%20index.
	sum_of_fine_entries=$(awk -F, '{total+=$5}END{print total}' $parking_data)
	
	echo -e '\n2. b) Prints the mean, min and max set_fine_amount\n\nMean set_fine_amount is: $'$((sum_of_fine_entries/num_of_fine_entries))

	#MIN : The min is the lowest value in the column

	min_fine_entry=$(cut -d, -f5 $parking_data | sort -n | uniq | head -n 1)
	echo 'Min set_fine_amount is: $'$min_fine_entry

	#MAX : The max is the largest value in the column

	max_fine_entry=$(cut -d, -f5 $parking_data | sort -n | uniq | tail -n 1)
	echo 'Max set_fine_amount is: $'$max_fine_entry

}


function create_new_file () {


	collection_file=file.csv

	while read -r line; do

		if [[ $line = *"PARK-SIGNED HWY-EXC PERMT TIME"* ]]; then

			echo $line >> $collection_file
		
		fi

	done < $parking_data

	cut -d, -f4,5,8 $parking_data | head -n 1 > ./output/new_file.csv
	cut -d, -f4,5,8 $collection_file >> ./output/new_file.csv
	rm $collection_file

	echo -e "\n2. c) new_file.cvs was created in folder\n"

}




prints_infraction $parking_data
set_fine_amount $parking_data
create_new_file $parking_data

