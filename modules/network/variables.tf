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

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  nullable    = false
}

variable "subnet_name_prefix" {
  description = "The prefix to use for naming subnets, will create one main and one app subnet"
  type        = string
  nullable    = false
}
