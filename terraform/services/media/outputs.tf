output "streaming_vm_id" {
  value       = module.container.vm_id
  description = "Streaming server container ID"
}

output "streaming_hostname" {
  value       = module.container.hostname
  description = "Streaming server hostname"
}

output "streaming_ipv4" {
  value       = module.container.ipv4_address
  description = "Streaming server IPv4 address"
}

output "ip" {
  value       = module.container.ipv4_address
  description = "Primary IPv4 address for streaming"
}
