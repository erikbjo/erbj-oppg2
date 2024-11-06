# Project Structure

```text
erbj-oppg2
├── PROJECT_STRUCTURE.md
├── PROJECT_STRUCTURE_ALTERNATIVES.md
├── README.md
├── .github/
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
│    ├── terraform.tfvars
│    ├── terraform.tfvars.env.example
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
    │    ├── README.md
    │    ├── gateway.tf
    │    ├── main.tf
    │    ├── outputs.tf
    │    ├── terraform.tf
    │    └── variables.tf
    │
    ├── db
    │    ├── README.md
    │    ├── main.tf
    │    ├── network.tf
    │    ├── outputs.tf
    │    ├── terraform.tf
    │    └── variables.tf
    │
    ├── network
    │    ├── README.md
    │    ├── main.tf
    │    ├── outputs.tf
    │    ├── terraform.tf
    │    └── variables.tf
    │
    └── storage
        ├── README.md
        ├── main.tf
        ├── outputs.tf
        ├── terraform.tf
        └── variables.tf
```