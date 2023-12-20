**Toronto Parking Data Analysis Script
Welcome to the repository for a Python script designed to analyze Toronto parking ticket data. This script provides valuable insights into parking infractions using data from the Toronto Open Data Portal.

*Features
This script offers several key functionalities:

Infraction Type Analysis: Enumerates all unique types of parking infractions (infraction_description) present in the dataset.

Statistical Insights: Computes and displays key statistics - the mean, minimum, and maximum set fine amounts (set_fine_amount).

Specific Infraction Data Extraction: Allows for the extraction of data for a chosen type of parking infraction, saving relevant records into a separate CSV file. This new file maintains the original dataset structure, focusing on fields such as infraction_description, set_fine_amount, and location2.

*Running the Program
Ensure you have input and bash file.  

rk@RK2022: ~$ bash ./parking_analysis2.sh ~/parking/Parking_Tags_Data_2022.000.csv

The output is saved in chosen_infraction.csv




