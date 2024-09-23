data "auth0_tenant" "tenant" {
}

data "auth0_client" "shared-k8s-client" {
  name = "shared-k8s"
}
