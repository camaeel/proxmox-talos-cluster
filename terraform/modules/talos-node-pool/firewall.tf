resource "proxmox_virtual_environment_firewall_options" "default" {
  node_name = proxmox_virtual_environment_vm.vm[count.index].node_name
  vm_id     = proxmox_virtual_environment_vm.vm[count.index].vm_id

  dhcp          = true
  enabled       = var.firewall_enabled
  ipfilter      = false
  log_level_in  = "nolog"
  log_level_out = "nolog"
  macfilter     = false
  # ndp           = true
  input_policy  = "DROP"
  output_policy = "ACCEPT"
  radv          = false # don't allow vm to advertise as router

  count = length(proxmox_virtual_environment_vm.vm)
}

resource "proxmox_virtual_environment_firewall_rules" "inbound" {
  node_name = proxmox_virtual_environment_vm.vm[count.index].node_name
  vm_id     = proxmox_virtual_environment_vm.vm[count.index].vm_id

  dynamic "rule" {
    for_each = var.security_groups
    content {
      security_group = rule.key
    }
  }
  count = length(proxmox_virtual_environment_vm.vm)
}
