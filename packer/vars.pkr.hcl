variable "talos_version" {
  type = string
  # renovate: datasource=github-releases depName=siderolabs/talos
  default = "v1.8.1"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 1024
}

#https://www.alpinelinux.org/cloud/
variable "builder_iso_url" {
  type    = string
#   default = "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.3-x86_64.iso"
#   default = "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.7.0-amd64-standard.iso"
  default = "https://releases.ubuntu.com/noble/ubuntu-24.04.1-live-server-amd64.iso"
}

variable "builder_iso_checksum_url" {
  type = string
  default = null
}

variable "builder_iso_storage_pool" {
  type = string
  default = "local"
}

variable "proxmox_nodes" {
  type = set(string)
  description = "List of proxmox nodes to build template"
}

variable "proxmox_url" {
  type = string
  default = null
  description = "Set it to API URL https://<server>:<port>/api2/json. Alternatievely set PROXMOX_URL env var."
}

variable "proxmox_username" {
  type = string
  default = null
  description = "Proxmox username or token name. Alternatievely set PROXMOX_USERNAME env var."
}

variable "proxmox_password" {
  type = string
  default = null
  description = "Proxmox password. Alternatievely set PROXMOX_PASSWORD env var."
}

variable "proxmox_token" {
  type = string
  default = null
  description = "Proxmox token. Alternatievely set PROXMOX_TOKEN env var."
}

variable "network_config" {
  type = object({
    bridge = string
    vlan_tag = string
  })
  default = {
    bridge = "vmbr0"
    vlan_tag = null
  }
}

variable "target_disk_config" {
  type = object({
    type = string
    format = string
    disk_size = string
    storage_pool = string
    io_thread = bool
    cache_mode = string
    discard = bool
  })
  default = {
    type = "virtio"
    storage_pool = "local-lvm"
    format = "raw"
    disk_size = "3G"
    io_thread = false
    cache_mode = "writethrough"
    discard = true
  }
}

variable "target_device" {
  type = string
  default = "/dev/vda"
}
