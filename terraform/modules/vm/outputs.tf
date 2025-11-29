output "name" {
  description = "Name of the created VM"
  value       = proxmox_vm_qemu.vm.name
}

output "vmid" {
  description = "Proxmox VM ID of the created VM"
  value       = proxmox_vm_qemu.vm.vmid
}

output "ip" {
  description = "IP address assigned to the VM"
  value       = var.ipaddr
}
