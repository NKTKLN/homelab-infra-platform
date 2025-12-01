module "vm-sandbox" {
  source = "../../modules/vm"

  # General
  name      = "vm-sandbox"
  hostname  = "vm-sandbox"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk / PCI
  cores        = 2
  memory       = 2048
  disk_size    = 20
  disk_storage = var.disk_storage
  virtiofs     = []
  pci_devices  = []

  # Network
  ipaddr      = "192.168.1.12/24"
  gateway     = var.gateway
  nameservers = var.nameservers

  # Cloud-init user config
  user           = var.user
  password_hash  = bcrypt(random_password.vm_passwords["vm-sandbox"].result)
  ssh_public_key = file(var.ssh_public_key)
  timezone       = var.timezone
  locale         = var.locale

  snippets_storage    = var.snippets_storage
  snippets_node_name  = var.snippets_node_name
  cloud_init_template = "cloud-init-base.yaml.tftpl"

  # Firewall
  firewall_enable = false
}

module "vm-ops-node" {
  source = "../../modules/vm"

  # General
  name      = "vm-ops-node"
  hostname  = "vm-ops-node"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk / PCI
  cores        = 2
  memory       = 3072
  disk_size    = 20
  disk_storage = var.disk_storage
  virtiofs     = []
  pci_devices  = []

  # Network
  ipaddr      = "192.168.1.13/24"
  gateway     = var.gateway
  nameservers = var.nameservers

  # Cloud-init user config
  user           = var.user
  password_hash  = bcrypt(random_password.vm_passwords["vm-ops-node"].result)
  ssh_public_key = file(var.ssh_public_key)
  timezone       = var.timezone
  locale         = var.locale

  snippets_storage    = var.snippets_storage
  snippets_node_name  = var.snippets_node_name
  cloud_init_template = "cloud-init-base.yaml.tftpl"

  # Firewall
  firewall_enable = true

  firewall_rules = [
    # Allow SSH
    {
      action  = "ACCEPT"
      type    = "in"
      proto   = "tcp"
      dport   = "22"
      comment = "Allow SSH"
    },

    # Allow Node Exporter
    {
      action  = "ACCEPT"
      type    = "in"
      proto   = "tcp"
      dport   = "9100"
      comment = "Allow Node Exporter"
    },

    # Drop everything else
    {
      action  = "DROP"
      type    = "in"
      comment = "Drop all other incoming traffic"
    }
  ]
}

module "vm-storage-node" {
  source = "../../modules/vm"

  # General
  name      = "vm-storage-node"
  hostname  = "vm-storage-node"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk / PCI
  cores        = 2
  memory       = 4096
  disk_size    = 32
  disk_storage = var.disk_storage
  virtiofs     = var.virtiofs
  pci_devices  = []
  
  # Network
  ipaddr      = "192.168.1.14/24"
  gateway     = var.gateway
  nameservers = var.nameservers

  # Cloud-init user config
  user           = var.user
  password_hash  = bcrypt(random_password.vm_passwords["vm-storage-node"].result)
  ssh_public_key = file(var.ssh_public_key)
  timezone       = var.timezone
  locale         = var.locale

  snippets_storage    = var.snippets_storage
  snippets_node_name  = var.snippets_node_name
  cloud_init_template = "cloud-init-base.yaml.tftpl"

  # Firewall
  firewall_enable = false
}

module "vm-k8s-master-1" {
  source = "../../modules/vm"

  # General
  name      = "vm-k8s-master-1"
  hostname  = "vm-k8s-master-1"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk / PCI
  cores        = 4
  memory       = 6144
  disk_size    = 40
  disk_storage = var.disk_storage
  virtiofs     = []
  pci_devices  = []

  # Network
  ipaddr      = "192.168.1.15/24"
  gateway     = var.gateway
  nameservers = var.nameservers

  # Cloud-init user config
  user           = var.user
  password_hash  = bcrypt(random_password.vm_passwords["vm-k8s-master-1"].result)
  ssh_public_key = file(var.ssh_public_key)
  timezone       = var.timezone
  locale         = var.locale

  snippets_storage    = var.snippets_storage
  snippets_node_name  = var.snippets_node_name
  cloud_init_template = "cloud-init-base.yaml.tftpl"

  # Firewall
  firewall_enable = false
}

module "vm-k8s-worker-1" {
  source = "../../modules/vm"

  # General
  name      = "vm-k8s-worker-1"
  hostname  = "vm-k8s-worker-1"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk / PCI
  cores        = 4
  memory       = 6144
  disk_size    = 40
  disk_storage = var.disk_storage
  virtiofs     = []
  pci_devices  = []

  # Network
  ipaddr      = "192.168.1.16/24"
  gateway     = var.gateway
  nameservers = var.nameservers

  # Cloud-init user config
  user           = var.user
  password_hash  = bcrypt(random_password.vm_passwords["vm-k8s-worker-1"].result)
  ssh_public_key = file(var.ssh_public_key)
  timezone       = var.timezone
  locale         = var.locale

  snippets_storage    = var.snippets_storage
  snippets_node_name  = var.snippets_node_name
  cloud_init_template = "cloud-init-base.yaml.tftpl"

  # Firewall
  firewall_enable = false
}

module "vm-k8s-gpu-worker-1" {
  source = "../../modules/vm"

  # General
  name      = "vm-k8s-gpu-worker-1"
  hostname  = "vm-k8s-gpu-worker-1"
  node_name = var.node_name

  # Template clone
  template_id = var.template_id

  # CPU / RAM / Disk / GPU / PCI
  cores        = 4
  memory       = 8192
  disk_size    = 60
  disk_storage = var.disk_storage
  virtiofs     = []
  pci_devices  = var.pci_devices

  # Network
  ipaddr      = "192.168.1.17/24"
  gateway     = var.gateway
  nameservers = var.nameservers

  # Cloud-init user config
  user           = var.user
  password_hash  = bcrypt(random_password.vm_passwords["vm-k8s-gpu-worker-1"].result)
  ssh_public_key = file(var.ssh_public_key)
  timezone       = var.timezone
  locale         = var.locale

  snippets_storage    = var.snippets_storage
  snippets_node_name  = var.snippets_node_name
  cloud_init_template = "cloud-init-base.yaml.tftpl"

  # Firewall
  firewall_enable = false
}
