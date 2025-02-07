-- models/copernicus_eu_raw_observations.sql

{{ config(materialized='table') }}

with raw_data as (
    select
        cast("observation_id" as integer) as observation_id,
        cast("observation_time" as timestamp) as observation_time,
        cast("temperature" as double) as temperature,
        cast("humidity" as double) as humidity,
        cast("wind_speed" as double) as wind_speed,
        cast("precipitation" as double) as precipitation,
        "station_id" as station_id,
        "station_name" as station_name
    from read_csv_auto('data/COPERNICUS_EU_RAW_OBSERVATIONS.csv', header=True)
)

select * from raw_data
