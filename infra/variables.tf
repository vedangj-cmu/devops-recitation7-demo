variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "cmu-demo-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
  # No default, forcing user/CI to provide IT or we generate one
  # For demo simplicity, we will generate a random suffix in main.tf if we were just using local,
  # but variables are better for explicit control.
  # Let's actually use a random string resource in main.tf to make it easier for the user demo
  # so they don't have to think of unique names.
}
