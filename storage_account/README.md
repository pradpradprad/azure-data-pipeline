# ⚙️ Storage Account Setup

Document shows components that we need to setup for the storage account.

## 🗄️ Storage Account

- Create by go to `Azure Resource groups` -> `Create` -> search `Storage account` and provide `Storage account name`, `Region`, `Primary service` as `Azure Blob Storage or Azure Data Lake Storage Gen 2`, in `Advanced` enable `Hierarchical Namespace`.

  ![storage_account](/docs/image/storage_account_img/storage_account.JPG)

  *Storage Account*

  ![hierarchical_namespace](/docs/image/storage_account_img/hierarchical_namespace.JPG)

  *Hierarchical Namespace*

## 📦 Container

- We need to create 4 containers for the project. `Bronze`, `Silver`, `Gold`, and `Metastore` container as shown.

  ![container](/docs/image/storage_account_img/container.JPG)

  *Container*

## 🔐 Access Control (IAM)

Add role assignment to storage account to allow access from Databricks Access Connector.

- Go to `Access Control (IAM)` -> `Add` -> in `Role` section, search for `Storage Blob Data Contributor` -> in `Members` section, choose `Managed identity` and `Select members` as your `Databricks Access Connector`.

  ![role](/docs/image/storage_account_img/role.JPG)

  *Role*

  ![members](/docs/image/storage_account_img/members.JPG)

  *Members*