# Second compulsory assignment

Your company, OperaTerra, is launching a new e-commerce platform. As a DevOps engineer, you're tasked with setting up
the infrastructure on Microsoft Azure using Terraform. The platform requires a web application, a database for product
information and user data, and a storage solution for product images.

## Folder Structure

See PROJECT_STRUCTURE.md for a detailed description of the three folder structures and my choice of structure.

## Deployment

The infrastructure is primarily deployed using GitHub Actions, with three workflows for each environment. The
infrastructure is deployed to the following environments:

- Development (dev)
- Staging (stage)
- Production (prod)

Each environment has its own workflow, which is triggered by a push to the respective branch. The workflow will run
`terraform plan` and `terraform apply` for the respective environment, along with checks for formatting, validation, and
security.

To deploy the infrastructure from your local machine, you can run the following commands:

```bash
terraform init
terraform workspace select <workspace> || terraform workspace new <workspace>
terraform plan -var-file=<.tfvars file> -out=<plan file>
terraform apply <plan file>
```

## Modules

### Network

### App Service

### Database

### Storage

## Requirements

The infrastructure components you need to set up include a Virtual Network with proper subnets, an Azure Service Plan
for hosting the web application, an SQL Database for storing product and user data, Azure Blob Storage for storing
product images, and a Load Balancer in front of the web application.

You are required to implement this infrastructure for three environments: Development (dev), Staging, and Production (
prod).

Your Terraform implementation should define and deploy all infrastructure components. You should create modules for
reusable components such as networking, app service, database, and storage. Use locals for environment-specific
customization and implement random name generation for globally unique resource names. Ensure that you pass information
between root module and child modules effectively. Additionally, use remote state storage with Azure Storage Account.

The main focus for this assignment is to implement a CI/CD pipeline using GitHub Actions or simular available tools (
Digger etc.).

- For infrastructure configuration it should be created branches (remember good naming convention and life cycle) that
  should undergo code reviews (terraform fmt, terraform validate and tflint/tfsec) before they are merged into the
  environment branches (e.g., dev, staging, prod), which providing a layer of quality assurance.
- Create Pull Request to perform merging with environment branches.
    - Merging with environment branches should trigger a workflow that will plan and apply infrastructure to workspaces
      except prod
        - For deoployment of infrastructure in prod it must be aproved by a minimum of one person.

An important part of this assignment is to analyze and discuss the three provided folder structure alternatives. You
should choose one and justify your decision based on scalability, maintainability, separation of concerns, and ease of
implementing CI/CD.

## Evaluation Criteria

Your submission will be evaluated based on the correct implementation of required infrastructure components and proper
use of Terraform best practices, including effective use of modules, locals, variables, and outputs. We will also assess
your effective use of Azure resources, the quality and clarity of your code and documentation, your thoughtful analysis
of folder structure options, and the successful implementation of the CI/CD pipeline.

This assignment is designed to test your ability to apply Terraform and Azure knowledge in a realistic scenario, make
informed decisions about code organization, and implement robust DevOps practices. Good luck with your implementation!

## Contact

The repository for this project can be found [here](https://github.com/erikbjo/erbj-oppg2)

If you have any questions, feel free to contact me at [erbj@stud.ntnu.no](mailto:erbj@stud.ntnu.no)