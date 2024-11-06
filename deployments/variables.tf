variable "subscription_id" {
  description = "The subscription ID to use for the Azure provider"
  type        = string
  sensitive   = true
  nullable    = false

  validation {
    condition     = length(var.subscription_id) == 36
    error_message = "Subscription ID must be 36 chars long"
  }
}

variable "location" {
  description = "The location to deploy the resources to"
  default     = "norwayeast"
  type        = string

  validation {
    condition     = can(regex("norwayeast|northeurope|westeurope", var.location))
    error_message = "Location must be norwayeast, northeurope or westeurope"
  }
}

variable "mssql_administrator_login" {
  description = "The administrator login for the SQL server"
  type        = string
  nullable    = false
}

variable "mssql_administrator_login_password" {
  description = "The administrator login password for the SQL server"
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