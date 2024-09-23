
resource "proxmox_virtual_environment_vm" "template" {
  name = "talos-${var.env_name}-${var.talos_version}"
  tags = sort( ["base-image-talos-${var.talos_version}-${var.env_name}"])

  template = true

  node_name = proxmox_virtual_environment_download_file.talos-iso.node_name

  agent {
#     enabled = var.qemu_agent_enabled
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
    file_id = proxmox_virtual_environment_download_file.talos-iso.id
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  operating_system {
    type = "l26"
  }
}
