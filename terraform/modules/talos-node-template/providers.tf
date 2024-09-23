terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.4"
    }
  }


}
