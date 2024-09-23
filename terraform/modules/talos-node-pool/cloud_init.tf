# resource "proxmox_virtual_environment_file" "meta_data" { #TODO - kazdy plik musi miec unikanlna nazwe
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = local.source_template.node_name

#   source_raw {
#     data = <<EOF
# hostname: ${var.vm_name}-${count.index}
# EOF

#     file_name = "${var.vm_name}-${count.index}-meta-data"
#   }

#     count = var.node_count
# }

# resource "proxmox_virtual_environment_file" "user_data" { #TODO - kazdy plik musi miec unikanlna nazwe
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = local.source_template.node_name

#   source_raw {
#     data = var.talos_machine_config

#     file_name = "${var.vm_name}-${count.index}-user-data"
#   }

#     count = var.user_data_injected ? var.node_count : 0
# }
