variable "region" {
  type        = string
  description = "Region your P1 Org is in"
}

variable "organization_id" {
  type        = string
  description = "Organization ID"
}

variable "env_name" {
  type        = string
  description = "Environment Name"
}

variable "admin_env_id" {
  type        = string
  description = "P1 Environment containing the Worker App"
}

variable "worker_id" {
  type        = string
  description = "Worker App ID App - App must have sufficient Roles"
}

variable "worker_secret" {
  type        = string
  description = "Worker App Secret - App must have sufficient Roles"
}

variable "deploy_name" {
  type        = string
  description = "Name used to identify k8s deployment"
}

variable "license_type" {
  type        = string
  description = "Type of P1 License to retrieve from Org"
}

variable "namespace" {
  type        = string
  description = "k8s namespace to deploy PD and the LDAP Gateway into"
}

variable "admin_user_id" {
  type        = string
  description = "P1 Admin User Id"
}

variable "admin_user_name" {
  type        = string
  description = "P1 Admin Username"
}

variable "admin_user_password" {
  type        = string
  description = "P1 Admin User Password"
}