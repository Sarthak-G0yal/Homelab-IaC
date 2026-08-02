data "local_file" "ssh_key" {
  filename = pathexpand(var.ssh_public_key_path)
}

module "gitea" {
  source = "../../modules/lxc"

  node_name             = var.gitea_config.node_name
  vm_id                 = var.gitea_config.vm_id
  hostname              = "gitea"
  datastore_id          = var.lxc_datastore_id
  template_datastore_id = var.lxc_template_datastore_id
  bridge                = var.lxc_bridge
  ipv4_address          = var.gitea_config.ipv4_address
  ipv4_gateway          = var.lxc_ipv4_gateway
  ipv6_address          = var.lxc_ipv6_address
  dns_servers           = var.lxc_dns_servers
  ssh_public_keys       = [trimspace(data.local_file.ssh_key.content)]
  root_password         = var.lxc_root_password
  disk_size_gb          = var.gitea_config.disk_size_gb
  memory_mb             = var.gitea_config.memory_mb
  swap_mb               = 512
  cpu_cores             = var.gitea_config.cpu_cores
  unprivileged          = true
  nesting               = true
  keyctl                = false
  start_on_boot         = var.lxc_start_on_boot
  started               = var.lxc_started
  template_file_id      = var.lxc_template_file_id
  template_file_name    = var.lxc_template_file_name
  template_url          = local.lxc_template_url
  template_verify       = var.lxc_template_verify
  tags                  = ["infrastructure", "gitops", "gitea"]
}
