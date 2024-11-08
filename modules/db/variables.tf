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

variable "mssql_administrator_login" {
  description = "The administrator login for the SQL server, uses a random login if not set"
  type        = string
}

variable "mssql_administrator_login_password" {
  description = "The administrator login password for the SQL server, uses a random password if not set"
  type        = string
  sensitive   = true
}

### Storage
variable "storage_primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account"
  type        = string
  nullable    = false
}

variable "storage_account_access_key" {
  description = "The access key for the storage account"
  type        = string
  nullable    = false
}

### Network
variable "subnet_id" {
  description = "The ID of the subnet to deploy the private endpoint to"
  type        = string
  nullable    = false
}

### Resource names
variable "private_endpoint_name" {
  description = "The name of the private endpoint"
  type        = string
  nullable    = false
}

variable "mssql_server_name" {
  description = "The name of the SQL server"
  type        = string
  nullable    = false
}

variable "mssql_database_name" {
  description = "The name of the SQL database"
  type        = string
  nullable    = false
}