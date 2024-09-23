output "client_id" {
  value = data.auth0_client.shared-k8s-client.client_id
}

output "issuer" {
  value = "https://${data.auth0_tenant.tenant.domain}/"
}
