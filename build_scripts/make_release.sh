#!/bin/bash
#
#Make new release
#ejc-01.06.2024
#Last updated: 06.04.2024
#
##################################################
#Variables
##################################################
timeanddate=$(date --utc)
builduser=$(whoami)
hostname=$(hostname)
osrelease=$(cat /etc/redhat-release)
kernelversion=$(uname -r)
machineid=$(cat /etc/machine-id)
creation_date=$(date +%m.%d.%Y)
version=$(grep Version ../buildroot-2023.11/board/terasic/de10nano_cyclone5/overlay/etc/motd | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
cyclonevkernelversion=$(cat ../buildroot-2023.11/.config | grep KERNEL_VERSION | sed 's/.*"\(.*\)"[^"]*$/\1/')
cyclonevbareboxversion=$(cat ../buildroot-2023.11/.config | grep BAREBOX_VERSION | sed 's/.*"\(.*\)"[^"]*$/\1/')
manifestfile=../../../release/cyclonev_${version}/manifest.txt
checksumsdir=../../../release/cyclonev_${version}
##################################################
#Make Release Directory and Checksums Directory
##################################################
echo "Making release directory..."
cd ../release
mkdir cyclonev_${version}
cd cyclonev_${version}
##################################################
#Creating tar.xz and Signing For Release
##################################################
echo "Creating tar.xz and signing for release..."
cd ../../buildroot-2023.11/output/images
tar -czvf cyclonev_${version}_${creation_date}_signed.tar.xz *
echo "Signing release tar.xz..."
gpg --detach-sign cyclonev_*_signed.tar.xz
##################################################
#Make Manifest file.
##################################################
echo "Making Manifest Files and Checksums File..."
echo "Manifest: $timeanddate" > $manifestfile
echo "" >> $manifestfile
##################################################
#Insert CycloneV Version Information
##################################################
echo "Cyclone V Information" >> $manifestfile
echo "**********************" >> $manifestfile
echo "Cyclone V Version: $version" >> $manifestfile
echo "Build Date: $creation_date" >> $manifestfile
echo "Kernel Version: $cyclonevkernelversion" >> $manifestfile
echo "Barebox Version: $cyclonevbareboxversion" >> $manifestfile
echo "**********************" >> $manifestfile
echo "" >> $manifestfile
##################################################
#Insert Build Machine Information
##################################################
echo "ECS Build Machine Information: " >> $manifestfile
echo "***************************************************" >> $manifestfile
echo "Machine ID: $machineid" >> $manifestfile
echo "User and Hostname: $builduser @ $hostname" >> $manifestfile
echo "Date: $timeanddate" >> $manifestfile
echo "RedHat Release Name: $osrelease" >> $manifestfile
echo "Kernel Version: $kernelversion" >> $manifestfile
echo "***************************************************" >> $manifestfile
echo "" >> $manifestfile
##################################################
#Insert File Hashes
##################################################
echo "File Hashes: " >> $manifestfile
echo "File Hashes: " > $checksumsdir/checksums.txt
echo "***************************************************************************************************************************************************" >> $manifestfile
echo "***************************************************************************************************************************************************" >> $checksumsdir/checksums.txt
echo "SHA-256 Hashes: " >> $manifestfile
echo "SHA-256 Hashes: " >> $checksumsdir/checksums.txt
openssl dgst --sha256 * >> $manifestfile
openssl dgst --sha256 * >> $checksumsdir/checksums.txt
echo "" >> $manifestfile
echo "" >> $checksumsdir/checksums.txt
echo "SHA-512 Hashes: " >> $manifestfile
echo "SHA-512 Hashes: " >> $checksumsdir/checksums.txt
openssl dgst --sha512 * >> $manifestfile
openssl dgst --sha512 * >> $checksumsdir/checksums.txt
echo "" >> $manifestfile
echo "" >> $checksumsdir/checksums.txt
echo "SHA3-512 Hashes: " >> $manifestfile
echo "SHA3-512 Hashes: " >> $checksumsdir/checksums.txt
openssl dgst --sha3-512 * >> $manifestfile
openssl dgst --sha3-512 * >> $checksumsdir/checksums.txt
echo "***************************************************************************************************************************************************" >> $manifestfile
echo "***************************************************************************************************************************************************" >> $checksumsdir/checksums.txt
echo "Done Making Manifest and Checksum Files..."
##################################################
#Move signed tar.xz and change directory
##################################################
mv cyclonev_${version}_${creation_date}_signed* ../../../release/cyclonev_${version}
cd ../../../release/cyclonev_${version}
##################################################
#Sign the manifest
##################################################
echo "Signing manifest..."
gpg --detach-sign manifest.txt
##################################################
#Change Directory and sign the checksum file
##################################################
cd checksums
echo "Signing checksum file..."
gpg --detach-sign checksums.txt
echo "Done"