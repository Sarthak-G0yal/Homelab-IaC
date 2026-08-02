output "dns_vm_id" {
  value       = module.container.vm_id
  description = "DNS container ID"
}

output "dns_hostname" {
  value       = module.container.hostname
  description = "DNS hostname"
}

output "dns_ipv4" {
  value       = module.container.ipv4_address
  description = "DNS IPv4 address"
}

output "dns_ipv4_map" {
  value       = module.container.ipv4_addresses
  description = "All IPv4 addresses by interface"
}

output "dns_ipv6_map" {
  value       = module.container.ipv6_addresses
  description = "All IPv6 addresses by interface"
}

output "ip" {
  value       = module.container.ipv4_address
  description = "Primary IPv4 address for dns"
}
