output "bastion_vault_vm_id" {
  value       = module.bastion_vault.vm_id
  description = "BastionVault container ID"
}

output "bastion_vault_hostname" {
  value       = module.bastion_vault.hostname
  description = "BastionVault hostname"
}

output "bastion_vault_ipv4" {
  value       = module.bastion_vault.ipv4_address
  description = "BastionVault IPv4 address"
}
