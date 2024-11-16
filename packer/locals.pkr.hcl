locals {
  tags = [
    "talos-image-${var.talos_version}",
    "schematic-id-${local.schematic_id}",
    "flavour-${var.talos_disk_image_flavour}",
    "talos-base-image"
  ]
  cleanup_tag_selector = concat(
    (var.clean_only_current_version ? ["talos-image-${var.talos_version}"] : []),
    [
      "flavour-${var.talos_disk_image_flavour}",
      "talos-base-image",
      #don't need to filter by schematic-id
    ]
  )
  proxmox_host = regex_replace(var.proxmox_url, "^https://([^:/]+)(:.*|/.*|)$", "$1")
}