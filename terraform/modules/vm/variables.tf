# General VM Parameters

variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "hostname" {
  description = "Hostname for the VM"
  type        = string
}

variable "node_name" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "template_id" {
  description = "ID of the template VM to clone from"
  type        = number
}

# Hardware Configuration

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Amount of RAM in MB"
  type        = number
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
}

variable "disk_storage" {
  description = "Proxmox storage pool for the VM disk"
  type        = string
}

# Network Configuration

variable "network_bridge" {
  description = "Bridge to attach the VM network interface to"
  type        = string
  default     = "vmbr0"
}

variable "ipaddr" {
  description = "IP address for the VM in CIDR format (e.g. 192.168.1.10/24)"
  type        = string
}

variable "gateway" {
  description = "Default network gateway for the VM"
  type        = string
}

variable "nameservers" {
  description = "DNS nameservers for the VM"
  type        = list(string)
  default     = ["8.8.8.8"]
}

# Cloud-init Configuration

variable "snippets_storage" {
  description = "Proxmox datastore used for Cloud-Init snippets"
  type        = string
}

variable "cloud_init_template" {
  description = "Path to the Cloud-Init template file"
  type        = string
}

variable "user" {
  description = "Default user name for the VM"
  type        = string
}

variable "password_hash" {
  description = "Default user password hash for the VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to inject via cloud-init"
  type        = string
}

variable "timezone" {
  description = "Timezone for the VM"
  type        = string
  default     = "Europe/Moscow"
}

variable "locale" {
  description = "System locale for the VM"
  type        = string
  default     = "ru_RU.UTF-8"
}

# Firewall

variable "firewall_enable" {
  description = "Enable or disable the Proxmox firewall for the VM"
  type        = bool
  default     = false
}

variable "firewall_rules" {
  description = "List of firewall rules to apply to the VM."
  type = list(object({
    # REQUIRED
    action = string
    type   = string

    # OPTIONAL
    proto   = optional(string)
    dport   = optional(string)
    sport   = optional(string)
    source  = optional(string)
    dest    = optional(string)
    iface   = optional(string)
    log     = optional(string)
    comment = optional(string)
    enabled = optional(bool)
  }))
  default = []
}
