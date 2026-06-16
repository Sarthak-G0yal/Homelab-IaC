output "database_vm_id" {
  value       = module.database.vm_id
  description = "Database container ID"
}

output "database_hostname" {
  value       = module.database.hostname
  description = "Database hostname"
}

output "database_ipv4" {
  value       = module.database.ipv4_address
  description = "Database IPv4 address"
}

output "database_ipv4_map" {
  value       = module.database.ipv4_addresses
  description = "All IPv4 addresses by interface"
}

output "database_ipv6_map" {
  value       = module.database.ipv6_addresses
  description = "All IPv6 addresses by interface"
}
