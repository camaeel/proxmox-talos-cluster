build {

  # var.proxmox_nodes
  dynamic "source" {
    for_each = convert(var.proxmox_nodes, set(string))
    labels = [ "source.proxmox-iso.builder"]
    # iterator = "iter"
    content {
      node = source.key

      name = "build-${source.key}"
    }
  }

  # prevent waiting for CD eject
  provisioner "shell" {
    inline = [
      "sudo touch /run/casper-no-prompt"
    ]
  }

  provisioner "shell" {
    inline = [
      "df -h"
      # "curl -s -L ${local.image} -o /tmp/talos.raw.xz",
      # "xz -d -c /tmp/talos.raw.xz | dd of=${var.target_device} && sync",
    ]
  }

  post-processor "shell-local" {
    inline = [
      "rm ~/.cache/packer/ssh_private_key_packer_rsa.pem",
    ]
  }
  post-processor "manifest" {}
#   post-processor "shell-local" {
#     # when https://github.com/hashicorp/packer-plugin-proxmox/issues/193 is released (version >1.1.5)
#     inline = [
#       "python3 ./scripts/clean_old_builds.py ${var.proxmox_host} ${join(",",var.tags)} ${var.keep_images}",
#     ]
#   }
}