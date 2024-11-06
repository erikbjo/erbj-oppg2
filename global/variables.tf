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