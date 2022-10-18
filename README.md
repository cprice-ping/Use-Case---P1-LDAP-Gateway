# Use-Case - P1 LDAP Gateway

Use Case: Implement P1 LDAP Gateway and access from DaVinci Flow

This repo contains the configuration of enabling a PingOne LDAP Gateway to connect with an instance of PingDirectory, and leveraging the Gateway from a PingOne DaVinci flow.

Note: The P1 Gateway does not require PingDirectory, any LDAP directory can be connected to.

## Pre-requisites

* PingOne Organization
  * Worker Application (with sufficient rights to create an Environment)
* Terraform
* Kubernetes cluster

## Deployment

If you haven't installed Terraform, type the following:

```zsh
brew install terraform
```

If you don't have a PingOne Organization - (Setup Trial)[https://www.pingidentity.com/en/try-ping.html]

Clone this repo

```zsh
gh repo clone cprice-ping/Use-Case---P1-LDAP-Gateway
```

Create a `terraform.tfvars` file and complete with your PingOne details:

```hcl
region = "YouP1Region"
org_id = "YourP1OrgId"
env_name = "NameOfDeploymentEnv"
admin_env_id = "AdminEnvironmentId"
worker_id = "WorkerAppID"
worker_secret = "WorkerAppSecret"
```

Initialize Terraform:

```zsh
terraform init
```

Check that terraform likes your values:

```zsh
terraform plan
```

Execute the terraform plan:

```zsh
terraform apply
```
