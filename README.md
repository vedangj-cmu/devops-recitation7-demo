# Azure Terraform Demo

## Pipeline
The GitHub Actions workflow (`.github/workflows/deploy.yml`) has two main stages:
1.  **Plan**: Generates a Terraform execution plan (`terraform plan`) and saves it as an artifact.
2.  **Deploy**: Pauses for **manual approval** (via GitHub Environments), then applies the plan (`terraform apply`) and uploads the `index.html` file to the static website container.

## Initial Setup
*   **Infrastructure**: Ensure you have a **Self-Hosted Runner** authenticated to Azure.
*   **Backend**: Manually create an Azure Storage Account and Container for the Terraform state.
*   **Secrets**: Configure `BACKEND_RESOURCE_GROUP`, `BACKEND_STORAGE_ACCOUNT`, and `BACKEND_CONTAINER_NAME` in GitHub Actions secrets.
*   **Environment**: Create a `production` environment in GitHub settings and add required reviewers for the manual approval step.

## Terraform State & Blob Lease

### How are we storing state?
We use the **Azure Standard Backend**. The `terraform.tfstate` file is stored securely as a blob in the Azure Storage Container you configured in the secrets. This allows the state to be shared across CI/CD runs and team members.

### What happens if we delete the storage account?
**Critical State Loss.** If the backend storage account is deleted, Terraform loses its knowledge of the infrastructure it created.
*   Terraform will think *nothing* exists.
*   The next `apply` will attempt to create all resources again.
*   This will likely fail due to naming conflicts (as the resources actually still exist in Azure) or result in duplicate resources.

### What is a blob lease?
A **Blob Lease** is a temporary lock on the state file.
*   When Terraform starts an operation (like `plan` or `apply`), it acquires a lease (lock) on the state blob.
*   **Purpose**: It prevents concurrent operations. If two pipelines run at the same time, the second one will fail to get the lease and stop, preventing them from overwriting each other's changes and corrupting the state.
