variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
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

variable "subnet_id" {
  description = "The ID of the subnet to deploy the private endpoint to"
  type        = string
  nullable    = false
}

variable "private_endpoint_name" {
  description = "The name of the private endpoint"
  type        = string
  nullable    = false
}
