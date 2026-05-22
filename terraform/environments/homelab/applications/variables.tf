variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL (e.g. https://proxmox:8006/api2/json)"
}

variable "proxmox_token_id" {
  type        = string
  description = "Proxmox API token ID (user@realm!token)"
}

variable "proxmox_token_secret" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Skip TLS verification for the Proxmox API"
  default     = true
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key on the infra host"
  default     = "~/.ssh/id_ed25519.pub"
}


variable "lxc_datastore_id" {
  type        = string
  description = "Storage for the container rootfs"
  default     = "local-lvm"
}

variable "lxc_template_datastore_id" {
  type        = string
  description = "Storage for LXC templates"
  default     = "local"
}

variable "lxc_bridge" {
  type        = string
  description = "Proxmox bridge"
  default     = "vmbr0"
}


variable "lxc_ipv4_gateway" {
  type        = string
  description = "IPv4 gateway"
  default     = "192.168.1.1"
}

variable "lxc_ipv6_address" {
  type        = string
  description = "IPv6 address in CIDR notation, or dhcp/auto"
  default     = "auto"
}

variable "lxc_dns_servers" {
  type        = list(string)
  description = "DNS servers"
  default     = ["192.168.1.120"]
}


variable "lxc_start_on_boot" {
  type        = bool
  description = "Start container on host boot"
  default     = true
}

variable "lxc_started" {
  type        = bool
  description = "Start container after creation"
  default     = true
}

variable "lxc_template_file_name" {
  type        = string
  description = "LXC template filename"
  default     = "ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "lxc_template_file_id" {
  type        = string
  description = "Existing template file ID to use instead of download"
  default     = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "lxc_template_url" {
  type        = string
  description = "Optional LXC template URL override"
  default     = null
}

variable "lxc_template_verify" {
  type        = bool
  description = "Verify TLS certificates for the template download"
  default     = false
}

variable "lxc_root_password" {
  type        = string
  description = "Optional root password"
  default     = null
  sensitive   = true
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
  description = "Configuration settings for the Plex LXC container"
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
  description = "Configuration settings for the Jenkins LXC container"
}
