provider "auth0" {
  client_id     = data.aws_ssm_parameter.auth0_client_id.value
  client_secret = data.aws_ssm_parameter.auth0_client_secret.value
  domain        = data.aws_ssm_parameter.auth0_domain.value
}

data "aws_ssm_parameter" "auth0_domain" {
  name = "/auth0/domain"
}
data "aws_ssm_parameter" "auth0_client_id" {
  name = "/auth0/client_id"
}
data "aws_ssm_parameter" "auth0_client_secret" {
  name = "/auth0/client_secret"
}

module "auth0-oidc" {
  source = "../auth0-oidc"

  cluster_name = local.cluster_name
  admin_user_ids = var.admin_user_ids

  count = var.auth0_oidc_enabled == true ? 1 : 0
}
