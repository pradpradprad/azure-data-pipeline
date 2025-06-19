# ⚙️ Databricks Setup

This document outlines the essential steps and components required to setup the Databricks environment for the project.

## 🏢 Workspace

- Serves as centralized development environment. We can create Databricks workspace through `Azure Resource groups` -> `Create` -> search `Azure Databricks` and provide `Workspace name`, `Region`, and `Managed Resource Group name`.

  ![workspace](/docs/image/databricks_img/create_workspace.JPG)

  *Workspace*

## 🔗 Connection

This section describes how we setup components to access data from external sources.

### Access Connector

Connect managed identities to an Azure Databricks account for the purpose of accessing data registered in Unity Catalog.

- Go to `Azure Resource groups` -> `Create` -> search `Access Connector for Azure Databricks` and provide `Name`, and `Region`.

  ![access_connector](/docs/image/databricks_img/create_access_connector.JPG)

  *Access Connector*

### Storage Credential

A credential represents an authentication and authorization mechanism for accessing stored data or services in your cloud tenant.

- Go to `Databricks Workspace Console` -> `Catalog` -> `External Data` -> `Credentials` -> `Create Credential` then provide `Credential name`, and `Access connector ID`.

- We create only 1 Storage Credential since we use the same storage account for all containers.

  ![storage_credential](/docs/image/databricks_img/create_storage_credential.JPG)

  *Storage Credential*

### External Location

An external location allows you to access your data stored in cloud storage (e.g. Azure Data Lake Storage). You will need the cloud storage path and a paired credential (e.g. managed identity) which gives access to that path.

- Go to `Databricks Workspace Console` -> `Catalog` -> `External Data` -> `External Locations` -> `Create external location` then provide `External location name`, `Storage type` (we use ADLS), `URL`, and `Storage credential`.

- We create 3 External Locations for bronze, silver, and gold container.

  ![external_location](/docs/image/databricks_img/create_external_location.JPG)

  *External Location*

## 📚 Metastore

A metastore is the top-level container for catalog in Unity Catalog. Within a metastore, Unity Catalog provides a 3-level namespace for organizing data: catalogs, schemas (also called databases), and tables / views.

- We create metastore through `Databricks Account Console` -> `Catalog` -> `Create metastore` and provide `Name`, `Region`, `ADLS Gen 2 path`, and `Access Connector Id` then assign it to your Databricks workspace with `Workspace name` (make sure to create ADLS container for metastore)

  ![metastore](/docs/image/databricks_img/create_metastore.JPG)

  *Metastore*

## 🖥️ Cluster

The compute engine for running notebooks.

- We can create through `Databricks Workspace Console` -> `Compute` -> `Create compute` provide settings as shown (make sure you have `Unity Catalog` enabled in `Summary` box)

- Install DQX data quality framework package into cluster you have created by go to `Libraries` -> `Install new` then select `Library Source` as `PyPI`, and `Package` as `databricks-labs-dqx==0.4.0`.

  ![cluster](/docs/image/databricks_img/create_cluster.JPG)

  *Cluster Settings*

  ![package](/docs/image/databricks_img/install_package.JPG)

  *Package*

## 🔑 Access Token

Create access token to use Databricks with Azure Data Factory pipeline.

- Go to `Account Settings` -> `Developer` -> `Access tokens` -> `Generate new token`. Copy and store it into your Azure Key Vault.

  ![access_token](/docs/image/databricks_img/create_access_token.JPG)

  *Access Token*