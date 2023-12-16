# Parking Data Processing Script

This repository contains a Bash script for processing parking infraction data from city of Toronto as a CSV file. The script provides functionalities to analyze parking infractions data, including listing types of infractions, calculating statistics of fines, and saving specific infraction records to a separate file.

## Features

The script includes the following features:

1. **List Infraction Types**: Prints all unique types of parking infractions from the CSV file.
2. **Fine Statistics**: Calculates and prints the mean, minimum, and maximum of the set fine amounts.
3. **Save Specific Infraction to File**: Saves records of a specific parking infraction type to a separate CSV file.

## Requirements

- Bash shell
- `parking_data.csv`: A CSV file containing parking infraction data.

## Usage

1. **List Infraction Types**
   - Run the script to list all types of parking infractions.
2. **Fine amount Statistics**
   - The script will automatically calculate and display statistics of the set fine amounts.
3. **Save Specific Infraction**
   -  it saves records of "PARK PROHIBITED TIME NO PERMIT".

## File Structure

- `csv_file`: Path to the CSV file containing parking data.
- `infraction_desc_col`, `fine_amount_col`, `location2_col`: Column positions in the CSV for infraction description, set fine amount, and location respectively.

## Source and References

This script uses standard Bash scripting techniques and Unix commands. Key references include:

- [GNU Coreutils - uniq](https://www.gnu.org/software/coreutils/manual/html_node/uniq-invocation.html)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [GNU Awk User's Guide](https://www.gnu.org/software/gawk/manual/gawk.html)

## License

creative commons without any commericial usage.

## Contributions

Contributions to this script are welcome. Please ensure that your code adheres to the existing style and covers all necessary error handling.

---

**Note:**  Always backup your data before running the script .
