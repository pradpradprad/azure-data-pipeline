# 🚀 Azure Data Pipeline

This project leverages Azure Lakehouse architecture to build a data pipeline for generating reports.

## ✨ Overview

The data pipeline is designed to perform incremental extraction of sales data. It follows the Medallion architecture to store data at each stage and supports dashboard to visualize sales trends and top-performing products.

### Objectives

- Leverage Lakehouse architecture to design and automate a data pipeline using Azure services.
- Develop a dimensional data model to support analytical queries.
- Build interactive dashboard to visualize key business metrics.

## 🏗️ Architecture

1. **Data Extraction:** `Microsoft SQL Server` is used as the source to store chocolate store sales data. `Azure Data Factory` runs `SQL` queries to extract the data and stores it as `Parquet` files.

2. **Data Storage:** `Azure Data Lake Storage Gen 2` is used to store data across the bronze, silver, and gold layers, following the Medallion architecture.

3. **Data Transformation:** `Azure Databricks` is used to clean and transform data between layers.

4. **Data Visualization:** `Power BI` is used to create dashboard that visualize sales performance and key insights.

5. **Pipeline Orchestration:** Use `Azure Data Factory` to automates the entire data pipeline.

6. **Data Quality:** `DQX Data Quality Framework` is used to validate data quality at each transformation stage.

7. **Secret Management:** Use `Azure Key Vault` to stores and manages secrets used within the pipeline.

![architecture](docs/image/architecture.JPG)

*Pipeline Architecture*

## 🛠️ Pipeline

Activities in pipeline can be seen as shown.

![pipeline](/docs/image/pipeline.JPG)

*Pipeline*

## 🔄 Transformation

The transformation process consists of 2 stages.

1. **Bronze to Silver**

    - **Read Data:** Read raw data from bronze layer into Spark dataframe with predefined schema.

    - **Clean Data:** Remove nulls and duplicates from essential columns, convert country codes to full names, trim whitespace, and filter out negative values. Rename columns and adjust data types for numeric fields.

    - **Add Columns:** Add necessary columns such as date components, and calculate average revenue per box.

    - **Write Data:** Perform data quality checks and write the cleaned data as Parquet files to the silver layer.

    ![bronze_to_silver](/docs/image/silver_transform.jpg)

    *Data Transformation*

2. **Silver to Gold**

    This stage involves creating both dimension and fact tables.

    2.1 **Create dimension table**

    - **Read Data:** Read transformed data from silver layer into Spark dataframe with predefined schema.

    - **Create Dimension Table:** Select the required columns, identify and separate existing and new records, generate surrogate keys for new records, and combine them into a unified dataframe.

    - **Write Data:** Perform data quality checks and merge dimension data into Delta tables in gold layer.

    ![gold_dim](/docs/image/gold_dim.jpg)

    *Create Dimension Table*

    2.2 **Create fact table**

    - **Read Data:** Read transformed data from silver layer and dimension tables into Spark dataframes with predefined schema.

    - **Create Fact Table:** Join the sales data with dimension tables and select the required columns.

    - **Write Data:** Perform data quality checks and merge fact data into Delta table in gold layer.

    ![gold_fact](/docs/image/gold_fact.jpg)

    *Create Fact Table*

## 🗂️ Data Model

The data model follows a star schema design. Dimension tables include Sales person, Product, Country, and Date, while the fact table contains Revenue, Boxes Shipped, and Revenue per Box.

![data_model](docs/image/data_model.JPG)

*Data Model*

## ⚙️ Setup

Configuration details for Azure cloud services and source database can be found in the provided folders.

## 📊 Dashboard Summary

Full dashboard files located in `dashboard` folder.

- Sales peak in January and June, with a noticeable drop from February to April.

- Australia generates the highest total revenue, followed by the United Kingdom. New Zealand records the lowest revenue.

- The top 3 products by revenue are Smooth Sliky Salty, 50% Dark Bites, and White Choc.

![dashboard](docs/image/dashboard.JPG)

*Dashboard*