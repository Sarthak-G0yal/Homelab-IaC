module "server_docker" {
  source   = "../../services/server-docker"
  config   = var.server_docker_config
  network  = var.network
  platform = var.platform
}

module "postgres" {
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

module "traefik" {
  source = "../../services/reverseproxy"

  config   = var.reverse_proxy_config
  network  = var.network
  platform = var.platform
}
