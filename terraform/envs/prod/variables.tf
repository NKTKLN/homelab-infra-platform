# Proxmox API

variable "pm_api_url" {
  description = "Base URL of the Proxmox API (e.g. https://proxmox.example.com:8006/api2/json)"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID (format: user@realm!tokenname)"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Secret value of the Proxmox API token"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Whether to skip TLS certificate verification when connecting to the Proxmox API"
  type        = bool
  default     = true
}

# VM parameters

variable "target_node" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "template" {
  description = "Name or ID of the template VM to clone from"
  type        = string
}

variable "disk_storage" {
  description = "Proxmox storage pool for the VM disk"
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

variable "ssh_public_keys" {
  description = "SSH public key injected via cloud-init"
  type        = string
}
