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
# remove plugin symlinks
find ${TARGET_DIR}/usr/lib/mink -type l -exec rm {} \;
# system plugin should be first
mv  ${TARGET_DIR}/usr/lib/mink/plg_sysagent_system.so.1.0.0  ${TARGET_DIR}/usr/lib/mink/00-plg_sysagent_system.so.1.0.0
