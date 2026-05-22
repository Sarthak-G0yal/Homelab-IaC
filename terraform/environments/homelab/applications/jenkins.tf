module "jenkins" {
  source = "../../../modules/lxc"

  node_name             = var.jenkins_config.node_name
  vm_id                 = var.jenkins_config.vm_id
  hostname              = "jenkins"
  datastore_id          = var.lxc_datastore_id
  template_datastore_id = var.lxc_template_datastore_id
  bridge                = var.lxc_bridge
  ipv4_address          = var.jenkins_config.ipv4_address
  ipv4_gateway          = var.lxc_ipv4_gateway
  ipv6_address          = var.lxc_ipv6_address
  dns_servers           = var.lxc_dns_servers
  ssh_public_keys       = [trimspace(data.local_file.ssh_key.content)]
  root_password         = var.lxc_root_password
  disk_size_gb          = var.jenkins_config.disk_size_gb
  memory_mb             = var.jenkins_config.memory_mb
  swap_mb               = 1024
  cpu_cores             = var.jenkins_config.cpu_cores
  unprivileged          = true
  nesting               = true
  keyctl                = true
  start_on_boot         = var.lxc_start_on_boot
  started               = var.lxc_started
  template_file_id      = var.lxc_template_file_id
  template_file_name    = var.lxc_template_file_name
  template_url          = local.lxc_template_url
  template_verify       = var.lxc_template_verify
  tags                  = ["application", "jenkins", "ci-cd"]
}
