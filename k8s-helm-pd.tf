resource "helm_release" "pingdirectory" {
  name = local.releaseName
  repository = "https://helm.pingidentity.com/"
  chart      = "ping-devops"

  namespace = var.namespace

  # set {
  #   name  = "global.envs.PING_IDENTITY_PASSWORD"
  #   value = random_password.password.result
  # }

  set {
    name  = "pingdirectory.ROOT_USER_PASSWORD"
    value = random_password.password.result
  }

  # set {
  #   name  = "pingdirectory.envs.ROOT_USER"
  #   value = var.ROOT_USER
  # }

  # set {
  #   name  = "pingdirectory.envs.ROOT_USER_DN"
  #   value = "cn=${var.ROOT_USER}"
  # }

  values = [
    "${file("ping-devops-values.yaml")}"
  ]
}