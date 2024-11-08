# Project Structure

I have chosen the [Alternative Two](PROJECT_STRUCTURE_ALTERNATIVES.md#alternative-two) project structure because it was
the most relevant alternative for the client. OperaTerra is likely not a large company, as the E-Commerce platform is
new, and I am the only DevOps engineer working on the project.

Therefore, [Alternative One](PROJECT_STRUCTURE_ALTERNATIVES.md#alternative-one) will likely provide *too much*
configuration between environments, at the cost of higher repetition and lower maintainability of the code, for the
scope of OperaTerra.

[Alternative Three](PROJECT_STRUCTURE_ALTERNATIVES.md#alternative-three) provides one more layer of abstraction
than [Alternative Two](PROJECT_STRUCTURE_ALTERNATIVES.md#alternative-two) by dividing the infrastructure into core and
application (or more with nn). This is likely a good idea, but with the relative small codebase that this project
contains, it will act as a layer of abstraction without any positive gain. Even if this alternative is not needed *right
now* for OperaTerra, it is a good candidate for refactoring if the code becomes hard to maintain.

The project structure is divided into three main folders: `deployments`, `global`, and `modules`. The `deployments`
folder contains the Terraform configuration for the different environments (`dev`, `stage`, `prod`). The `global` folder
contains the global resources that are shared across all environments. The `modules` folder contains the reusable
modules for different components of the infrastructure.

## deployments

The `deployments` folder contains the Terraform configuration for the different environments (`dev`, `stage`, `prod`).
Each environment can have its own .tfvars file for configuration, to for example set the amount of workers in the
application service.

## global

The `global` folder contains the global resources that are shared across all environments. Currently, it contains the
Terraform configuration for the Backend Storage Account, which is used for storing the Terraform state file. This folder
also contains the Terraform state file and the Terraform state backup file as it is deployed from the local machine (
bad practice). Another use case for the `global` folder could be to store the configuration for the Azure Key Vault or a
shared Virtual Network.

## modules

The `modules` folder contains the reusable modules for different components of the infrastructure. The current modules
are `app`, `db`, `network`, and `storage`. See [README](README.md) for more information about the modules.

## Folder Structure

```text
erbj-oppg2
│
├── MODULES.md
├── PROJECT_STRUCTURE.md
├── PROJECT_STRUCTURE_ALTERNATIVES.md
├── README.md
│
├── .github
│   ├── actions
│   │    ├── checkovwithseveritylevel
│   │    │   ├── README.md
│   │    │   ├── action.yml
│   │    │   └── checkseveritylevels.sh
│   │    └── tfsetup
│   │        ├── README.md
│   │        └── action.yml
│   │
│   └── workflows
│       ├── deploy_web_app.yml
│       ├── destroy.yml
│       ├── dev.yml
│       ├── prod.yml
│       └── stage.yml
│
├── deployments
│    ├── locals.tf
│    ├── main.tf
│    ├── outputs.tf
│    ├── providers.tf
│    ├── terraform.tf
│    ├── dev.tfvars
│    ├── prod.tfvars
│    ├── stage.tfvars
│    ├── environment.tfvars.example
│    └── variables.tf
│
├── global
│    ├── locals.tf
│    ├── main.tf
│    ├── outputs.tf
│    ├── providers.tf
│    ├── terraform.tf
│    ├── terraform.tfstate
│    ├── terraform.tfstate.backup
│    ├── terraform.tfvars
│    ├── terraform.tfvars.env.example
│    └── variables.tf
│
└── modules
    ├── app
    │    ├── gateway.tf
    │    ├── main.tf
    │    ├── outputs.tf
    │    ├── terraform.tf
    │    └── variables.tf
    │
    ├── db
    │    ├── main.tf
    │    ├── network.tf
    │    ├── outputs.tf
    │    ├── terraform.tf
    │    └── variables.tf
    │
    ├── network
    │    ├── main.tf
    │    ├── outputs.tf
    │    ├── terraform.tf
    │    └── variables.tf
    │
    └── storage
        ├── main.tf
        ├── outputs.tf
        ├── terraform.tf
        └── variables.tf
```
