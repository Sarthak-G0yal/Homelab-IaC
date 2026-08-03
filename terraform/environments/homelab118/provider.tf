provider "proxmox" {
  endpoint = var.proxmox.endpoint

  api_token = "${var.proxmox.token_id}=${var.proxmox.token_secret}"

  insecure = var.proxmox.insecure
}
