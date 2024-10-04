# output "masters" {
#   value     = module.control-plane.vms
#   sensitive = false
# }

# output "worker_pools" {
#   value = flatten(values(module.worker-pool)[*].vms)
# }

output "topology_region" {
  value = var.topoplogy_region
}

output "api_server_endpoint" {
  value = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.host
}

output "api_server_ca_certificate" {
  value = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.ca_certificate
}

output "oidc_issuer" {
  value = module.auth0-oidc[0].issuer
}

output "oidc_client_id" {
  value = module.auth0-oidc[0].client_id
}

output "cluster_base_domain" {
  value = local.cluster_base_domain
}
