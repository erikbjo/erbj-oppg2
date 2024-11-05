output "mssql_server_principal_id" {
  description = "The principal ID of the SQL Server"
  value  =    azurerm_mssql_server.main.identity[0].principal_id
}
