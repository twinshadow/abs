#!/bin/bash
(which svn > /dev/null 2>&1) || exit 2

svn checkout svn://svn.archlinux.org/packages/linux/trunk . || exit 2

mv linux.install linux-ib.install
mv linux.preset linux-ib.preset

sed -i'' -e 's/^pkgname=.*/pkgname=\("linux-ib" "linux-ib-headers"\)/;
             s/^package_linux()/package_linux-ib()/;
             s/^package_linux-headers()/package_linux-ib-headers()/;
             /^makedepends=/D;' PKGBUILD

sed -i'' -e '/^\s\s*\(provides\|conflicts\|replaces\)/D' PKGBUILD

for CONFIG in config config.x86_64; do
  sed -i'' -e 's/# CONFIG_INFINIBAND is not set/CONFIG_INFINIBAND=m/p' $CONFIG &&\
  echo "\
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_QIB=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m" >> $CONFIG
done

echo 'Build the kernel with "makepkg --skipinteg"'
