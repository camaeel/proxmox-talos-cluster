provider "cloudflare" {
  api_key = data.aws_ssm_parameter.cloudflare_root_api_key.value
  email   = data.aws_ssm_parameter.cloudflare_email.value
}

data "aws_ssm_parameter" "cloudflare_email" {
  name = "/cloudflare/email"
}
data "aws_ssm_parameter" "cloudflare_root_api_key" {
  name = "/cloudflare/root_api_key"
}
data "aws_ssm_parameter" "cloudflare_zone_id" {
  name = "/cloudflare/zone_id"
}

data "aws_ssm_parameter" "cloudflare_edit_all_zones_api_key" {
  name = "/cloudflare/edit_all_zones_api_key"
}

data "cloudflare_zone" "zone" {
  zone_id = data.aws_ssm_parameter.cloudflare_zone_id.value
}

locals {
  cluster_domain_prefix = var.domain_override ==null ? local.cluster_name : var.domain_override
  cluster_base_domain   = "${local.cluster_domain_prefix}.${data.cloudflare_zone.zone.name}"
}
