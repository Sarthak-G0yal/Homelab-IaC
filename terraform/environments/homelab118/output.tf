output "docker_ip" {
  value = module.server_docker.ip
}

output "postgres_ip" {
  value = module.postgres.ip
}

output "gitea_ip" {
  value = module.gitea.ip
}

output "traefik_ip" {
  value = module.traefik.ip
}
