#!/bin/bash
#
#ejc-01.06.2024
#Last updated: 01.06.2024
#Post Build Script
#Cyclone V SoC FPGA
#
#
targetFileSystem=$1

echo "Executing Post-Build Script..."

# Set the execute bit on the expand root filesystem shell script
chmod +x ${targetFileSystem}/etc/expand_rootfs.sh