variable "node_count" {
  type = number
}
variable "cores" {
  type = number
}
variable "memory" {
  type = number
}
variable "nodes" {
  type = list(string)
}
variable "vm_tags" {
  type = list(string)
}

variable "vm_name" {
  type = string
}

variable "ips" {
  type = list(string)
}

variable "gateway" {
  type = string
}

variable "root_disk" {
  type = object({
    size      = number
    store     = optional(string, "local-lvm")
    interface = optional(string, "virtio0")
    discard   = optional(string, "on")
    format    = optional(string, "raw")
  })
}

variable "template_vm_id" {
  type = string
  description = "VM id of the template"
}

variable "template_vm_node_name" {
  type = string
}

variable "boot_order" {
  type = list(string)
  default = ["virtio0", "ide0"]
  description = "Boot order"
}

variable "topoplogy_region" {
  type = string
  description = "Name of region - for node labeling"
}

variable "firewall_enabled" {
  type = bool
  default = true
}

variable "security_groups" {
  type = set(string)
}

variable "talos_machine_config" {
  type = string
}

variable "talos_client_configuration" {

}

variable "is_control_plane" {
  default = false
  type    = bool
}

variable "user_data_injected" {
  type = bool
}

variable "qemu_agent_enabled" {
  type = bool
}

variable "labels" {
  type    =  map(string)
  default = {}
}

variable "taints" {
  type    =  list(string)
  default = []
}
