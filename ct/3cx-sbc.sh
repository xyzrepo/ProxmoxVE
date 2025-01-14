#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/xyzrepo/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2025
# Author: XYZ (xyzrepo)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://www.3cx.com/docs/session-border-controller/

# App Default Values
APP="3CX SBC"
var_tags="voip;sbc;3cx"
var_cpu="1"
var_ram="512"
var_disk="10"
var_os="debian"
var_version="11"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} The installer will now configure the application.${CL}"

bash -c "$(wget -qLO - https://raw.githubusercontent.com/xyzrepo/ProxmoxVE/main/install/3cx-sbc-install.sh)"
