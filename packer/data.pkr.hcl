data "sshkey" "temporary" {
  type = "ed25519"
}

# schematic_id
# switch to data.http after https://github.com/hashicorp/packer/issues/13169

data "http" "schematic_id" {
  url = "https://factory.talos.dev/schematics"
  method = "POST"
  request_headers = {
    "Content-Type" = "application/yaml"
    "Accept"       = "application/json"
  }
  request_body  = jsonencode({
    customization = {
      extraKernelArgs = var.schematic_customization.extraKernelArgs
      systemExtensions = {
        officialExtensions = var.schematic_customization.official_extensions
      }
    }
  })
}

locals {
  schematic_id         = jsondecode(data.http.schematic_id.body).id
  talos_disk_image_url = "https://factory.talos.dev/image/${local.schematic_id}/${var.talos_version}/${var.talos_disk_image_flavour}-${var.architecture}.raw.xz"
}
