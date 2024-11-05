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

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  nullable    = false
}
