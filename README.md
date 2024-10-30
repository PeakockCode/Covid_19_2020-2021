COVID-19 Data Preparation for Analysis and Visualization.

This repository contains SQL scripts and Excel files related to the analysis and visualization of COVID-19 data from 2020 to 2021. The work is done using Microsoft SQL Server Management Studio.

Usage
1. Run the SQL scripts in the order provided to clean, explore, and prepare the data:
   - 1.Data_Cleaning_and_Exploring.sql -> Cleans and explores the data.
      - Path: sql/1.Data_Cleaning_and_Exploring.sql
   - 2.Data_Preparation_for_Visualization.sql -> Prepares the data for visualization.
      - Path: sql/2.Data_Preparation_for_Visualization.sql
    
2. Review Results: Check the generated Excel files:
   - Table_1.xlsx to Table_4.xlsx: For visualization in tools like Tableau.
      - Path: covid-19_results_tables/Table_1.xlsx - Table_4.xlsx
   - Results_of_Queries_for_Data_Exploration.xlsx: To verify the correctness of the queries.
      - Path: covid-19_results_tables/Results_of_Queries_for_Data_Exploration.xlsx

Notes
- Ensure that the SQL scripts are run in a compatible SQL environment.
- The provided Excel files facilitate easy reference of query results.
- Source files: CovidDeaths.xlsx and CovidVaccinations.xlsx.
   - Path: source_tables/CovidDeaths.xlsx or CovidVaccinations.xlsx
