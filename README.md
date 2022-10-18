# Use-Case - P1 LDAP Gateway

Use Case: Implement P1 LDAP Gateway and access from DaVinci Flow

This repo contains the configuration of enabling a PingOne LDAP Gateway to connect with an instance of PingDirectory, and leveraging the Gateway from a PingOne DaVinci flow.

Note: The P1 Gateway does not require PingDirectory, any LDAP directory can be connected to.

## Pre-requisites

* PingOne Organization
  * Admin Environment
    * Sign-On Policy **cannot** include MFA for deployment
    * Admin User
    * Worker Application (with sufficient rights to create an Environment)
* Terraform
* Kubernetes cluster
  * `kubectl`
  * Helm

## Deployment

If you haven't installed Terraform, type the following:

```zsh
brew install terraform
```

If you don't have a PingOne Organization - [Setup Trial](https://www.pingidentity.com/en/try-ping.html)

Clone this repo

```zsh
gh repo clone cprice-ping/Use-Case---P1-LDAP-Gateway
```

Create a `terraform.tfvars` file and complete with your PingOne details:

```hcl
region = "YouP1Region" # NorthAmerica | Europe | Canada | Asia
org_id = "YourP1OrgId"
env_name = "NameOfDeploymentEnv"
admin_env_id = "AdminEnvironmentId"
admin_user_id = "AdminUserId"
admin_user_name = "Admin Username" # Used to connect to DaVinci
admin_user_password = "Admin User Password" # Used to connect to DaVinci
worker_id = "WorkerAppID" # Admin Env Worker App with Roles to create new Envs
worker_secret = "WorkerAppSecret" # Admin Env Worker Secret
namespace = "k8sNamespace" # PingDirectory & P1 Gateway deployment namespace
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
