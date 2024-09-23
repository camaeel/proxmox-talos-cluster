module "control-plane" {
  source = "../talos-node-pool"

  nodes      = data.proxmox_virtual_environment_nodes.available_nodes.names
  node_count = var.control_plane.node_count
  cores      = var.control_plane.cores
  memory     = var.control_plane.memory
  vm_tags = [
    "cluster-${local.cluster_name}",
    "talos-master",
    "talos-role-master"
  ]
  ips     = var.control_plane.ips
  gateway = var.gateway

  vm_name = "${local.cluster_name}-master"

  root_disk = {
    size  = var.control_plane.root_disk_size
  }

  template_vm_id = module.template.template_vm_id
  template_vm_node_name = module.template.template_vm_node_name

  security_groups = [
    proxmox_virtual_environment_cluster_firewall_security_group.node.name,
    proxmox_virtual_environment_cluster_firewall_security_group.master.name
  ]

  talos_machine_config       = data.talos_machine_configuration.controlplane.machine_configuration
  talos_client_configuration = data.talos_client_configuration.talosctl_config.client_configuration
  is_control_plane           = true
  user_data_injected         = var.user_data_injected
  qemu_agent_enabled         = var.qemu_agent_enabled
  topoplogy_region                     = var.topoplogy_region

  depends_on = [
    proxmox_virtual_environment_firewall_ipset.masters
  ]
}
