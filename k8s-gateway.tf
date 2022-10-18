resource "kubernetes_deployment" "ldap_gateway" {
  metadata {
    name = "${local.releaseName}-ldap-gateway"
    labels = {
      "app.kubernetes.io/name" = local.releaseName,
      "app.kubernetes.io/instance" = local.releaseName,
      "app.kubernetes.io/managed-by" = local.releaseName
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "pingoneldapgateway"
      }
    }
    template {
      metadata {
        labels = {
            app = "pingoneldapgateway"
        }
      }
      spec {
        container {
          image = "gcr.io/ping-identity/pingone/pingone-ldap-gateway:2.2.20"
          name  = "pingoneldapgateway"
          env {
            name = "PING_IDENTITY_ACCEPT_EULA"
            value = "yes"
          }
          env {
            name = "gatewayCredential"
            value = pingone_gateway_credential.ldap_gateway_cred.credential
          }
        }
      }
    }
  }
}