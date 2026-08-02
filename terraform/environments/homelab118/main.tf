module "dockerhost" {
  source = "../../services/dockerhost"

  config   = var.server_docker_config
  network  = var.network
  defaults = var.platform
}

module "postgres" {
  source = "../../services/databases"

  config   = var.postgres_config
  network  = var.network
  defaults = var.platform

  docker_ip = module.dockerhost.ip
}

module "gitea" {
  source = "../../services/gitea"

  config   = var.gitea_config
  network  = var.network
  defaults = var.platform

  postgres_ip = module.postgres.ip
}

module "traefik" {
  source = "../../services/reverseproxy"

  config   = var.reverse_proxy_config
  network  = var.network
  defaults = var.platform

  docker_ip = module.dockerhost.ip
}
