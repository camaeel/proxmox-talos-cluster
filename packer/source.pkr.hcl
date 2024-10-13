# docs: https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso

source "proxmox-iso" "builder" {
  # iso
  boot_iso {
    iso_url = var.builder_iso_url
    iso_storage_pool = var.builder_iso_storage_pool
    type    = "ide"
    unmount = true
    iso_checksum = var.builder_iso_checksum_url != null ? "file:${var.builder_iso_checksum_url}" : "file:${var.builder_iso_url}.sha256"
    iso_download_pve = true #download directly to PVE
  }

  #target disk
  disks {
    type              = var.target_disk_config.type
    storage_pool      = var.target_disk_config.storage_pool
    format            = var.target_disk_config.format
    disk_size         = var.target_disk_config.disk_size
    io_thread         = var.target_disk_config.io_thread
    cache_mode        = var.target_disk_config.cache_mode
    discard           = var.target_disk_config.discard
  }

  boot_wait = "20s"
  boot_command = [
    "<enter><wait20s>",
  ]

  task_timeout = "5m"

  additional_iso_files {
    unmount = true
    iso_storage_pool = "local"
    cd_content = {
      "meta-data" = templatefile("${path.root}/cloud-init/meta-data.tmpl", {})
      "user-data" = templatefile("${path.root}/cloud-init/user-data.tmpl.yml", {
        ssh_public_key = data.sshkey.temporary.public_key
      })
    }
    cd_label = "cidata"
  }

  # connection
  qemu_agent = true
  ssh_username = "ubuntu"
  ssh_private_key_file = data.sshkey.temporary.private_key_path
  # ssh_private_key_file = ssh_private_key_file

  # instance shape
  memory   = var.memory
  cores    = var.cores
  cpu_type = "host"
  os       = "l26"

  network_adapters {
    model= "virtio"
    bridge = var.network_config.bridge
    vlan_tag = var.network_config.vlan_tag
    firewall = false
  }


  # vm identification
  vm_name = "talos-${var.talos_version}-builder"
#   tags = "some;some-other;TODO"
  template_description = "Talos ${var.talos_version} template, schematic_id=TODO, generated on ${timestamp()}"
  template_name        = "talos-nocloud-${var.talos_version}.${formatdate("YYYYMMDD-hhmmss", timestamp())}"

 # This is managed by source in build, so template is built for multiple nodes
 # node = "proxmox_node_name"

  #proxmox creds
  insecure_skip_tls_verify = false
  proxmox_url = var.proxmox_url #or set PROXMOX_URL env
  username = var.proxmox_username
  password = var.proxmox_password
  token = var.proxmox_token
}
