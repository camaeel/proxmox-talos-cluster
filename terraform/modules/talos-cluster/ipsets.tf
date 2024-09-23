resource "proxmox_virtual_environment_firewall_ipset" "masters" {
  name = "${local.cluster_name}-masters"

  dynamic "cidr" {
    for_each = sort(local.control_plane_ips)
    content {
      name = cidr.value
    }
  }
}

resource "proxmox_virtual_environment_firewall_ipset" "workers" {
  name = "${local.cluster_name}-workers"

  dynamic "cidr" {
    for_each = sort(local.worker_ips)
    content {
      name = cidr.value
    }
  }
}
