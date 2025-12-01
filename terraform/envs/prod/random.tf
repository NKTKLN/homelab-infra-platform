resource "random_password" "vm_passwords" {
  for_each = local.vms

  length  = 16
  special = true

  keepers = {
    name = each.key
  }
}