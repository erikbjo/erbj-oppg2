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

variable "subnet_id" {
  description = "The ID of the subnet to deploy a private endpoint to"
  type        = string
  nullable    = false
}

variable "vnet_id" {
  description = "The ID of the virtual network to deploy a dns zone to"
  type        = string
  nullable    = false
}

variable "vnet_link_name" {
  description = "The name of the virtual network link"
  type        = string
  nullable    = false
}

variable "private_endpoint_name" {
  description = "The name of the private endpoint"
  type        = string
  nullable    = false
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  nullable    = false
}
