terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.64.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    auth0 = {
      source = "auth0/auth0"
      version = "~> 1.6"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.5.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.67"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.4"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = "~> 1.9"
}
provider "talos" {
  # Configuration options
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = false
  api_token = var.proxmox_api_token
  ssh {
    agent = true
    username = "kamil"
    node {
      address = "osiris.home.kamilk.eu"
      name    = "osiris"
    }
  }
}
