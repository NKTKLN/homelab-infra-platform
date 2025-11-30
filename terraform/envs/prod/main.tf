module "bastion" {
  source = "../../modules/vm"

  # General
  name      = "bastion"
  hostname  = "bastion"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk
  cores        = 2
  memory       = 2048
  disk_size    = 20
  disk_storage = var.disk_storage

  # Network
  ipaddr          = "192.168.10.11/24"
  gateway         = var.gateway
  nameserver      = var.nameserver

  # Cloud-init user config
  user              = var.user
  password_hash     = var.password_hash
  ssh_public_key    = var.ssh_public_key
  timezone          = var.timezone
  locale            = var.locale

  snippets_storage     = var.snippets_storage
  cloud_init_template  = "cloud-init-base.yaml.tftpl"
}
