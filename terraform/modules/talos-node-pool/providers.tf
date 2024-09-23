terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
    null = {
      source  = "hashicorp/null"
      # version = "~> 3.2.1"
    }
    auth0 = {
      source = "auth0/auth0"
    }
    talos = {
      source = "siderolabs/talos"
      version = ">= 0.2.0"
    }
  }


}
