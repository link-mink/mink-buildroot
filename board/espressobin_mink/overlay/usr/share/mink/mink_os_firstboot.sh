#!/bin/bash

# get from uboot env
MINK_UUID=$(fw_printenv mink_uuid|sed -e 's/.*=//g')
if [ -z "$MINK_UUID" ]
then
    # set uboot env from device.lua
    MINK_UUID=$(cat /usr/share/lua/5.1/device.lua|sed -n -e '2p'|sed -e 's/.*id = "\(.*\)"/\1/g')
    fw_setenv mink_uuid $MINK_UUID
else
    # set mink uuid from uboot env
    sed -i -e "s/id = \".*\"/id = \"$MINK_UUID\"/g" /usr/share/lua/5.1/device.lua
    sed -i -e "s#\(mink/\).*\(/log.*\)#\1$MINK_UUID\2#g" /usr/lib/systemd/system/mink_log.service
    cat /etc/mink/plg_cfg.json.tmpl | sed -e "s/@ID@/$MINK_UUID/g" > /etc/mink/plg_cfg.json
    # reload
    systemctl daemon-reload
    systemctl restart mink_log
    systemctl stop mosquitto
    systemctl stop mink_sysagent
    systemctl stop mink_rt
    systemctl start mosquitto
    systemctl start mink_rt
    systemctl start mink_sysagent
fi
