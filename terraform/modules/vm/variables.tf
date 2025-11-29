variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "target_node" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "template" {
  description = "Name or ID of the template VM to clone from"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Amount of RAM in MB"
  type        = number
}

variable "disk_size" {
  description = "Disk size (e.g. \"20G\")"
  type        = string
}

variable "disk_storage" {
  description = "Proxmox storage pool for the VM disk"
  type        = string
}

variable "network_bridge" {
  description = "Bridge to attach the VM network interface to"
  type        = string
  default     = "vmbr0"
}

variable "ipaddr" {
  description = "IP address to assign to the VM (CIDR format, e.g. 192.168.1.10/24)"
  type        = string
}

variable "gateway" {
  description = "Default gateway for the VM"
  type        = string
}

variable "nameserver" {
  description = "DNS nameserver for the VM"
  type        = string
  default     = "8.8.8.8"
}

variable "ci_user" {
  description = "cloud-init user name"
  type        = string
}

variable "ssh_keys" {
  description = "SSH public keys injected via cloud-init"
  type        = string
}
