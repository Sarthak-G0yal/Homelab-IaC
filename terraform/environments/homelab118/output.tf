output "docker_ip" {
  value = module.dockerhost.ip
}

output "postgres_ip" {
  value = module.databases.ip
}

output "gitea_ip" {
  value = module.gitea.ip
}

output "traefik_ip" {
  value = module.reverseproxy.ip
}

output "dns_ip" {
  value = module.dns.ip
}

output "jenkins_ip" {
  value = module.jenkins.ip
}

output "media_ip" {
  value = module.media.ip
}

output "bastion_vault_ip" {
  value = module.bastionvault.ip
}
