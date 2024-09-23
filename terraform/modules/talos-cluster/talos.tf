resource "talos_machine_secrets" "machine_secrets" {
  talos_version = var.talos_version

}

locals {
  controlplane_patches_vars = {
    cluster_endpoint_vip      = var.dns_entries["api"]
    secretboxEncryptionSecret = base64encode(random_password.secretbox_secret.result)
    auth0_oidc_enabled        = var.auth0_oidc_enabled
    oidc_issuer               = var.auth0_oidc_enabled == true ? module.auth0-oidc[0].issuer : ""
    oidc_client_id            = var.auth0_oidc_enabled ? module.auth0-oidc[0].client_id : ""
    oidc_group_claim          = var.auth0_oidc_group_claim
    oidc_group_prefix         = var.auth0_oidc_group_prefix
    oidc_admin_group          = "${local.cluster_name}-admin"
    talos_version             = var.talos_version
    service_account_issuer    = local.cluster_endpoint
    jwks_uri                  = "${ local.cluster_endpoint }/openid/v1/jwks"
    anonymous_oidc_access_enabled = var.anonymous_oidc_access_enabled
  }
  controlplane_patches_contents = [for f in fileset(path.module, "patches/controlplane/*.{yml.tftpl,yaml.tftpl,yml,yaml,tftpl}") : templatefile(f, local.controlplane_patches_vars)]
  workers_patches_contents      = [for f in fileset(path.module, "patches/workers/*.{yml.tftpl,yaml.tftpl,yml,yaml,tftpl}") : templatefile(f, local.controlplane_patches_vars)]
}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = local.cluster_name
  machine_type       = "controlplane"
  cluster_endpoint   = local.cluster_endpoint
  machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  config_patches     = local.controlplane_patches_contents
}

data "talos_machine_configuration" "workers" {
  cluster_name       = local.cluster_name
  machine_type       = "worker"
  cluster_endpoint   = local.cluster_endpoint
  machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  config_patches     = local.workers_patches_contents
}



data "talos_client_configuration" "talosctl_config" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  nodes                = concat(local.control_plane_ips, local.worker_ips)
  endpoints            = slice(local.control_plane_ips, 0, var.control_plane.node_count)
}

resource "local_sensitive_file" "talosctl-config" {
  content         = data.talos_client_configuration.talosctl_config.talos_config
  filename        = pathexpand("~/.talos/${local.cluster_name}.yml")
  file_permission = 0600

  provisioner "local-exec" {
    command = "talosctl config merge ~/.talos/${local.cluster_name}.yml "
  }
}

data "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on = [
    module.control-plane
  ]

  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.control_plane_ips[0]
}

#data "talos_cluster_health" "cluster-health" {
#  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
#  endpoints = local.control_plane_ips
#  control_plane_nodes = local.control_plane_ips
#  worker_nodes = local.worker_ips
#  timeouts = {
#    read = "10m"
#  }
#  depends_on = [
#    module.control-plane
#  ]
#}

resource "time_sleep" "wait_for_access" {
  depends_on = [
#    data.talos_cluster_health.cluster-health,
    data.talos_cluster_kubeconfig.kubeconfig,
  ]

  create_duration = "1m"
}