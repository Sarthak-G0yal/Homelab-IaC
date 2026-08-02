variable "proxmox" {
  sensitive = true

  type = object({
    endpoint     = string
    token_id     = string
    token_secret = string
    insecure     = bool
  })
}

variable "network" {

  type = object({

    bridge = string

    gateway = string

    dns_servers = list(string)

  })

}

variable "platform" {

  type = object({

    datastore = string

    template_datastore = string

    template_file = string

    template_filename = string

    template_url = string

    template_verify = bool

    start_on_boot = bool

    started = bool

    root_password = string

    ssh_public_key_path = string

  })

}

variable "server_docker_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

variable "gitea_config" {
  type = any
}

variable "postgres_config" {
  type = any
}
variable "jenkins_config" {
  type = any
}
variable "plex_config" {
  type = any
}

variable "bastion_vault_config" {
  type = any
}
