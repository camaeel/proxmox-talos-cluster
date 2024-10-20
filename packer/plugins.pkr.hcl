packer {
  required_plugins {
    proxmox = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/proxmox"
    }
    sshkey = {
      version = "~> 1.0"
      source = "github.com/ivoronin/sshkey"
    }
    external = {
      version = ">= 0.0.3"
      source  = "github.com/joomcode/external"
    }
  }
}
