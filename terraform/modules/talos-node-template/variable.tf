variable "image" {
  type = object({
    official_extensions = optional(list(string), [] )
    datastore_id = optional(string, "local")
    architecture = optional(string, "amd64")
  })
}

variable "env_name" {
  type = string
}

variable "talos_version" {
  description = "talos version used to intially bootstrap the cluster, further upgrades are done using scripts/upgrade-talos.sh"
  type = string
}

variable "root_disk" {
  type = object({
    size      = optional(number, 10)
    store     = optional(string, "local-lvm")
    interface = optional(string, "virtio0")
    discard   = optional(string, "on")
    format    = optional(string, "raw")
  })
}
