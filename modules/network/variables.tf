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
  description = "The prefix to use for naming subnets, subsequent subnets will be named <subnet_name_prefix><index>"
  type        = string
  nullable    = false
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = number
  default     = 2
  validation {
    condition     = var.subnet_count > 0
    error_message = "Subnet count must be greater than 0"
  }
  validation {
    condition     = var.subnet_count <= 255
    error_message = "Subnet count must be less than or equal to 255"
  }
}