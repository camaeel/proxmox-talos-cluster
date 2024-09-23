resource "talos_machine_configuration_apply" "this" {
  depends_on = [ 
    proxmox_virtual_environment_vm.vm,
    proxmox_virtual_environment_firewall_rules.inbound
  ]

  client_configuration        = var.talos_client_configuration
  machine_configuration_input = var.talos_machine_config
  node                        = split("/", null_resource.vm_ip[count.index].triggers.ip)[0]
  endpoint                    = split("/", null_resource.vm_ip[count.index].triggers.ip)[0]
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = "${var.vm_name}-${count.index}"
        }
      }
      
    }),
    yamlencode({
        machine = {
          kubelet = {
            extraArgs = {
              register-with-taints: join(",", var.taints)
            }
          }
          nodeLabels = merge(
            var.labels,
            tomap({
              "topology.kubernetes.io/region" = var.topoplogy_region
              "failure-domain.beta.kubernetes.io/region" = var.topoplogy_region
              "topology.kubernetes.io/zone" = proxmox_virtual_environment_vm.vm[count.index].node_name
              "failure-domain.beta.kubernetes.io/zone" = proxmox_virtual_environment_vm.vm[count.index].node_name
            })
          )
          
        }
      }
    ),
    yamlencode({
      machine = {
        logging = {
          destinations = [
            {
              endpoint = "udp://${split("/", null_resource.vm_ip[count.index].triggers.ip)[0]}:6050/"
              format = "json_lines"
            }
          ]
        }
      }
    })
  ]

  count = var.node_count
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [
    proxmox_virtual_environment_vm.vm,
    talos_machine_configuration_apply.this ,
    proxmox_virtual_environment_firewall_rules.inbound
  ]
  node                 = split("/", null_resource.vm_ip[count.index].triggers.ip)[0]
  endpoint             = split("/", null_resource.vm_ip[count.index].triggers.ip)[0]
  client_configuration = var.talos_client_configuration
  count = var.is_control_plane ? 1 : 0
}
