#!/bin/sh

set -u
set -e

# generate uuid
UUID="$(uuidgen)"
# copy mink lua module and scripts
cp ${TARGET_DIR}/usr/share/mink/*.lua ${TARGET_DIR}/usr/share/lua/5.1
# set device uuid in lua scripts
sed -i -e "s/@ID@/$UUID/g" ${TARGET_DIR}/usr/share/lua/5.1/device.lua
sed -i -e "s/@ID@/$UUID/g" ${TARGET_DIR}/etc/mink/plg_cfg.json
# set device uuid in systemd service files
sed -i -e "s/@ID@/$UUID/g" ${TARGET_DIR}/usr/lib/systemd/system/mink_log.service
# remove plugin symlinks
find ${TARGET_DIR}/usr/lib/mink -type l -exec rm {} \;
# system plugin should be first
test -f ${TARGET_DIR}/usr/lib/mink/plg_sysagent_system.so.1.0.0 && \
    { mv ${TARGET_DIR}/usr/lib/mink/plg_sysagent_system.so.1.0.0 \
         ${TARGET_DIR}/usr/lib/mink/00-plg_sysagent_system.so.1.0.0; }
# update os-release
MINK_OS_VER=$(cd "$CONFIG_DIR/.." && git rev-parse HEAD)
sed -i -e "s/\(NAME=\)\(.*\)/\1mINK_OS/g" ${TARGET_DIR}/etc/os-release
sed -i -e "s/\(VERSION=\)\(.*\)/\1${MINK_OS_VER}/g" ${TARGET_DIR}/etc/os-release
sed -i -e "s/\(ID=\)\(.*\)/\1mink_os/g" ${TARGET_DIR}/etc/os-release
sed -i -e "s/\(VERSION_ID=\)\(.*\)/\1${MINK_OS_VER}/g" ${TARGET_DIR}/etc/os-release
sed -i -e "s/\(PRETTY_NAME=\)\(.*\)/\1\"mINK OS\"/g" ${TARGET_DIR}/etc/os-release
# fix systemd firstboot
rm ${TARGET_DIR}/etc/machine-id
# info
echo "==============================================="
echo "           ___ _   _ _  __   ___  ____"
echo " _ __ ___ |_ _| \ | | |/ /  / _ \/ ___|"
echo "| '_ \` _ \ | ||  \| | ' /  | | | \\___ \\"
echo "| | | | | || || |\  | . \  | |_| |___) |"
echo "|_| |_| |_|___|_| \_|_|\_\  \___/|____/"
echo "==============================================="
echo "Version: $MINK_OS_VER"
echo "Device UUID: $UUID"
echo "==============================================="
