resource "proxmox_virtual_environment_container" "container" {
  # General
  node_name = var.node_name
  unprivileged = true

  startup {
    order      = 1
    up_delay   = 0
    down_delay = 0
  }

  # Template clone
  operating_system {
    template_file_id = var.disk_image_id
    type             = var.disk_image_type
  }

  # CPU / RAM
  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  # Disk
  disk {
    datastore_id = var.disk_storage
    size         = var.disk_size
  }

  # Network
  network_interface {
    name = var.network_bridge
  }

  # Cloud-init
  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipaddr
        gateway = var.gateway
      }
    }

    dns {
      servers = var.nameservers
    }

    user_account {
      keys = [var.ssh_public_key]
      password = local.container_password
    }
  }
}

resource "random_password" "container_password" {
  count   = var.password == null ? 1 : 0
  length  = 16
  special = true
}

locals {
  container_password = var.password != null ? var.password : random_password.container_password[0].result
}

resource "proxmox_virtual_environment_firewall_options" "container_rules" {
  node_name = proxmox_virtual_environment_container.container.node_name
  container_id = proxmox_virtual_environment_container.container.id

  enabled = var.firewall_enable
}

resource "proxmox_virtual_environment_firewall_rules" "container_rules" {
  node_name = proxmox_virtual_environment_container.container.node_name
  container_id     = proxmox_virtual_environment_container.container.id

  dynamic "rule" {
    for_each = var.firewall_rules

    content {
      action  = rule.value.action
      type    = rule.value.type
      proto   = rule.value.proto
      dport   = rule.value.dport
      sport   = rule.value.sport
      source  = rule.value.source
      dest    = rule.value.dest
      iface   = rule.value.iface
      comment = rule.value.comment
      enabled = rule.value.enabled
      log     = rule.value.log
    }
  }
}
