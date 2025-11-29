#!/usr/bin/env bash
set -e

# Colors (only for labels, main text stays white)
BLUE="\e[34m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

info()  { echo -e "${BLUE}[*]${RESET} $*"; }
ok()    { echo -e "${GREEN}[OK]${RESET} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET} $*"; }
err()   { echo -e "${RED}[ERR]${RESET} $*"; }

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

info "Ensuring netplan uses DHCP on primary interface..."
NETPLAN_FILE=$(ls /etc/netplan/*.yaml 2>/dev/null | head -n1 || true)

if [ -z "$NETPLAN_FILE" ]; then
  warn "Netplan file not found, creating default config..."
  cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: true
EOF
else
  if ! grep -q "dhcp4:" "$NETPLAN_FILE"; then
    warn "# NOTE: configure DHCP manually in $NETPLAN_FILE (no dhcp4 found)."
  fi
fi

netplan apply || true

info "Cleaning SSH host keys (regenerated on clone)..."
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

info "Disabling history (optional)..."
history -c || true

echo
echo -e "${GREEN}=================================================${RESET}"
echo "Template prep done."
echo "Now SHUTDOWN VM and convert it to template in Proxmox:"
echo -e "  ${YELLOW}qm shutdown <VMID>${RESET}"
echo -e "  ${YELLOW}qm template <VMID>${RESET}"
echo -e "${GREEN}=================================================${RESET}"

