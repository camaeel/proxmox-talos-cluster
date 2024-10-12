# docs: https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso

source "proxmox-iso" "builder" {
  boot_iso {
    iso_url = var.builder_iso_url
    type    = "virtio"
    #   iso_file = "local:iso/debian-12.5.0-amd64-netinst.iso"
    unmount = true
    #   iso_checksum = "sha512:33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9"
  }


  memory   = var.memory
  cores    = var.cores
  cpu_type = "host"
  os       = "l26"
  # cloud_init = false

  template_description = "${var.template_desc}, generated on ${timestamp()}"
  template_name        = "${var.template_name}.${formatdate("YYYYMMDD-hhmmss", timestamp())}"
}
