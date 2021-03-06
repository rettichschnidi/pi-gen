#!/bin/bash -e

set -e

export BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Set up DigiGes image"
echo " - Delete stages 3 to 5"
rm -rf ${BASE_DIR}/stage{3,4,5}

echo " - Replace stage 3 with our scripts"
cp -ra ${BASE_DIR}/stage3-digiges ${BASE_DIR}/stage3

echo " - Adapt image name"
echo "IMG_NAME=DigOnPi" > ${BASE_DIR}/config

echo "Speed up build"
echo " - Remove build tools from image"
sed -i "/build-essential manpages-dev python bash-completion gdb pkg-config/d" ${BASE_DIR}/stage2/01-sys-tweaks/00-packages
sed -i "/libraspberrypi-dev libraspberrypi-doc libfreetype6-dev/d" ${BASE_DIR}/stage2/01-sys-tweaks/00-packages

echo " - Do not export NOOBS"
rm -f ${BASE_DIR}/stage2/EXPORT_NOOBS

echo " - Do not install locales"
rm -rf ${BASE_DIR}/stage0/01-locale

echo "Shrink attack surface"
echo " - Do not install service avahi-daemon"
sed -i "/avahi-daemon/d" ${BASE_DIR}/stage2/01-sys-tweaks/00-packages
