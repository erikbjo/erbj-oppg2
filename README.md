# Second compulsory assignment

Your company, OperaTerra, is launching a new e-commerce platform. As a DevOps engineer, you're tasked with setting up
the infrastructure on Microsoft Azure using Terraform. The platform requires a web application, a database for product
information and user data, and a storage solution for product images.

## Project Structure

See [PROJECT_STRUCTURE](PROJECT_STRUCTURE.md) for a detailed description of the three folder structures and my choice of
structure.

## Modules

See [MODULES](MODULES.md) for a detailed description of the modules used in this project.

## Challenges during development

There were several challenges during development, including:

- Composite actions in workflows
    - I wanted to keep the codebase as DRY as possible, so I had to find a solution to the duplicated code for setting
      up terraform and logging into azure in the workflows. This solution would be composite actions. I created two
      composite actions: one for setting up tf, and one "wrapper" for checkov to allow for hard and soft failing.
- Connecting the resources
    - I struggled with connecting the gateway with the app service, but managed to fix my misconfigurations to solve it.
      The app service is meant to use the DB and storage for user and product data, but I do not know how to incorporate
      them with the app service.
- Deploying a sample app
    - I wanted to use the resources I created to see if they actually worked, so I needed to deploy something to the app
      service. The app I deployed is a REST api created in Go, which is supported by the app service. I had some trouble
      deploying the app, as the app service was misconfigured due to following checkov blindly. After deploying the app,
      I could test my resources to see if the gateway directed traffic etc.
      See [deploy_web_app](.github/workflows/deploy_web_app.yml) for how it is deployed.
- Following checkov blindly
    - In the first half of the project, checkov was used as an integral part of the development. Every issue found would
      be fixed with the suggested fix. These fixes would make checkov happy, but would make me unhappy later in
      development. The suggested fixes were just the "keywords" that checkov scans for, so just pasting in the fix
      without actually implementing it would just lead to misconfiguration and authentication and access errors.

## Further Improvements

- Better network security
    - Currently, they are no NSGs or firewalls in place to protect the resources. This is a major security risk, and
      should be implemented.
- Implementing a CI/CD pipeline for deploying a more complex application with docker containers
- Connect the web application to the database and storage

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

Setup backend:

```bash
cd global
terraform init
terraform apply
```

Deploy infrastructure:

```bash
cd deployments
terraform init
terraform workspace select <workspace> || terraform workspace new <workspace>
terraform plan -var-file=<.tfvars file> -out=<plan file>
terraform apply <plan file>
```

To replicate the deployment in GitHub Actions, you need to set AZURE_CREDENTIALS and SUBSCRIPTION_ID as secrets in your
repository. The AZURE_CREDENTIALS secret should be in the following format:

```json
{
  "clientSecret": "xxx",
  "subscriptionId": "xxx",
  "tenantId": "xxx",
  "clientId": "xxx"
}
```

GitHub Environments should be set up for each environment, dev, stage, and prod, with the respective branch protection
rules. Each environment should have a variable 'ENVIRONMENT' set to the respective environment name. Handling of tfvars
files should be done using GitHub Secrets, although this is not implemented in this project. Global action secrets are
instead used for this purpose.

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