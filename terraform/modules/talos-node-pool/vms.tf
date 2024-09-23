#TODO: add dns entries?
# openwrt router: https://registry.terraform.io/providers/joneshf/openwrt/latest/docs
# tailscale/netmaker ?

resource "proxmox_virtual_environment_vm" "vm" {
  name = "${var.vm_name}-${count.index}"
  tags = var.vm_tags

  node_name = var.nodes[count.index % length(var.nodes)]

  agent {
    enabled = var.qemu_agent_enabled
    trim    = true
    timeout = "10m"
  }
  disk {
    datastore_id = var.root_disk.store
    discard      = var.root_disk.discard # https://github.com/bpg/terraform-provider-proxmox/issues/360
#    ssd          = true
    file_format  = var.root_disk.format
    size         = var.root_disk.size
    interface    = var.root_disk.interface
    backup       = false
  }

  clone {
    vm_id = var.template_vm_id
    node_name = var.template_vm_node_name
  }

  boot_order = var.boot_order

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = null_resource.vm_ip[count.index].triggers.ip
        gateway = null_resource.vm_ip[count.index].triggers.gateway
      }
    }
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  network_device {
    bridge = "vmbr0"
    firewall = var.firewall_enabled
  }

  operating_system {
    type = "l26"
  }

  count = var.node_count

  lifecycle {
    replace_triggered_by = [
      null_resource.vm_ip[count.index]
    ]

    #don't replace vm if vm_id changes.
    ignore_changes = [
      initialization[0].meta_data_file_id,
      initialization[0].user_data_file_id,
      disk[0].discard, # https://github.com/bpg/terraform-provider-proxmox/issues/360
      vga,
      node_name, #so node name calculation won't break existing cluster
      clone, # migrate from old approach
    ]
  }
}

resource "null_resource" "vm_ip" {
  triggers = {
    ip      = var.ips[count.index]
    gateway = var.gateway
  }
  count = var.node_count
}
