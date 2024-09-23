locals {
  # all_master_vms = module.control-plane.vms
  # all_worker_vms = flatten(values(module.worker-pool)[*].vms)
  # all_vms        = concat(local.all_worker_vms, local.all_master_vms)

  cluster_endpoint = "https://${cloudflare_record.cluster_domains["api"].hostname}:6443"

  cluster_name = "talos-${var.env_name}"

  control_plane_ips = slice([
    for i in var.control_plane.ips : replace(i, "/[/][0-9]{1,2}$/", "")
  ], 0, var.control_plane.node_count)
  worker_ips = flatten([
    for pool in var.worker_pools : slice(
      [for ip in pool.ips : replace(ip, "/[/][0-9]{1,2}$/", "")],
      0, pool.node_count
    )
  ])

  aws_tags = {
    project      = "home-lab-talos"
    source       = "https://github.com/camaeel/home-lab-talos"
    cluster_name = local.cluster_name
  }
}
