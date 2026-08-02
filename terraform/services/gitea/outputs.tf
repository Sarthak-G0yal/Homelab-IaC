output "gitea_vm_id" {
  value       = module.gitea.vm_id
  description = "Gitea container ID"
}

output "gitea_hostname" {
  value       = module.gitea.hostname
  description = "Gitea hostname"
}

output "gitea_ipv4" {
  value       = module.gitea.ipv4_address
  description = "Gitea IPv4 address"
}

output "ip" {
  value       = module.gitea.ipv4_address
  description = "Primary IPv4 address for gitea"
}
