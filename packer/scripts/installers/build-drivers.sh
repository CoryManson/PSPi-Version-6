#!/bin/bash -e
################################################################################
##  File:  build-drivers.sh
##  Desc:  Installs required dependencies for PSPi6 drivers & builds them
################################################################################
set -x

detect_architecture() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64|aarch64)
            echo "64-bit OS detected"
            ARCH_SUFFIX="_64"
            ;;
        *)
            echo "32-bit OS detected"
            ARCH_SUFFIX="_32"
            ;;
    esac
}
detect_architecture

# Install Dependencies
apt-get update
apt-get install make libraspberrypi-dev raspberrypi-kernel-headers libpng-dev libasound2-dev git autoconf gcc-arm-linux-gnueabi -y

mkdir -p /packer/drivers/bin
cd /packer/drivers
make --file Makefile$ARCH_SUFFIX clean
make --file Makefile$ARCH_SUFFIX all

# Build patchelf
git clone https://github.com/NixOS/patchelf.git
cd patchelf
./bootstrap.sh
./configure
make
make check
make install

# Patch OSD Driver
patchelf --replace-needed libbcm_host.so.0 libbcm_host.so ../bin/osd
