-- models/open_meteo_raw_data.sql

{{ config(materialized='table', pre_hook=["INSTALL http_client FROM community;", "LOAD http_client;"], post_hook="
insert or replace into weather_accumulation_data by name (select * exclude (status, reason) from {{this}})")}}

-- GET Request Example w/ JSON Parsing
WITH __input AS (
  SELECT
    http_get(
        'https://archive-api.open-meteo.com/v1/archive',
        headers => MAP {
          'accept': 'application/json'
        },
        params => MAP {
          'latitude':cities.latitude::string,
          'longitude':cities.longitude::string,
          'start_date':date_add(current_date, interval (-5) day)::date::string,
          'end_date':date_add(current_date, interval (-2) day)::date::string,
          'hourly':'temperature_2m,precipitation,rain,snowfall,surface_pressure,cloud_cover,wind_speed_10m,soil_temperature_0_to_7cm,soil_moisture_0_to_7cm',
          'timezone':'America/New_York'
        }
    ) AS res,
    cities.city
from cities
),
cities as (
  select 
    *
  from
    {{ref("cities_info")}}
),
cte as (
  select 
    (res->>'status')::int as status,
    (res->>'reason') as reason,
    (res->>'body')::json as res2,
    city
  from
    __input
),
__response AS (
  SELECT
    status,
    reason,
    city,
    (res2->>'latitude')::float AS latitude,
    (res2->>'longitude')::float AS longitude,
    (res2->>'generationtime_ms')::float AS generationtime_ms,
    (res2->>'utc_offset_seconds')::int AS utc_offset_seconds,
    (res2->>'timezone')::string AS timezone,
    (res2->>'timezone_abbreviation')::string AS timezone_abbreviation,
    (res2->>'elevation')::int AS elevation,
    (res2->'hourly_units')::map(string, string) AS hourly_units,
    unnest((res2->'hourly'->'time')::timestamp[]) as time,
    unnest((res2->'hourly'->'temperature_2m')::float[]) as temperature_2m,
    unnest((res2->'hourly'->'precipitation')::float[]) as precipitation,
    unnest((res2->'hourly'->'rain')::float[]) as rain,
    unnest((res2->'hourly'->'snowfall')::float[]) as snowfall,
    unnest((res2->'hourly'->'surface_pressure')::float[]) as surface_pressure,
    unnest((res2->'hourly'->'cloud_cover')::float[]) as cloud_cover,
    unnest((res2->'hourly'->'wind_speed_10m')::float[]) as wind_speed_10m,
    unnest((res2->'hourly'->'soil_temperature_0_to_7cm')::float[]) as soil_temperature_0_to_7cm,
    unnest((res2->'hourly'->'soil_moisture_0_to_7cm')::float[]) as soil_moisture_0_to_7cm
  FROM
    cte

)
SELECT
  *
FROM
  __response

  
