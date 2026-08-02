output "jenkins_vm_id" {
  value       = module.jenkins.vm_id
  description = "Jenkins container ID"
}

output "jenkins_hostname" {
  value       = module.jenkins.hostname
  description = "Jenkins hostname"
}

output "jenkins_ipv4" {
  value       = module.jenkins.ipv4_address
  description = "Jenkins IPv4 address"
}
