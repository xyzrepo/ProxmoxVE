#!/usr/bin/env bash

# Copyright (c) 2025
# Author: XYZ (xyzrepo)
# License: MIT
# Source: https://www.3cx.com/docs/session-border-controller/

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors

# Variables
VMID=101  # Change to desired VM ID
VM_NAME="3cx-debian"
ISO_URL="https://downloads-global.3cx.com/downloads/debian12iso/debian-amd64-netinst-3cx.iso"
ISO_FILE="debian-3cx.iso"

msg_info "Downloading 3CX Debian ISO"
wget -O $ISO_FILE $ISO_URL
if [[ $? -ne 0 || ! -s $ISO_FILE ]]; then
    msg_error "Failed to download the 3CX Debian ISO. Check the URL or network connection."
    exit 1
fi
msg_ok "Downloaded 3CX Debian ISO"

msg_info "Creating Proxmox VM for 3CX SBC"
qm create $VMID --name "$VM_NAME" --memory 1024 --cores 2 --net0 virtio,bridge=vmbr0
msg_ok "Created VM $VMID ($VM_NAME)"

msg_info "Importing ISO to VM"
qm importdisk $VMID $ISO_FILE local-lvm
qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$VMID-disk-0
qm set $VMID --boot c --bootdisk scsi0
msg_ok "ISO Attached to VM"

msg_info "Starting 3CX VM"
qm start $VMID
msg_ok "3CX VM Started"

msg_info "Cleaning up ISO file"
rm -f $ISO_FILE
msg_ok "Cleaned up temporary files"

msg_ok "Installation script completed successfully!\n"
echo -e "${INFO} Access the Proxmox console for VM $VMID to complete the 3CX SBC installation."
