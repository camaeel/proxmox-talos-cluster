variable "env_name" {
  type = string
}

variable "control_plane" {
  type = object({
    node_count     = number
    cores          = number
    memory         = number
    ips            = list(string)
    root_disk_size = number
  })
}

variable "worker_pools" {
  type = map(object({
    labels         = optional(map(string), {})
    taints         = optional(list(string), [])
    node_count     = number
    cores          = number
    memory         = number
    ips            = list(string)
    root_disk_size = number
  }))
}

variable "proxmox_endpoint" {
  type = string
}
variable "gateway" {
  type = string
}

variable "local_network_ipset" {
  default = "+local_network"
  type    = string
}

variable "dns_entries" {
  description = "cluster specific domains"
  type        = map(string)
}

variable "auth0_oidc_enabled" {
  type = bool
}

variable "auth0_oidc_group_claim" {
  default = null
  type    = string
}

variable "auth0_oidc_group_prefix" {
  default = "auth0-oidc-"
  type    = string
}

variable "admin_user_ids" {
  type        = set(string)
  description = "list of auth0 user_ids that should get admin access role in auth0"
}

variable "talos_version" {
  description = "talos version used to intially bootstrap the cluster, further upgrades are done using scripts/upgrade-talos.sh"
  type = string
}

variable "kubernetes_version" {
  type        = string
  description = "Version of k8s to provision"
  default     = null
}

variable "user_data_injected" {
  type        = bool
  default     = false
  description = "If machine_config should be injected through user_data (leaves file on proxmox host)"
}

variable "domain_override" {
  description = "Overrides cluster_name in domain names for cluster"
  default = null
  type = string
}

variable "lets_encrypt" {
  type = object({
    email  = optional(string, "kamil.andrz@gmail.com")
    server = optional(string, "https://acme-v02.api.letsencrypt.org/directory")
  })
  description = "Let's encrypt setup"
  default     = {}
}

variable "qemu_agent_enabled" {
  type        = bool
  default     = false
  description = "qemu agent enabled. Doesn't work. Because it is not started fully until agent is running, and this waits until configuration is applied"
}

variable "topoplogy_region" {
  default = "homelab-proxmox-1"
  type = string
}

variable "proxmox-csi-tokenid" {
  description = "token id for csi"
  default     = "proxmox-csi"
  type        = string
}

variable "default_node_taints" {
  type = list(string)
  default = [
    "node.cilium.io/agent-not-ready=:NoExecute",
  ]
}

variable "proxmox_api_token" {
  sensitive   = true
  description = "proxmox api token"
}

variable "anonymous_oidc_access_enabled" {
  default = false
  type = bool
  description = "If oidc issuer should be accessible by system:unauthenticated group"
}

variable "image" {
  type = object({
    official_extensions = optional(list(string), [] )
    datastore_id = optional(string, "local")
    architecture = optional(string, "amd64")
  })
}