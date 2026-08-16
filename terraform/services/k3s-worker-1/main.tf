data "local_file" "ssh_key" {
  filename = pathexpand(var.platform.ssh_public_key_path)
}

module "vm" {
  source = "../../modules/vm"

  node_name = var.config.node_name
  vm_id     = var.config.vm_id
  hostname  = "k3s-worker-1"

  datastore_id          = var.platform.datastore
  template_datastore_id = var.platform.template_datastore
  iso_file_id           = try(var.platform.iso_file_id, "local:iso/ubuntu-24.04-minimal-cloudimg-amd64.img")

  bridge       = var.network.bridge
  ipv4_address = var.config.ipv4_address
  ipv4_gateway = var.network.gateway
  ipv6_address = var.network.ipv6_address
  dns_servers  = var.network.dns_servers

  ssh_public_keys = [trimspace(data.local_file.ssh_key.content)]
  root_password   = var.platform.root_password

  disk_size_gb = var.config.disk_size_gb
  memory_mb    = var.config.memory_mb
  cpu_cores    = var.config.cpu_cores

  start_on_boot = var.platform.start_on_boot
  started       = var.platform.started

  tags = [
    "infrastructure",
    "k8s"
  ]
}
