variable "subscription_id" {
  validation {
    condition     = length(var.subscription_id) == 36
    error_message = "Subscription ID must be 36 chars long"
  }
  description = "The subscription ID to use for the Azure provider"
  sensitive   = true
  nullable    = false
}

variable "location" {
  description = "The location to deploy the resources to"
  default     = "norwayeast"
}