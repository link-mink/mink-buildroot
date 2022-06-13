[<div align="center"><img src="http://139.162.200.34/mink.png"></div>](https://github.com/dfranusic/mink)

##### *mINK Package for Buildroot*

##### Raspberry Pi2 How-To
```shell
$ make raspberrypi2_mink_defconfig
$ make menuconfig BR2_EXTERNAL=../
(select mINK package(s) and options)
$ make
$ dd if=output/images/sdcard.img of=/dev/sdX bs=4M conv=fsync
```

----
## mINK Core
`BR2_PACKAGE_LINK_MINK_CORE` - core components ( **routingd** and **libgdt** )

`BR2_PACKAGE_LINK_MINK_CORE_GDTTRAPC` - GDT Trap Client

`BR2_PACKAGE_LINK_MINK_CORE_CODEGEN` - Sysagent Plugin source code generator

`BR2_PACKAGE_LINK_MINK_CORE_GRPCD` - gRPC Daeemon

`BR2_PACKAGE_LINK_MINK_CORE_JRPCD` - JSON RPC 2.0 Daemon


## mINK System Agent
`BR2_PACKAGE_LINK_MINK_CORE_SYSAGENT` - System Agent Daemon

`BR2_PACKAGE_LINK_MINK_CORE_SYSAGENT_SYSLOG` - enable syslog plugin

`BR2_PACKAGE_LINK_MINK_CORE_SYSAGENT_OPENWRT` - enable OpenWrt support


## mINK JSON RPC 2.0 Daemon
`BR2_PACKAGE_LINK_MINK_CORE_JRPCD_WS` - enable plain ws support ( **ws://** )

`BR2_PACKAGE_LINK_MINK_CORE_JRPCD_TLS12` - enable **TLSv1.2** support

`BR2_PACKAGE_LINK_MINK_CORE_JRPCD_SS` - enable single user session mode


### License
----
This software is licensed under the MIT license
