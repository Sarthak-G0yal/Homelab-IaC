output "vm_id" {
  value       = proxmox_virtual_environment_vm.this.vm_id
  description = "VM ID"
}

output "hostname" {
  value       = var.hostname
  description = "VM hostname"
}

output "ipv4_address" {
  value       = split("/", var.ipv4_address)[0]
  description = "Primary IPv4 address"
}
