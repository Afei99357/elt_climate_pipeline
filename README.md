# ELT Pipeline for Weather Data Extraction Using Airflow and DBT

This project sets up an **ELT (Extract, Load, Transform)** pipeline to extract weather data from **Open-Meteo** using **Apache Airflow** and **DBT (Data Build Tool)**. The pipeline automates the process of fetching, transforming, and loading weather data into **DuckDB** for further analysis.

## 🚀 **Project Structure**

```
elt-weather-pipeline/
├── airflow/
│   ├── dags/
│   │   └── weather_elt_dag.py
│   └── requirements.txt
├── dbt/
│   ├── models/
│   │   └── transformations.sql
│   └── dbt_project.yml
├── README.md
└── .env
```

## ⚙️ **Prerequisites**

- Python & pip
- Open-Meteo API credentials (if required)
- DuckDB
- SQLite (for Airflow backend)

## 🔑 **Setup Instructions**

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-repo/elt-weather-pipeline.git
cd elt-weather-pipeline
```

### 2️⃣ Configure Environment Variables

Create a `.env` file:

```ini
OPEN_METEO_API_KEY=your_open_meteo_api_key
DUCKDB_PATH=./weather_data.duckdb
```

### 3️⃣ Install Dependencies

```bash
pip install -r airflow/requirements.txt
pip install dbt-core duckdb
```

### 4️⃣ Initialize Airflow with SQLite Backend

```bash
export AIRFLOW_HOME=./airflow
airflow db init
```

### 5️⃣ Run Airflow Scheduler and Webserver

```bash
airflow scheduler &
airflow webserver -p 8080
```

Access Airflow at [http://localhost:8080](http://localhost:8080) and activate the `weather_elt_dag` to start the data pipeline.

---

## 🗂️ **ELT Workflow**

1. **Extract:**

   - Fetch weather data from **Open-Meteo** using their API.

2. **Load:**

   - Load raw data into **DuckDB**.

3. **Transform:**
   - Use **DBT** to clean, transform, and model the data.

---

## 📦 **Key Files Explained**

- **`airflow/dags/weather_elt_dag.py`**: Defines the Airflow DAG for scheduling the ELT tasks.
- **`dbt/models/transformations.sql`**: Contains DBT SQL models for data transformation.
- **`.env`**: Stores environment variables like database paths and API keys.

---

## 📊 **Running DBT Transformations Manually**

Run DBT models:

```bash
dbt run
```

---

## 🔍 **Troubleshooting**

- **Check Airflow Logs:**
  ```bash
  airflow logs -f
  ```
- **Restart Airflow:**
  ```bash
  airflow db reset
  airflow db init
  ```

---

## 📝 **License**

This project is licensed under the **MIT License**.

---

## 🙌 **Contributing**

Pull requests are welcome! For major changes, open an issue first to discuss what you’d like to change.

```bash
git checkout -b feature-new
# make changes
git commit -m "Add new feature"
git push origin feature-new
```

Thank you for contributing!
