from airflow import DAG
from datetime import datetime
from airflow.operators.bash import BashOperator
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount
from datetime import timedelta

## first dag
with DAG(
    dag_id="etl_climate",
    start_date=datetime(year=2025, month=2, day=14, hour=20, minute=0),
    schedule="@daily",
    catchup=False,
    max_active_runs=1,
    render_template_as_native_obj=True
) as dag:
    extract_data = DockerOperator(
        dag=dag,
        task_id="extract_data",
        image="dbt_docker_image",
        auto_remove='force',
        mounts=[Mount(target="/dbt_work_dir/duck_db_files", source="/Users/ericliao/climate_elt/dbt/duck_db_files", type='bind')],
        command=['uv', 'run', 'dbt', 'run', '--profiles-dir', '/dbt_work_dir', '-s', 'models/open_meteo_raw_data.sql'],
        retries = 1,
        retry_delay = timedelta(minutes=1)
    )

    build_evidence_project = BashOperator(
        dag=dag,
        task_id = 'build_evidence_project',
        bash_command = 'cd /opt/evidence_UI; npm run sources; npm run build && aws s3 sync ./build s3://liaoyunfei.name;'

    )

    extract_data >> build_evidence_project