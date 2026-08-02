# provider "proxmox" {
#   endpoint  = var.proxmox_api_url
#   api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
#   insecure  = var.proxmox_tls_insecure
# }


provider "proxmox" {
  endpoint = var.proxmox.endpoint

  api_token = "${var.proxmox.token_id}=${var.proxmox.token_secret}"

  insecure = var.proxmox.insecure
}
