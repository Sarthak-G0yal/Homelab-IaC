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

    ssh_private_key_path = optional(string, "/home/sg/.ssh/id_ed25519_proxmox")

    iso_file_id = optional(string, "local:iso/ubuntu-24.04-minimal-cloudimg-amd64.img")

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

variable "k3s_control_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}


variable "k3s_worker_1_config" {
  type = object({
    node_name    = string
    vm_id        = number
    ipv4_address = string
    disk_size_gb = number
    memory_mb    = number
    cpu_cores    = number
  })
}
