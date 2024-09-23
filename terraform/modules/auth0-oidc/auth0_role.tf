resource "auth0_role" "kubernetes-admin" {
  name        = "${var.cluster_name}-admin"
  description = "Kubernetes ${var.cluster_name} admin"
}

resource "auth0_user_role" "kubernetes-admin" {
  role_id = auth0_role.kubernetes-admin.id
  user_id = each.value

  for_each = var.admin_user_ids
}
