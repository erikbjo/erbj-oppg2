output "mssql_server_principal_id" {
  description = "The principal ID of the SQL Server"
  value       = azurerm_mssql_server.main.identity[0].principal_id
}

output "admin_login" {
  description = "The administrator login for the SQL server"
  value       = var.mssql_administrator_login != "" ? var.mssql_administrator_login : random_string.username.result
}

output "admin_password" {
  description = "The administrator login password for the SQL server"
  value       = var.mssql_administrator_login_password != "" ? var.mssql_administrator_login_password : random_string.password.result
  sensitive   = true
}