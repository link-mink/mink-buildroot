#!/bin/sh

set -u
set -e

UUID="$(uuidgen)"

cp ${TARGET_DIR}/usr/share/mink/*.lua ${TARGET_DIR}/usr/share/lua/5.1
sed -i -e "s/@ID@/$UUID/g" ${TARGET_DIR}/usr/share/lua/5.1/device.lua
sed -i -e "s/@ID@/$UUID/g" ${TARGET_DIR}/etc/mink/plg_cfg.json

