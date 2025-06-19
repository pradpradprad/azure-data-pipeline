# ⚙️ Key Vault Setup

Steps on setup Azure Key Vault to store secrets and grant permissions.

## 🧾 Secret

For Azure Key Vault, we only need 2 secrets (make sure you setup `Access Control` before creating secrets)

- Databricks access token
- SQL Server password

  ![key_vault](/docs/image/key_vault_img/key_vault.JPG)

  *Key Vault Secrets*

## 🔐 Access Control (IAM)

Add role assignment to Azure Key Vault.

![add_role](/docs/image/key_vault_img/add_role.JPG)

*Add Role Assignment*

- **Administrator:** Let user have access to create secrets.

  - Go to your `Azure Key Vault` name -> `Access Control (IAM)` -> `Add role assignment` -> in `Role` section, search for `Key Vault Administrator` -> in `Members` section, choose `User, group, or service principal` and `Select members` as your `User`.

    ![administrator_role](/docs/image/key_vault_img/admin_role.JPG)

    *Administrator Role*

    ![administrator_members](/docs/image/key_vault_img/admin_members.JPG)

    *Administrator Members*

- **Secrets User:** Let Data Factory use secrets stored in Key Vault.

  - Go to your `Azure Key Vault` name -> `Access Control (IAM)` -> `Add role assignment` -> in `Role` section, search for `Key Vault Secrets User` -> in `Members` section, choose `Managed identity` and `Select members` as your `Azure Data Factory Workspace`.

    ![user_role](/docs/image/key_vault_img/user_role.JPG)

    *Secrets User Role*

    ![user_members](/docs/image/key_vault_img/user_members.JPG)

    *Secrets User Members*