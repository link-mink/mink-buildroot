#!/bin/bash

MINK_UUID=$(cat /usr/share/lua/5.1/device.lua|sed -n -e '2p'|sed -e 's/.*id = "\(.*\)"/\1/g')
fw_setenv mink_uuid $MINK_UUID
