resource "random_password" "secretbox_secret" {
  length  = 32
  special = true
}