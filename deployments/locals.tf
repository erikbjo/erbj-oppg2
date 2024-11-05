resource "random_string" "random_string_locals" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

locals {
  tags = {
    owner   = "erbj"
    project = "oppg2"
    client  = "OperaTerra"
  }
}
