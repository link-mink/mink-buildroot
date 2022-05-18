################################################################################
#
# nDPI
#
################################################################################
NDPI_VERSION = dev
NDPI_SITE = git@github.com:ntop/nDPI.git
NDPI_SITE_METHOD = git
NDPI_LICENSE = LGPL-3.0
NDPI_LICENSE_FILE = COPYING
NDPI_INSTALL_STAGING = YES
NDPI_INSTALL_TARGET = YES
NDPI_AUTORECONF = YES

$(eval $(autotools-package))
