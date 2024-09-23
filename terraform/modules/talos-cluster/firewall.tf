resource "proxmox_virtual_environment_cluster_firewall_security_group" "node" {
  name    = "${local.cluster_name}-node"
  comment = "Talos cluster ${local.cluster_name} node SG"

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "ICMP"
    source  = var.local_network_ipset
    proto   = "icmp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "kubelet api"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "10250"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "kubelet api"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.masters.name}"
    dport   = "10250"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.masters.name}"
    dport   = "8472"
    proto   = "udp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "8472"
    proto   = "udp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium-healthcheck"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.masters.name}"
    dport   = "4240"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium-healthcheck"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "4240"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium-wireguard"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.masters.name}"
    dport   = "51871"
    proto   = "udp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium-wireguard"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "51871"
    proto   = "udp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "talos api - LAN"
    source  = var.local_network_ipset # required to setup initial cluster's workers
    dport   = "50000"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "cilium metrics"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "9962,9963,9964,9965" # 9964 used by envoy-proxy
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "node-exporter"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "9100"
    proto   = "tcp"
    log     = "nolog"
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "master" {
  name    = "${local.cluster_name}-master"
  comment = "Talos cluster ${local.cluster_name} master SG"

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "ETCD"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.masters.name}"
    dport   = "2379:2380"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "apiserver"
    source  = var.local_network_ipset
    dport   = "6443"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "talos api - cluster"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.masters.name}"
    dport   = "50001"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "talos api - cluster"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "50001"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "etcd metrics"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "2381"
    proto   = "tcp"
    log     = "nolog"
  }
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "kube-controller-manager&kube-scheduler metrics"
    source  = "+dc/${proxmox_virtual_environment_firewall_ipset.workers.name}"
    dport   = "10257,10259"
    proto   = "tcp"
    log     = "nolog"
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "worker" {
  name    = "${local.cluster_name}-worker"
  comment = "Talos cluster ${local.cluster_name} worker SG"
  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow HTTP & HTTPS"
    source  = var.local_network_ipset
    dport   = "80,443"
    proto   = "tcp"
    log     = "info"
  }

}