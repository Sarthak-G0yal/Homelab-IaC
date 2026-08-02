output "reverse_proxy_vm_id" {
  value       = module.container.vm_id
  description = "Reverse proxy container ID"
}

output "reverse_proxy_hostname" {
  value       = module.container.hostname
  description = "Reverse proxy hostname"
}

output "reverse_proxy_ipv4" {
  value       = module.container.ipv4_address
  description = "Reverse proxy IPv4 address"
}

output "ip" {
  value       = module.container.ipv4_address
  description = "Primary IPv4 address for reverse proxy"
}

output "reverse_proxy_ipv4_map" {
  value       = module.container.ipv4_addresses
  description = "All IPv4 addresses by interface"
}

output "reverse_proxy_ipv6_map" {
  value       = module.container.ipv6_addresses
  description = "All IPv6 addresses by interface"
}
