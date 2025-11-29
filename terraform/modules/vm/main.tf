resource "proxmox_vm_qemu" "vm" {
  # General parameters
  name        = var.name
  target_node = var.target_node
  onboot      = true

  # Source VM (template)
  clone      = var.template
  full_clone = true

  # Resources
  memory = var.memory
  scsihw = "virtio-scsi-pci"

  cpu {
    sockets = 1
    cores   = var.cores
  }

  disk {
    type    = "disk"
    slot    = "scsi0"
    size    = var.disk_size
    storage = var.disk_storage
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.network_bridge
  }

  # cloud-init configuration
  agent      = 1
  ciuser     = var.ci_user
  sshkeys    = var.ssh_keys

  ipconfig0  = "ip=${var.ipaddr},gw=${var.gateway}"
  nameserver = var.nameserver

  lifecycle {
    ignore_changes = [
      network,
      sshkeys,
    ]
  }
}
