################################################################################
#
# link-mink/mink-core
#
################################################################################

MINK_CORE_VERSION = dev
MINK_CORE_SITE = git@github.com:link-mink/mink-core.git
MINK_CORE_SITE_METHOD = git
MINK_CORE_LICENSE = MIT
MINK_CORE_LICENSE_FILES = LICENSE
MINK_CORE_INSTALL_STAGING = YES
MINK_CORE_INSTALL_TARGET = YES
MINK_CORE_AUTORECONF = YES
MINK_CORE_CONF_OPTS = \
	--with-gdt-csize=8192 \
        --with-boost-libdir=$(STAGING_DIR)/usr/lib \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT),--enable-sysagent) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_SYSLOG),--enable-syslog) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_LUA),--enable-lua) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_MQTT),--enable-mqtt) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_NDPI),--enable-ndpi) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_UNIX),--enable-unix) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_CGROUP2),--enable-cgroup2) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_SYSTEMD),--enable-systemd) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_CFG_HNDLR),--enable-config-handler) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_MODBUS),--enable-modbus) \
	$(if $(BR2_PACKAGE_MINK_CORE_SYSAGENT_CLIPS),--enable-clips) \
	$(if $(BR2_PACKAGE_MINK_CORE_GDTTRAPC),--enable-gdttrapc) \
	$(if $(BR2_PACKAGE_MINK_CORE_CODEGEN),--enable-codegen) \
	$(if $(BR2_PACKAGE_MINK_CORE_JRPCD),--enable-jrpc --enable-openssl) \
	$(if $(BR2_PACKAGE_MINK_CORE_GRPCD),--enable-grpc) \
	$(if $(BR2_PACKAGE_MINK_CORE_CFGD),--enable-configd) \
	$(if $(BR2_PACKAGE_MINK_CORE_JRPCD_WS),--enable-plain-ws) \
	$(if $(BR2_PACKAGE_MINK_CORE_JRPCD_TLS12),--enable-tlsv12) \
	$(if $(BR2_PACKAGE_MINK_CORE_JRPCD_SS),--enable-ws-single-session)

################################################################################
#
# compile gdt.proto when --enable-grpc is used
#
################################################################################
ifeq ($(BR2_PACKAGE_MINK_CORE_GRPCD),y)
MINK_CORE_PRE_BUILD_HOOKS += GDT_PROTO_COMPILE
endif

define GDT_PROTO_COMPILE
	$(HOST_DIR)/bin/protoc \
		--grpc_out=$(MINK_CORE_BUILDDIR)/src/proto \
		--plugin=protoc-gen-grpc=$(HOST_DIR)/bin/grpc_cpp_plugin \
		-I$(MINK_CORE_BUILDDIR)/src/proto \
		$(MINK_CORE_BUILDDIR)/src/proto/gdt.proto

	$(HOST_DIR)/bin/protoc \
		--cpp_out=$(MINK_CORE_BUILDDIR)/src/proto \
		-I$(MINK_CORE_BUILDDIR)/src/proto \
		$(MINK_CORE_BUILDDIR)/src/proto/gdt.proto
endef

################################################################################
#
# systemd
#
################################################################################
define MINK_CORE_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(MINK_CORE_PKGDIR)/systemd/mink_rt.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mink_rt.service

	$(INSTALL) -D -m 0644 $(MINK_CORE_PKGDIR)/systemd/mink_sysagent.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mink_sysagent.service
endef

$(eval $(autotools-package))
