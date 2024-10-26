variable "tags" {
  description = "A map of tags to apply to resources"
  type = map(string)
}

variable "location" {
  description = "The location to deploy the resources to"
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  nullable    = false
}

variable "key_vault_id" {
  description = "The ID of the key vault"
  type        = string
  nullable    = false
}

variable "storage_primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account"
  type        = string
  nullable    = false
}

variable "storage_account_access_key" {
  description = "The access key for the storage account"
  type        = string
  nullable    = false
}
