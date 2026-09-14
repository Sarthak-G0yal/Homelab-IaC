variable "config" {
  description = "Postgres Host VM configuration"

  type = object({
    node_name             = string
    vm_id                 = number
    ipv4_address          = string
    disk_size_gb          = number
    memory_mb             = number
    cpu_cores             = number
    data_disk_datastore   = optional(string, "external-hdd")
    data_disk_size_gb     = optional(number, 100)
  })
}

variable "network" {

  type = object({

    bridge = string

    gateway = string

    ipv6_address = string

    dns_servers = list(string)

  })

}

variable "platform" {

  sensitive = true

  type = object({

    datastore = string

    template_datastore = string

    template_file = string

    template_filename = string

    template_url = string

    template_verify = bool

    ssh_public_key_path = string

    root_password = string

    start_on_boot = bool

    started = bool

    iso_file_id = optional(string)

  })

}