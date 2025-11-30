#!/usr/bin/env bash
set -e

# ========================================================
#  Proxmox VM Template Preparation Script
# ========================================================
#
# Description:
# This script prepares a VM to be converted into a Proxmox template.
# It installs required packages, resets machine identifiers, configures
# networking, clears logs, and performs security adjustments such as
# disabling SSH root login and configuring sudo access.
#
# Usage:
#   - Run inside VM as root
#   - After script finishes, SHUT DOWN the VM and convert it to template:
#         qm shutdown <VMID>
#         qm template <VMID>
#
# ========================================================

# Colors
BLUE="\e[34m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
MAGENTA="\e[35m"
RESET="\e[0m"

info()  { echo -e "${BLUE}[*]${RESET} $*"; }
ok()    { echo -e "${GREEN}[OK]${RESET} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET} $*"; }
err()   { echo -e "${RED}[ERR]${RESET} $*"; }
ask()   { echo -e "${MAGENTA}[?]${RESET} $*"; }

info "Checking root..."
if [ "$(id -u)" -ne 0 ]; then
  err "Run as root (sudo -i)."
  exit 1
fi

info "Updating system..."
apt-get update -y
apt-get upgrade -y
apt-get install -y qemu-guest-agent cloud-init cloud-initramfs-growroot

info "Enabling qemu-guest-agent..."
systemctl enable --now qemu-guest-agent

info "Enabling cloud-init ..."
systemctl enable --now cloud-init

cat /etc/cloud/cloud.cfg.d/99-pve-network.cfg <<EOF
network:
  config: disabled
EOF

info "Cleaning SSH host keys..."
rm -f /etc/ssh/ssh_host_*

info "Resetting machine-id..."
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

info "Cleaning logs & temp..."
rm -rf /var/log/*
rm -rf /tmp/*
rm -rf /var/tmp/*

info "Cleaning cloud-init state..."
cloud-init clean --logs || true

ask "Do you want to grant passwordless sudo to a user? (y/n)"
read -rp "> " GRANT_SUDO
GRANT_SUDO=${GRANT_SUDO,,}

if [[ "$GRANT_SUDO" == "y" ]]; then
  ask "Enter the username:"
  read -rp "> " TEMPLATE_USER

  if [ -z "$TEMPLATE_USER" ]; then
    err "Username cannot be empty."
    exit 1
  fi
fi

info "Giving '$TEMPLATE_USER' full sudo privileges (NOPASSWD)..."
echo "$TEMPLATE_USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/90-$TEMPLATE_USER"
chmod 440 "/etc/sudoers.d/90-$TEMPLATE_USER"

echo
echo -e "${GREEN}=================================================${RESET}"
echo "Template prep done."
echo "Now SHUTDOWN VM and convert it to template in Proxmox:"
echo -e "  ${YELLOW}qm shutdown <VMID>${RESET}"
echo -e "  ${YELLOW}qm template <VMID>${RESET}"
echo -e "${GREEN}=================================================${RESET}"
