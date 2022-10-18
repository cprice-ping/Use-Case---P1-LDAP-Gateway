terraform {
  required_providers {
    pingone = {
      source = "pingidentity/pingone"
    }
    davinci = {
      source = "samir-gandhi/davinci"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "random_password" "password" {
  length           = 16
  numeric          = true
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
  min_numeric      = 1
  min_upper        = 2
  min_special      = 1
  min_lower        = 2
}

provider "pingone" {
  client_id                    = var.worker_id
  client_secret                = var.worker_secret
  environment_id               = var.admin_env_id
  region                       = var.region
  force_delete_production_type = false
}

resource "pingone_environment" "release_environment" {
  name        = var.deploy_name
  description = "Created by Terraform"
  type        = "SANDBOX"
  # license_id  = data.pingone_licenses.pingone_license.id
  license_id = "7b97eb26-6b72-481a-b94f-1038bf675c37"
  default_population {}
  service {
    type = "SSO"
  }
  service {
    type = "DaVinci"
  }
}

data "pingone_role" "identity_data_admin" {
  name = "Identity Data Admin"
}

resource "pingone_role_assignment_user" "id_admin" {
  environment_id = var.admin_env_id
  user_id        = var.admin_user_id
  role_id        = data.pingone_role.identity_data_admin.id

  scope_environment_id = pingone_environment.release_environment.id
}

resource "pingone_application" "demo_oidc_app" {
  environment_id = pingone_environment.release_environment.id
  name           = "Demo OIDC App"
  enabled        = true

  oidc_options {
    type                        = "WEB_APP"
    grant_types                 = ["AUTHORIZATION_CODE", "IMPLICIT", "REFRESH_TOKEN"]
    response_types              = ["CODE", "TOKEN", "ID_TOKEN"]
    token_endpoint_authn_method = "CLIENT_SECRET_BASIC"
    redirect_uris               = ["https://decoder.pingidentity.cloud/oidc", "https://decoder.pingidentity.cloud/implicit", "https://decoder.pingidentity.cloud/hybrid"]
  }
}

# data "pingone_licenses" "pingone_licenses" {
#   organization_id = var.organization_id

#   data_filter {
#     name   = "package"
#     values = [var.license_type]
#   }

#   # data_filter {
#   #   name   = "status"
#   #   values = ["ACTIVE"]
#   # }
# }

locals {
  releaseName = replace(lower(var.deploy_name), " ", "-")
}

resource "pingone_gateway" "ldap_gateway" {
  environment_id = pingone_environment.release_environment.id
  name           = "PingDirectory"
  enabled        = true
  type           = "LDAP"

  bind_dn       = "uid=administrator,ou=People,dc=example,dc=com"
  bind_password = "2FederateM0re"
  # connection_security = "TLS"
  vendor              = "PingDirectory"

  servers = [
    "${local.releaseName}-pingdirectory:389"
  ]

  user_type {
    name               = "PD Users"
    password_authority = "LDAP"
    search_base_dn     = "ou=people,dc=example,dc=com"

    user_link_attributes = ["entryUUID", "uid", "dn"]

    # user_migration {
    #   lookup_filter_pattern = "(|(sAMAccountName=$${identifier})(UserPrincipalName=$${identifier}))"

    #   population_id = pingone_environment.release_environment.default_population_id

    #   attribute_mapping {
    #     name  = "username"
    #     value = "$${ldapAttributes.sAMAccountName}"
    #   }

    #   attribute_mapping {
    #     name  = "email"
    #     value = "$${ldapAttributes.mail}"
    #   }
    # }

    push_password_changes_to_ldap = true
  }
}

resource "pingone_gateway_credential" "ldap_gateway_cred" {
  environment_id = pingone_environment.release_environment.id
  gateway_id     = pingone_gateway.ldap_gateway.id
}

provider "davinci" {
  username                  = var.admin_user_name
  password                  = var.admin_user_password
  base_url                  = "https://orchestrate-api.pingone.com/v1"
  pingone_admin_environment = var.admin_env_id
  company_id                = pingone_environment.release_environment.id
}

// Bootstrapping P1DaVinci can take up to 40s
resource "time_sleep" "wait" {
  depends_on = [
    resource.pingone_role_assignment_user.id_admin
  ]
  create_duration = "40s"
}

// A READ MUST be the first action after the new environment is created
data "davinci_connections" "all" {
  company_id = resource.pingone_environment.release_environment.id
  depends_on = [
    time_sleep.wait
  ]
}
