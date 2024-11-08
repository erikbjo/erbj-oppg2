output "admin_login" {
  description = "The administrator login for the SQL server"
  value       = module.db.admin_login
}

output "admin_password" {
  description = "The administrator login password for the SQL server"
  value       = module.db.admin_password
  sensitive   = true
}
