packer {
  required_plugins {
    proxmox = {
      source  = "github.com/hashicorp/proxmox"
      # renovateplugins: depName=hashicorp/packer-plugin-proxmox
      version = "~> 1.0"
    }
    sshkey = {
      source = "github.com/ivoronin/sshkey"
      # renovateplugins: depName=ivoronin/packer-plugin-sshkey
      version = "v1.2.1"
    }
    external = {
      source  = "github.com/joomcode/external"
      # renovateplugins: depName=joomcode/packer-plugin-external
      version = ">= 0.0.3"
    }
  }
}
