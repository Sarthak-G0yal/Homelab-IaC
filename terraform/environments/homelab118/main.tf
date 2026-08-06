module "dockerhost" {
  source   = "../../services/server-docker"
  config   = var.server_docker_config
  network  = var.network
  platform = var.platform
}

module "databases" {
  source = "../../services/databases"

  config   = var.postgres_config
  network  = var.network
  platform = var.platform
}

module "gitea" {
  source = "../../services/gitea"

  config   = var.gitea_config
  network  = var.network
  platform = var.platform
}

module "reverseproxy" {
  source = "../../services/reverseproxy"

  config   = var.reverse_proxy_config
  network  = var.network
  platform = var.platform
}

module "dns" {
  source = "../../services/dns"

  config   = var.dns_config
  network  = var.network
  platform = var.platform
}

module "jenkins" {
  source = "../../services/jenkins"

  config   = var.jenkins_config
  network  = var.network
  platform = var.platform
}

module "media" {
  source = "../../services/media"

  config   = var.plex_config
  network  = var.network
  platform = var.platform
}

module "bastionvault" {
  source = "../../services/bastionvault"

  config   = var.bastion_vault_config
  network  = var.network
  platform = var.platform
}

module "k3s-control" {
  source = "../../services/k3s-control"

  config   = var.k3s_control_config
  network  = var.network
  platform = var.platform
}

module "k3s-worker-1" {
  source = "../../services/k3s-worker-1"

  config   = var.k3s_worker_1_config
  network  = var.network
  platform = var.platform
}
