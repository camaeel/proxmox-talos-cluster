resource "proxmox_virtual_environment_role" "csi" {
  role_id = "${local.cluster_name}-csi"

  privileges = [
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit",
  ]
}

resource "proxmox_virtual_environment_user" "csi" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
  }

  comment = "K8s proxmox csi user - talos ${local.cluster_name}"
  user_id = "${local.cluster_name}-csi@pve"
}

resource "proxmox_virtual_environment_user_token" "csi" {
  comment         = "Proxmox CSI ${var.env_name}"
  token_name      = var.proxmox-csi-tokenid
  user_id         = proxmox_virtual_environment_user.csi.user_id
  privileges_separation = false // use users ACL
}
