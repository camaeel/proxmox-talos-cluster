#Talos image factory https://factory.talos.dev
data "http" "talos_image_factory" {
  url    = "https://factory.talos.dev/schematics"
  method = "POST"
  request_body = yamlencode({
    customization= {
      systemExtensions = {
        officialExtensions = var.image.official_extensions
      }
    }
  })
}

resource "proxmox_virtual_environment_download_file" "talos-iso" {
  content_type = "iso"
  datastore_id = var.image.datastore_id
  file_name    = "talos-${var.env_name}-${var.talos_version}-${var.image.architecture}.img"
  node_name    = data.proxmox_virtual_environment_nodes.available_nodes.names[0]
  url          = "https://factory.talos.dev/image/${jsondecode(data.http.talos_image_factory.response_body).id}/${var.talos_version}/nocloud-${var.image.architecture}.raw.xz"
}

