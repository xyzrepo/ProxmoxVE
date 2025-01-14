#!/usr/bin/env bash

# Copyright (c) 2025
# Author: XYZ (xyzrepo)
# License: MIT
# Source: https://www.3cx.com/docs/session-border-controller/

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y \
  curl \
  gnupg \
  wget
msg_ok "Installed Dependencies"

msg_info "Installing 3CX SBC"
wget -O- http://downloads.3cx.com/downloads/3cxsbc.tar | tar -xvf - &>/dev/null
cd 3cxsbc
read -rp "Enter the FQDN or IP of your 3CX Server: " SBC_SERVER_FQDN
read -rp "Enter the Authentication Key for 3CX SBC: " SBC_AUTH_KEY
./install.sh << EOF
$SBC_SERVER_FQDN
$SBC_AUTH_KEY
EOF
msg_ok "Installed 3CX SBC"

msg_info "Setting up Service"
cat <<EOF >/etc/systemd/system/3cxsbc.service
[Unit]
Description=3CX Session Border Controller
After=network-online.target
[Service]
Type=simple
ExecStart=/usr/sbin/3cxsbc
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now 3cxsbc &>/dev/null
msg_ok "Service Created and Started"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove -y &>/dev/null
$STD apt-get autoclean -y &>/dev/null
msg_ok "Cleaned up"
