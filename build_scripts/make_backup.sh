#!/bin/bash
#
#Make new backup
#ejc-01.06.2024
#Last updated: 06.04.2024
#
creation_date=$(date +%m.%d.%Y)
version=$(grep Version ../buildroot-2023.11/board/terasic/de10nano_cyclone5/overlay/etc/motd | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
cd $HOME/backups
mkdir cyclonev_${version}_backup_${creation_date} && cd "$_"
echo "Backup Date: "$(date -u) > info.txt
echo "Machine Name: "$(hostname) >> info.txt
echo "User: "$(whoami) >> info.txt
echo "Version: "${version} >> info.txt
cd ../../cycloneV_soc
tar -czvf cyclonev_backup_${creation_date}.tar.gz *
mv cyclonev_backup_${creation_date}.tar.gz $HOME/backups/cyclonev_${version}_backup_${creation_date}
echo "Done"