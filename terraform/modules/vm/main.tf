resource "proxmox_virtual_environment_vm" "vm" {
  # General
  name      = var.name
  node_name = var.node_name
  
  machine = "q35,viommu=virtio"
  
  startup {
    order      = 1
    up_delay   = 0
    down_delay = 0
  }

  agent {
    enabled = true
    timeout = "5m"
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

  # Disks
  disk {
    datastore_id = var.disk_storage
    size         = var.disk_size
    interface    = "scsi0"
  }

  dynamic "virtiofs" {
    for_each = proxmox_virtual_environment_hardware_mapping_dir.shared_dir

    content {
      mapping   = virtiofs.value.name
      cache     = "always"
      direct_io = true
    }
  }

  # PCI
  dynamic "hostpci" {
    for_each = proxmox_virtual_environment_hardware_mapping_pci.shared_pci

    content {
      device  = "hostpci${hostpci.key}"
      mapping = hostpci.value.name
      pcie    = true
    }
  }

  # Network
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  # Cloud-init
  initialization {
    user_data_file_id = proxmox_virtual_environment_file.vm_cloud_init.id

    ip_config {
      ipv4 {
        address = var.ipaddr
        gateway = var.gateway
      }
    }

    dns {
      servers = var.nameservers
    }
  }
}

resource "proxmox_virtual_environment_file" "vm_cloud_init" {
  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = var.snippets_node_name

  source_raw {
    data = templatefile("${path.module}/templates/${var.cloud_init_template}", {
      hostname       = var.hostname
      user           = var.user
      password_hash  = var.password_hash
      ssh_public_key = var.ssh_public_key
      timezone       = var.timezone
      locale         = var.locale
    })

    file_name = "${var.name}-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_hardware_mapping_dir" "shared_dir" {
  for_each = { for v in var.virtiofs : v.name => v }

  name = each.value.name

  map = [{
    comment = each.value.comment
    node    = coalesce(each.value.node, var.node_name)
    path    = each.value.path
  }]
}

resource "proxmox_virtual_environment_hardware_mapping_pci" "shared_pci" {
  for_each = { for idx, v in var.pci_devices : idx => v }

  name = each.value.name

  map = [{
    comment      = each.value.comment
    node         = coalesce(each.value.node, var.node_name)
    path         = each.value.path
    id           = each.value.id
    iommu_group  = each.value.iommu_group
    subsystem_id = each.value.subsystem_id
  }]

  mediated_devices = each.value.mediated_devices
}

resource "proxmox_virtual_environment_firewall_options" "vm_rules" {
  depends_on = [proxmox_virtual_environment_vm.vm]

  node_name = proxmox_virtual_environment_vm.vm.node_name
  vm_id     = proxmox_virtual_environment_vm.vm.vm_id

  enabled = var.firewall_enable
}

resource "proxmox_virtual_environment_firewall_rules" "vm_rules" {
  depends_on = [proxmox_virtual_environment_vm.vm]

  node_name = proxmox_virtual_environment_vm.vm.node_name
  vm_id     = proxmox_virtual_environment_vm.vm.vm_id

  dynamic "rule" {
    for_each = var.firewall_rules

    content {
      type    = rule.value.type
      action  = rule.value.action
      proto   = rule.value.proto
      dport   = rule.value.dport
      sport   = rule.value.sport
      comment = rule.value.comment
      source  = rule.value.source
      dest    = rule.value.dest
      iface   = rule.value.iface
      enabled = lookup(rule.value, "enabled", true)
      log     = lookup(rule.value, "log", false)
    }
  }
}
