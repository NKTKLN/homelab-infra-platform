output "name" {
  description = "Name of the created VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "id" {
  description = "Proxmox VM ID of the created VM"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "ipv4" {
  description = "IPv4 address assigned to the VM"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses
}
