data "local_file" "ssh_key" {
  filename = pathexpand(var.platform.ssh_public_key_path)
}

module "dns" {
  source = "../../modules/lxc"

  node_name = var.config.node_name
  vm_id     = var.config.vm_id
  hostname  = var.config.hostname

  datastore_id          = var.platform.datastore
  template_datastore_id = var.platform.template_datastore

  bridge       = var.network.bridge
  ipv4_address = var.config.ipv4_address
  ipv4_gateway = var.network.gateway
  ipv6_address = var.network.ipv6_address
  dns_servers  = var.network.dns_servers

  ssh_public_keys = [trimspace(data.local_file.ssh_key.content)]
  root_password   = var.platform.root_password

  disk_size_gb = var.config.disk_size_gb
  memory_mb    = var.config.memory_mb
  swap_mb      = var.config.swap_mb
  cpu_cores    = var.config.cpu_cores

  unprivileged = var.platform.unprivileged

  start_on_boot = var.platform.start_on_boot
  started       = var.platform.started

  template_file_id   = var.platform.template_file
  template_file_name = var.platform.template_filename
  template_url       = local.lxc_template_url
  template_verify    = var.platform.template_verify

  tags = var.config.tags
}
