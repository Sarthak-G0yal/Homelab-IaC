variable "node_name" {
  type        = string
  description = "Proxmox node name"
}

variable "vm_id" {
  type        = number
  description = "VM ID"
}

variable "hostname" {
  type        = string
  description = "VM hostname"
}

variable "datastore_id" {
  type        = string
  description = "Storage for the VM disk and cloud-init drive"
}

variable "template_datastore_id" {
  type        = string
  description = "Storage where the image is kept"
  default     = "local"
}

variable "iso_file_id" {
  type        = string
  description = "Cloud image file ID (e.g. local:iso/ubuntu-24.04-minimal-cloudimg-amd64.img)"
  default     = "local:iso/ubuntu-24.04-minimal-cloudimg-amd64.img"
}

variable "bridge" {
  type        = string
  description = "Proxmox bridge for the VM network interface"
}

variable "ipv4_address" {
  type        = string
  description = "IPv4 address in CIDR notation"
}

variable "ipv4_gateway" {
  type        = string
  description = "IPv4 gateway"
}

variable "ipv6_address" {
  type        = string
  description = "IPv6 address in CIDR notation, or dhcp/auto"
  default     = "auto"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers"
  default     = []
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys for the user account"
  default     = []
}

variable "username" {
  type        = string
  description = "User account created by cloud-init"
  default     = "root"
}

variable "root_password" {
  type        = string
  description = "Optional root password"
  default     = null
  sensitive   = true
}

variable "disk_size_gb" {
  type        = number
  description = "Disk size in GB"
  default     = 25
}

variable "memory_mb" {
  type        = number
  description = "Dedicated memory in MB"
  default     = 3072
}

variable "cpu_cores" {
  type        = number
  description = "CPU cores"
  default     = 2
}

variable "start_on_boot" {
  type        = bool
  description = "Start VM on host boot"
  default     = true
}

variable "started" {
  type        = bool
  description = "Start VM after creation"
  default     = true
}

variable "tags" {
  type        = list(string)
  description = "VM tags"
  default     = []
}

variable "qemu_agent_enabled" {
  type        = bool
  description = "Enable QEMU guest agent waiting"
  default     = false
}

variable "extra_disks" {
  description = "Additional data disks to attach, each on a potentially different datastore"
  type = list(object({
    datastore_id = string
    size         = number
    interface    = string
    file_format  = optional(string, "raw")
  }))
  default = []
}
