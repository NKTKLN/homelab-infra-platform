output "vm_password" {
  description = "Default user password for the VM"
  value     = random_password.vm_password.result
  sensitive = true
}
