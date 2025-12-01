# Proxmox API Configuration

variable "pve_api_url" {
  description = "Base URL of the Proxmox API (e.g. https://proxmox.example.com:8006/api2/json)"
  type        = string
}

variable "pve_token_id" {
  description = "Proxmox API token ID in the format user@realm!tokenname"
  type        = string
}

variable "pve_token_secret" {
  description = "Secret value of the Proxmox API token"
  type        = string
  sensitive   = true
}

variable "pve_tls_insecure" {
  description = "Whether to skip TLS certificate verification when connecting to the Proxmox API"
  type        = bool
  default     = true
}

variable "pve_ssh_username" {
  description = "SSH username used by Terraform to connect to the Proxmox host"
  type        = string
}

# Virtual Machine Template

variable "template_id" {
  description = "ID of the VM template to clone"
  type        = number
}

variable "node_name" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "disk_storage" {
  description = "Proxmox storage pool to use for the VM disk"
  type        = string
}

# Network Configuration

variable "gateway" {
  description = "Default network gateway for the VM"
  type        = string
}

variable "nameservers" {
  description = "DNS nameservers for the VM"
  type        = list(string)
  default     = ["8.8.8.8"]
}

# Cloud-init Settings

variable "snippets_storage" {
  description = "Proxmox datastore used for Cloud-Init snippets"
  type        = string
}

variable "user" {
  description = "Default user name for the VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to inject into the VM using cloud-init"
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

# VirtioFS Shared Directory

variable "virtiofs_name" {
  description = "Name of the VirtioFS hardware mapping directory"
  type        = string
  default     = "storage-node-hard-drive"
}

variable "virtiofs_node" {
  description = "Proxmox node where the VirtioFS directory exists"
  type        = string
  default     = "pve"
}

variable "virtiofs_path" {
  description = "Filesystem path to the shared directory for VirtioFS"
  type        = string
}
