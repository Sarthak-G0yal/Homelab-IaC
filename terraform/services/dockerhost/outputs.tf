output "server_docker_vm_id" {
  value       = module.server_docker.vm_id
  description = "server-docker container ID"
}

output "server_docker_hostname" {
  value       = module.server_docker.hostname
  description = "server-docker hostname"
}

output "server_docker_ipv4" {
  value       = module.server_docker.ipv4_address
  description = "server-docker IPv4 address"
}
