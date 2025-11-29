module "bastion" {
  source = "../../modules/vm"

  name        = "bastion"
  target_node = var.target_node

  template     = var.template
  cores        = 2
  memory       = 2048
  disk_size    = "20G"
  disk_storage = var.disk_storage

  ci_user     = var.ci_user
  ssh_keys    = file(var.ssh_public_keys)

  ipaddr    = "192.168.10.11/24"
  gateway   = var.gateway
  nameserver = var.nameserver
}

module "vpn" {
  source = "../../modules/vm"

  name        = "vpn"
  target_node = var.target_node

  template     = var.template
  cores        = 1
  memory       = 1024
  disk_size    = "16G"
  disk_storage = var.disk_storage

  ci_user     = var.ci_user
  ssh_keys    = file(var.ssh_public_keys)

  ipaddr    = "192.168.10.12/24"
  gateway   = var.gateway
  nameserver = var.nameserver
}
