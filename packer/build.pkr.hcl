build {

  # var.proxmox_nodes
  dynamic "source" {
    for_each = convert(var.proxmox_nodes, set(string))
    labels   = ["source.proxmox-iso.builder"]
    # iterator = "iter"
    content {
      node = source.key
      name = source.key
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
      schematic_id             = local.schematic_id
      talos_version            = var.talos_version
      proxmox_node             = "{{ build_name }}"
      architecture             = var.architecture
      talos_disk_image_flavour = var.talos_disk_image_flavour
    }
  }
  post-processor "shell-local" {
    command = "source .venv/bin/activate && python3 ${abspath("${path.root}/scripts/clean_old_builds.py")} ${local.proxmox_host} ${source.name} ${join(",", local.cleanup_tag_selector)} ${var.keep_images}"

  }
}