# git assignment1

#script is located in scripts/
#this script assumes you run the script inside the scripts folder and the parking file is located in the inputs directory
default_file_path="../inputs"
parking_csv=$default_file_path/$1 

##running the script
cd scripts/
sh assignment1.sh Parking_Tags_Data_2022.000.csv
#you will be prompted to saving one of the options to separate file: "infraction_description", "set_fine_amount", and "location2"

##output will be saved in
cd ../outputs
