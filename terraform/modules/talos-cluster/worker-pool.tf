module "worker-pool" {
  source = "../talos-node-pool"

  nodes      = data.proxmox_virtual_environment_nodes.available_nodes.names
  node_count = each.value.node_count
  cores      = each.value.cores
  memory     = each.value.memory
  vm_tags = [
    "cluster-${local.cluster_name}",
    "talos-pool-${each.key}",
    "talos-role-worker"
  ]
  ips     = each.value.ips
  gateway = var.gateway

  vm_name = "${local.cluster_name}-${each.key}"

  root_disk = {
    size = each.value.root_disk_size

  }

  template_vm_id = module.template.template_vm_id
  template_vm_node_name = module.template.template_vm_node_name

  security_groups = [
    proxmox_virtual_environment_cluster_firewall_security_group.node.name,
    proxmox_virtual_environment_cluster_firewall_security_group.worker.name
  ]

  talos_machine_config       = data.talos_machine_configuration.workers.machine_configuration
  talos_client_configuration = data.talos_client_configuration.talosctl_config.client_configuration
  user_data_injected         = var.user_data_injected
  qemu_agent_enabled         = var.qemu_agent_enabled
  labels                     = each.value.labels
  taints                     = concat(var.default_node_taints, each.value.taints)
  topoplogy_region                     = var.topoplogy_region

  depends_on = [
    # proxmox_virtual_environment_firewall_ipset.workers #this causes replacement of nodes when changing number of them
  ]

  for_each = var.worker_pools
}
