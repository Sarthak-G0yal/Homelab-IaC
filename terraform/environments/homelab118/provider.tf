provider "proxmox" {
  endpoint = var.proxmox.endpoint

  api_token = "${var.proxmox.token_id}=${var.proxmox.token_secret}"

  insecure = var.proxmox.insecure

  ssh {
    agent       = true
    username    = "root"
    private_key = file(var.platform.ssh_private_key_path)
  }
}
