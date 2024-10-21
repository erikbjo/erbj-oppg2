variable "tags" {
  description = "A map of tags to apply to resources"
  type = map(string)
}

variable "location" {
  description = "The location to deploy the resources to"
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
  default     = 2
  validation {
    condition     = var.worker_count > 0
    error_message = "Worker count must be greater than 0"
  }
  validation {
    condition     = var.worker_count <= 20
    error_message = "Worker count must be less than or equal to 20"
  }
}