resource "aws_ssm_parameter" "proxmox-csi-token-id" {
  name  = "/talos/${local.cluster_name}/proxmox-csi/token-id"
  type  = "SecureString"
  value = proxmox_virtual_environment_user_token.csi.id
}

resource "aws_ssm_parameter" "proxmox-csi-token-secret" {
  name  = "/talos/${local.cluster_name}/proxmox-csi/token-secret"
  type  = "SecureString"
  value = split("=", proxmox_virtual_environment_user_token.csi.value)[1]
}
