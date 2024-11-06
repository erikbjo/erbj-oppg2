# tfsetup

This composite action consists of three basic steps to prepare for running terraform:
1. Authenticate the runner as service principal
2. Init terraform
3. Create or switch to a terraform workspace

This action takes three inputs:
- AZURE_CREDENTIALS:
  - JSON object of azure credentials, in this format:
```json
{
  "clientSecret": "xxx",
  "subscriptionId": "xxx",
  "tenantId": "xxx",
  "clientId": "xxx"
}
```
- WORKSPACE:
  - The terraform workspace to use.
- WORKING_DIR:
  - The directory to execute the commands in.
