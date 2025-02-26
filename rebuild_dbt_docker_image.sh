#!/bin/bash
docker rmi dbt_docker_image
cd /Users/ericliao/climate_elt/dbt
docker build -t dbt_docker_image .
