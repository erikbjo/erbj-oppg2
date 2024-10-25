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

variable "keys" {
  description = "A list of keys to create in the key vault"
  type = list(string)
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy a private endpoint to"
  type        = string
  nullable    = false
}

variable "key_vault_name" {
  description = "The name of the key vault"
  type        = string
  nullable    = false
}