output "vm_passwords" {
  description = "Default user passwords for VMs"
  value       = { for name, m in module.vm : name => m.vm_password }
  sensitive   = true
}
