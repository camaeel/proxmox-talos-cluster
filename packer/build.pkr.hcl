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
      "curl -s -L ${local.talos_disk_image_url} -o /tmp/talos.raw.xz",
      "xz -d -c /tmp/talos.raw.xz | sudo dd of=${var.target_device} && sync",
    ]
  }

  post-processor "shell-local" {
    inline = [
      "rm ${data.sshkey.temporary.private_key_path}",
    ]
  }
  post-processor "manifest" {
    custom_data = {
      schematic_id = local.schematic_id
      talos_version = var.talos_version
      proxmox_node = "{{ build_name }}"
      architecture = var.architecture
      talos_disk_image_flavour = var.talos_disk_image_flavour
    }
  }
#   post-processor "shell-local" {
#     # when https://github.com/hashicorp/packer-plugin-proxmox/issues/193 is released (version >1.1.5)
#     inline = [
#       "python3 ./scripts/clean_old_builds.py ${var.proxmox_host} ${join(",",var.tags)} ${var.keep_images}",
#     ]
#   }
}