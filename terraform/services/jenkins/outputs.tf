output "jenkins_vm_id" {
  value       = module.container.vm_id
  description = "Jenkins container ID"
}

output "jenkins_hostname" {
  value       = module.container.hostname
  description = "Jenkins hostname"
}

output "jenkins_ipv4" {
  value       = module.container.ipv4_address
  description = "Jenkins IPv4 address"
}

output "ip" {
  value       = module.container.ipv4_address
  description = "Primary IPv4 address for jenkins"
}
