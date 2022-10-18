output "demo_code_url" {
  value = "https://auth.pingone.com/${pingone_environment.release_environment.id}/as/authorize?client_id=${pingone_application.demo_oidc_app.id}&scope=openid email profile&redirect_uri=https://decoder.pingidentity.cloud/oidc&response_type=code"
}

output "demo_hybrid_url" {
  value = "https://auth.pingone.com/${pingone_environment.release_environment.id}/as/authorize?client_id=${pingone_application.demo_oidc_app.id}&scope=openid email profile&redirect_uri=https://decoder.pingidentity.cloud/hybrid&response_type=token id_token&reponse_mode=form_post"
}

output "releaseName" {
  value = local.releaseName
}