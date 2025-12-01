output "vm_passwords" {
  description = "Default user passwords for the VMs"
  value = {
    for name, pw in random_password.vm_passwords :
    name => pw.result
  }
  sensitive = true
}
