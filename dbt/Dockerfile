from ghcr.io/astral-sh/uv:python3.12-bookworm-slim

workdir /dbt_work_dir

copy . .

run UV_SYSTEM_PYTHON=1 uv sync