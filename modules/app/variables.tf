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

variable "service_plan_name" {
  description = "The name of the service plan"
  type        = string
  nullable    = false
}

variable "linux_web_app_name" {
  description = "The name of the app service"
  type        = string
  nullable    = false
}

variable "worker_count" {
  description = "The number of workers to use in the service plan"
  type        = number
  default     = 3
  validation {
    condition     = var.worker_count > 2
    error_message = "Worker count must be greater than 2"
  }
  validation {
    condition     = var.worker_count <= 20
    error_message = "Worker count must be less than or equal to 20"
  }
}

variable "application_port" {
  description = "The port the application listens on"
  type        = number
  default     = 8080
  validation {
    condition     = var.application_port > 1024
    error_message = "Application port must be greater than 1024"
  }
  validation {
    condition     = var.application_port < 65535
    error_message = "Application port must be less than 65535"
  }
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy the app into"
  type        = string
  nullable    = false
}

variable "subnet_prefix" {
  description = "The prefix of the subnet to allow access from"
  type        = string
  nullable    = false
}

variable "public_ip_name" {
  description = "The name of the public IP address"
  type        = string
  nullable    = false
}

variable "app_gateway_name" {
  description = "The name of the application gateway"
  type        = string
  nullable    = false
}
