resource "cloudflare_record" "cluster_domains" {
  zone_id = data.aws_ssm_parameter.cloudflare_zone_id.value
  name    = "${each.key}.${local.cluster_domain_prefix}"
  value   = each.value
  type    = "A"
  ttl     = 3600

  for_each = var.dns_entries
}
