resource "proxmox_virtual_environment_vm" "vm" {
  # General
  name      = var.name
  node_name = var.node_name
  
  startup {
    order      = 1
    up_delay   = 0
    down_delay = 0
  }

  # Template clone
  clone {
    vm_id        = var.template_id
    full         = true
    datastore_id = var.disk_storage 
  }

  # CPU / RAM
  cpu {
    sockets = 1
    cores   = var.cores
  }

  memory {
    dedicated = var.memory
  }

  # Guest Agent
  agent {
    enabled = true
  }

  # Disk
  disk {
    datastore_id = var.disk_storage
    size         = var.disk_size
    interface    = "scsi0"
  }

  # Network
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  # Cloud-init
  initialization {
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_init.id
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_init" {
  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = var.node_name

  source_raw {
    data = templatefile("${path.module}/templates/${var.cloud_init_template}", {
      hostname       = var.hostname
      ipaddr         = var.ipaddr
      gateway        = var.gateway
      nameserver     = var.nameserver
      user           = var.user
      password_hash  = var.password_hash
      ssh_public_key = var.ssh_public_key
      timezone       = var.timezone
      locale         = var.locale
    })

    file_name = "${var.name}-user-data.yaml"
  }
}
