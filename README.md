# DSI: Unix Shell, Git and GitHub
# Assignment 2 & Quiz: Git and GitHub
The file contains a dataset `parking_data.csv` and three scripts that correspond to Unix Assignment 1.

## Input
The input file is the `parking_data.csv`. It pertains to the dataset of parking tickets issued in the City of Toronto. The dataset file will be used with the scripts in the following manner.

`unix_assignment_1_i.sh`: This script will take the dataset as the input parameter.
```
unix_assignment_1_i.sh parking_data.csv
```

`unix_assignment_1_ii.sh`: The input parameters for this script will be: the dataset, and column numbers 4 and 5. The code will be as follows:
```
unix_assignment_1_ii.sh parking_data.csv 4 5
```

`unix_assignment_1_iii.sh`: The input parameters for this script will be the parking dataset.
```
unix_assignment_1_iii.sh parking_data.csv
```

## Output
Each of the three scripts will generate an output.

`unix_assignment_1_i.sh`: This script will read the `parking_data.csv` dataset and output the entire dataset.

`unix_assignment_1_ii.sh`: This script will print all types of infraction_description in `parking_data.csv`, and mean, minimum and maximum of set_fine_amount.

`unix_assignment_1_iii.sh`: This script will output a file `extracted_entries.csv`. This file will contain one type of parking infraction (PARK IN A FIRE ROUTE), along with set_fine_amount and location2 variables from `parking_data.csv`.

## Scripts
The three scripts are `unix_assignment_1_i.sh`, `unix_assignment_1_ii.sh` and `unix_assignment_1_iii.sh`.
