module "template" {
  source = "../talos-node-template"
  env_name = var.env_name
  talos_version = var.talos_version
  image = var.image
  root_disk = {}
}
