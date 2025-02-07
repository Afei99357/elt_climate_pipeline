# Weather Observations DBT Project

This project ingests weather observation data from a CSV file into a DuckDB table named `COPERNICUS_EU_RAW_OBSERVATIONS` using DBT.

## Project Structure

- **models/**: Contains DBT models. The model `copernicus_eu_raw_observations.sql` loads CSV data.
- **data/**: Place your CSV file (`COPERNICUS_EU_RAW_OBSERVATIONS.csv`) in this folder. The DuckDB database file will also be stored here.
- **dbt_project.yml**: DBT project configuration.
- **profiles.yml**: DBT profile configuration for DuckDB.
- **Dockerfile**: Docker configuration to build and run this project.

## Usage

1. **Prepare the CSV file:**  
   Place your CSV file (with headers matching the schema below) at `data/COPERNICUS_EU_RAW_OBSERVATIONS.csv`.

2. **Build the Docker image:**

   ```bash
   docker build -t weather-dbt .
