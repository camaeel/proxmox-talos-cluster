data "sshkey" "temporary" {
  type = "ed25519"
}

# schematic_id
# switch to data.http after https://github.com/hashicorp/packer/issues/13169

data "external-raw" "schematic_id" {
  program = [
    "curl", "https://factory.talos.dev/schematics",
    "-X", "POST",
    "-H", "'Content-Type: application/yaml'",
    "-H", "'Accept: application/json'",
    "--data-binary", "@-"
  ]
  query = yamlencode({
    customization = {
      extraKernelArgs = var.schematic_customization.extraKernelArgs
      systemExtensions = {
        officialExtensions = var.schematic_customization.official_extensions
      }
    }
  })
}

locals {
  schematic_id         = jsondecode(data.external-raw.schematic_id.result).id
  talos_disk_image_url = "https://factory.talos.dev/image/${local.schematic_id}/${var.talos_version}/${var.talos_disk_image_flavour}-${var.architecture}.raw.xz"
}
