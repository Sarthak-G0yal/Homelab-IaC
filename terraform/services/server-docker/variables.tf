variable "config" {
  description = "Docker host configuration"

  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

variable "network" {
  description = "Shared network configuration"

  type = object({
    bridge       = string
    gateway      = string
    ipv6_address = string
    dns_servers  = list(string)
  })
}

variable "platform" {
  description = "Shared platform defaults"

  sensitive = true

  type = object({
    datastore          = string
    template_datastore = string
    template_file      = string
    template_filename  = string
    template_url       = string
    template_verify    = bool

    ssh_public_key_path = string
    root_password       = string

    start_on_boot = bool
    started       = bool
  })
}
