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

    ipv6_address = string

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

    unprivileged = bool

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

variable "postgres_config" {
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
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

variable "reverse_proxy_config" {
  type = object({
    node_name    = string
    vm_id        = number
    hostname     = string
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    swap_mb      = number
    cpu_cores    = number
    tags         = list(string)
  })
}

variable "dns_config" {
  type = object({
    node_name    = string
    vm_id        = number
    hostname     = string
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    swap_mb      = number
    cpu_cores    = number
    tags         = list(string)
  })
}

variable "jenkins_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

variable "plex_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

variable "bastion_vault_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

variable "k8s_host_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}

