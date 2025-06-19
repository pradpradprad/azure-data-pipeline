# ⚙️ Data Factory Setup

This gives the guideline on using Azure Data Factory in the project.

## 🏢 Workspace

- Create by going to `Azure Resource groups` -> `Create` -> search `Data Factory` and provide `Name`, `Region`.

  ![workspace](/docs/image/data_factory_img/workspace.JPG)

  *Workspace*

## 🔄 Integration Runtime

The integration runtime (IR) is the compute infrastructure to provide the following data integration capabilities across different network environment.

- We need to download and install self-hosted integration runtime on our computer to use SQL Server with pipeline.

- Go to `Manage` -> `Integration runtimes` -> `New` -> `Azure, Self-Hosted` -> `Self-Hosted` -> provide `Name` and create. Then download and install into your computer.

  ![self-hosted](/docs/image/data_factory_img/ir.JPG)

  *Self-Hosted Integration Runtime*

## 🔗 Linked Service

To add linked service in your Data Factory Studio, go to `Manage` -> `Linked services`. Make sure to `Test connection` before creating linked service.

### Key Vault Linked Service

- Settings as shown, we create this for retrieving secrets from `Azure Key Vault`.

  ![key_vault_linked_service](/docs/image/data_factory_img/linked_service_key_vault.JPG)

  *Key Vault Linked Service*

### Databricks Linked Service

- Settings as shown, we use existing databricks cluster that we created and provide `Access Token` through `Azure Key Vault` secret.

  ![databricks_linked_service](/docs/image/data_factory_img/linked_service_databricks.JPG)

  *Databricks Linked Service*

### Azure Data Lake Storage Gen 2 Linked Service

- Settings as shown, we use this for data extraction to bronze layer.

  ![adls_linked_service](/docs/image/data_factory_img/linked_service_adls.JPG)

  *ADLS Linked Service*

### SQL Server Linked Service

- Settings as shown, make sure you installed `Self-Host Integration Runtime` to connect to your on-premise SQL Server database. Then provide `SQL Server password` through `Azure Key Vault` secret.

  ![sql_server_linked_service](/docs/image/data_factory_img/linked_service_sql_server.JPG)

  *SQL Server Linked Service*

## 🛠️ Pipeline

Create new pipeline through `Author` -> `Pipelines` -> click on action button then `New pipeline`.

### Dataset

To create new dataset, go to `Author` -> `Datasets` -> click on action button then `New dataset`.

- **SQL Server Table:** Select `SQL Server` and settings as shown.

  ![sql_server_table_dataset](/docs/image/data_factory_img/dataset_sql_server_table.JPG)

  *SQL Server Table Dataset*

- **Bronze Layer:** Select `Azure Data Lake Storage Gen2` -> `Parquet` and settings as shown.

  - Create parameter for `year`, `month`, and `day`. We use this parameters to name a folder when doing data extraction.

  - For `File path` we use `bronze / raw_data/@{dataset().year}/@{dataset().month}/@{dataset().day}`.

    ![bronze_layer_dataset](/docs/image/data_factory_img/dataset_bronze_layer.JPG)

    *Bronze Layer Dataset*

    ![bronze_layer_parameter](/docs/image/data_factory_img/dataset_bronze_layer_parameter.JPG)

    *Bronze Layer Parameter*

### Pipeline Parameter

- Create `storage_account` parameter and provide your `Storage Account Name`.

  ![pipeline_parameter](/docs/image/data_factory_img/pipeline_parameter.JPG)

  *Pipeline Parameter*

### Activity

This part will go deep into each activity in pipeline and their settings.

- **Query last load:** Query and return last extraction date.

  ```sql
  SELECT Date AS min_date
  FROM Sales.Watermark_Table;
  ```

  ![query_last_load](/docs/image/data_factory_img/activity_query_last_load.JPG)

  *Query Last Load*

- **Query max date:** Query and return max date of sales table to be reference for data extraction.

  ```sql
  SELECT
      MAX(Date) AS max_date,
      YEAR(MAX(Date)) AS max_year,
      MONTH(MAX(Date)) AS max_month,
      DAY(MAX(Date)) AS max_day
  FROM Sales.Chocolate_Sales;
  ```

  ![query_max_date](/docs/image/data_factory_img/activity_query_max_date.JPG)

  *Query Max Date*

- **Copy from DB to bronze:** Copy sales data from SQL Server to bronze layer using outputs from previous activities and create separate year, month, and day folder in sink.

  - **Source**

    ```sql
    SELECT *
    FROM Sales.Chocolate_Sales
    WHERE
        Date > '@{activity('Query last load').output.value[0].min_date}' AND
        Date <= '@{activity('Query max date').output.value[0].max_date}';
    ```

    ![copy_source](/docs/image/data_factory_img/activity_copy_data_source.JPG)

    *Copy Source*

  - **Sink**

    ```
    year = @activity('Query max date').output.value[0].max_year
    month = @activity('Query max date').output.value[0].max_month
    day = @activity('Query max date').output.value[0].max_day
    ```

    ![copy_sink](/docs/image/data_factory_img/activity_copy_data_sink.JPG)

    *Copy Sink*

- **Update last load:** Update last load date with stored procedure (make sure to add `last_load_date` parameter)

  ```
  last_load_date = @activity('Query max date').output.value[0].max_date
  ```

  ![update_last_load](/docs/image/data_factory_img/activity_update_last_load.JPG)

  *Update Last Load*

- **Create catalog:** Create catalog in Databricks, provide your `Databricks Linked Service` and `Notebook path`.

- **Data Processing Notebooks:** The rest of activities are `Silver notebook` to clean data from bronze. Then `Dimension notebooks` and `Fact notebook` activities to create star schema. Provide `Databricks Linked Service` and `Notebook path` in setting, then in `Base parameters` provide parameters as shown.

  ```
  storage_account = @pipeline().parameters.storage_account
  year = @string(activity('Query max date').output.value[0].max_year)
  month = @string(activity('Query max date').output.value[0].max_month)
  day = @string(activity('Query max date').output.value[0].max_day)
  ```

  ![notebook_parameter](/docs/image/data_factory_img/activity_notebook_parameter.JPG)

  *Notebook Parameter*

## ⚠️ Important Note

To copy data as Parquet file from on-premise to ADLS with Self-hosted integration runtime, please follow requirements in this link. https://learn.microsoft.com/en-us/azure/data-factory/format-parquet#using-self-hosted-integration-runtime