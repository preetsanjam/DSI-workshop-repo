# Git Assignment

The purpose of the script is to process Parking*.csv data file and perform data manipulation as per user's instruction.

## Folder structure
```
.
├── README.md
├── inputs
│   └── Parking_Tags_Data_2022.000.csv
├── outputs
└── scripts
    └── assignment1.sh

4 directories, 3 files

```
## Run script
assignment1.sh is located in scripts/\
```
cd scripts/
sh assignment1.sh Parking_Tags_Data_2022.000.csv
```
You will be prompted to saving one of the options to separate file: "infraction_description", "set_fine_amount", and "location2"

Note: This script assumes you are running the script inside the scripts folder and the parking file is located in the inputs directory

```
default_file_path="../inputs"
parking_csv=$default_file_path/$1 
```

## Output
output will be saved in outputs/

```
cd ../outputs
```
