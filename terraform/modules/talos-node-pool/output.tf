
output "vms" {
  value = [ for x in proxmox_virtual_environment_vm.vm : {
    vm_id: x.vm_id
    ips_v4: zipmap(x.network_interface_names , x.ipv4_addresses)
    ips_v6: zipmap(x.network_interface_names , x.ipv6_addresses)
  } ]
  sensitive = false
}

