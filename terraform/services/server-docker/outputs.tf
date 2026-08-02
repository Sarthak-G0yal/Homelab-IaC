output "server_docker_vm_id" {
  value       = module.container.vm_id
  description = "server-docker container ID"
}

output "server_docker_hostname" {
  value       = module.container.hostname
  description = "server-docker hostname"
}

output "server_docker_ipv4" {
  value       = module.container.ipv4_address
  description = "server-docker IPv4 address"
}

output "ip" {
  value       = module.container.ipv4_address
  description = "Primary IPv4 address for server-docker"
}
