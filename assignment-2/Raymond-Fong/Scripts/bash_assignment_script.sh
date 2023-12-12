
#!/bin/bash

# Assignment #1: Bash Script
### PLEASE READ AND DO THE FOLLOWING PRE-SCRIPT STEPS ###
### Set up Bash terminal to access User's Desktop:
	### cd $HOME		or 		cd $HOME/Desktop
### Create Parking Data.csv file after downloading the source dataset
	### Source dataset can be found here: https://open.toronto.ca/dataset/parking-tickets/
	### Pick one source files and make a copy of it called Parking_Data.csv
	### cp Parking_Tags_Data_2022.003.csv Parking_Data.csv



# STEP 1:  Set positional parameters for Desktop path and Parking_Data.csv file
desktop_path="$HOME/Desktop"
file="Parking_Data.csv"

# STEP 2: Verify that Parking_Data.csv file is on the Desktop
if [ ! -f "$desktop_path/$file" ]; then
	echo "Error: Parking_Data.csv file not found on Desktop"
	exit
else 
	echo "No error: Parking_Data.csv found on Desktop"
fi


# STEP 3: Define functions
## 1a) Print all unique values for parking_infraction column in Parking_Data.csv
function infraction_list {
	iu=$(cut -d\, -f4 < $file | sort | uniq | wc -l)
	iu2=$((iu - 1))
	echo "There were "$iu2" unique types of infractions. The following is a list of all infractions:"
	cut -d\, -f4 < $file | sort | uniq
	return
}


## 1b) Calculate mean, min and max values of Parking_Data.csv
function calc_mean_min_max {
	echo "This function calculates the mean, min and max values of the set_fine_amount column in $file"

	## MEAN
	## Use the awk command for text manipulation from inputted parking data file
		## SOURCE: Nathaniel Jue. How to use AWK to calculate an average. https://www.youtube.com/watch?v=cCEOrUu22pE 
	##awk -F"," 'BEGIN{sum=0}{sum=sum+$5; print sum}' $file | head
	vol_park_tickets=$(awk -F"," 'BEGIN{volume=-1}{volume+=1}END{print volume}' $file)
	echo "The number of parking tickets is: "$vol_park_tickets""
	mean_fine=$(awk -F"," 'BEGIN{sum=0; volume=-1}{sum += $5; volume += 1}END{print sum/volume}' $file)
	echo "The mean fine amount is: $"$mean_fine""
	##$(awk -F"," 'BEGIN{sum=0; volume=-1}{sum += $5; volume += 1}END{print volume, sum/volume}' $file)"
		## sum is a parameter that adds the value from set_fine_amount (Column 5) from the data to itself
		## volume is a parameter that counts the volume of rows. Volume starts at -1 because the first row is a header
		## Use sum and volume to calculate the mean parking fine amount
		## += to assign parameters sum and volume to themselves

	## MIN
	min_fine=$(cut -d\, -f5 $file | sort -n | head -1)
	echo "The minimum parking fine value is: "$min_fine""
	

	## MAX
	max_fine=$(cut -d\, -f5 $file | sort -n | tail -1)
	echo "The maximum parking fine value is: "$max_fine""
	return
}


## 1c) Creating second csv file containing only rows where infraction_code = 207, that contains only three columns:
		## parking_infraction
		## set_fine_amount
		## location2
	## Use AWK with an if command that includes only the first row (header) and infraction_code = 207
		## SOURCE: https://linuxhandbook.com/awk-if-else/
		## SOURCE: https://stackoverflow.com/questions/14971102/print-specific-field-from-first-line-in-file-using-awk
function output_file {
	awk -F"," '{if (NR==1 || $3 == "207")  {print $4","$5","$8}}' $file > $"machine_not_paid.csv"
	echo "Output only infractions where code = 207 ("PARKING MACHINE-REQD FEE NOT PAID") to separate csv."
	return
}


# STEP 4: Run functions
infraction_list
calc_mean_min_max
output_file

echo "All steps completed successfully. Check Desktop directory for machine_not_paid.csv"