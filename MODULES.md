# Modules

This project is divided into modules, each representing a different part of the infrastructure. The modules are:

## Network

The network module is responsible for creating the network infrastructure. This includes the following resources:

- vnet
- subnet
- network security group

### Variables

The network module has the following variables:

- tags - A map of tags to apply to all resources
- location - The location to deploy the resources
- resource_group_name - The name of the resource group
- vnet_name - The name of the virtual network
- subnet_name_prefix - The prefix for the subnet name

### Outputs

The network module has the following outputs:

- vnet_id - The ID of the virtual network
- main_subnet_id - The ID of the main subnet
- app_subnet_id - The ID of the app subnet

## App Service

The app service module is responsible for creating the app service infrastructure. This includes the following
resources:

- app service plan
- app service
- app service slot
- application gateway
- public IP address for the application gateway

### Variables

The app service module has the following variables:

- tags - A map of tags to apply to all resources
- location - The location to deploy the resources
- resource_group_name - The name of the resource group
- worker_count - The number of workers for the app service
- storage_account_access_key - The access key for the storage account
- storage_account_name - The name of the storage account
- storage_container_name - The name of the storage container
- storage_account_resource_name - The name of the storage account resource
- subnet_id - The ID of the subnet
- naming values - The naming values for the nested resources, set by in main.tf by azure naming module

### Outputs

The app service module has the following outputs:

- gateway_public_ip - The public IP address of the application gateway

It does not output the app service URL even though it is created, as traffic *should* be routed through the application
gateway.

## Database

The database module is responsible for creating the database infrastructure. This includes the following resources:

- mssql server
- mssql database
- mssql audit policy
- private endpoint

### Variables

The database module has the following variables:

- tags - A map of tags to apply to all resources
- location - The location to deploy the resources
- resource_group_name - The name of the resource group
- mssql_administrator_login - The administrator login for the MSSQL server, creates a random one if not provided
- mssql_administrator_login_password - The administrator login password for the MSSQL server, creates a random one if
  not provided
- storage_primary_blob_endpoint - The primary blob endpoint for the storage account
- storage_account_access_key - The access key for the storage account
- subnet_id - The ID of the subnet
- naming values - The naming values for the nested resources, set by in main.tf by azure naming module

## Storage

The storage module is responsible for creating the storage infrastructure. This includes the following resources:

- storage account
- storage container

### Variables

The storage module has the following variables:

- tags - A map of tags to apply to all resources
- location - The location to deploy the resources
- resource_group_name - The name of the resource group
- naming values - The naming values for the nested resources, set by in main.tf by azure naming module

### Outputs

- storage_account_id - The ID of the storage account
- storage_account_name - The name of the storage account
- storage_account_blob_endpoint - The blob endpoint for the storage account
- storage_account_primary_access_key - The primary access key for the storage account
