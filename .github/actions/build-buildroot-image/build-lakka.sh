#!/bin/bash
set +x

# "Permission denied" in the github workflow means that your script file does not have the "execute" permission set.
# git update-index --chmod=+x .\.github\actions\build-buildroot-image\build-lakka.sh

mkdir -p completed_images
cd images

# Create mount directory and mount image file
echo "Make mount directory and mount image"
devicePath=$(sudo losetup -f)
sudo losetup -Pf $IMAGE_NAME
sudo losetup -l
sudo mkdir /mnt/rootfs
sudo mount -o loop,offset=$((512*8192)) $devicePath /mnt/rootfs

# Add files to /boot
echo "Add files to /boot"
sudo cp $GITHUB_WORKSPACE/rpi/configs/lakka/config.txt /mnt/rootfs/config.txt
sudo cp $GITHUB_WORKSPACE/rpi/configs/lakka/distroconfig.txt /mnt/rootfs/distroconfig.txt
sudo cp $GITHUB_WORKSPACE/rpi/overlays/* /mnt/rootfs/overlays/
sudo mkdir -p /mnt/rootfs/drivers
sudo cp $GITHUB_WORKSPACE/rpi/drivers/bin/* /mnt/rootfs/drivers/

# Copy squashfs to working directory
echo "Copy squashfs to working directory"
cp /mnt/rootfs/SYSTEM ./SYSTEM

# Unpack SYSTEM squashfs
echo "Unpack SYSTEM squashfs"
sudo unsquashfs SYSTEM

# Add autostart.sh
echo "Add autostart.sh"
sudo cp $GITHUB_WORKSPACE/rpi/scripts/lakka/autostart.sh ./squashfs-root/usr/config/autostart.sh
sudo chmod +x ./squashfs-root/usr/config/autostart.sh

# Add joypad autoconfig
echo "Add joypad autoconfig"
sudo cp $GITHUB_WORKSPACE/rpi/configs/lakka/PSPi-Controller.cfg ./squashfs-root/etc/retroarch-joypad-autoconfig/udev/PSPi-Controller.cfg

# Repack squashfs
echo "Repack squashfs"
sudo mksquashfs squashfs-root filesystem.squashfs -comp xz

# Copy squashfs back to image
echo "Copy squashfs back to image"
sudo cp filesystem.squashfs /mnt/rootfs/SYSTEM

# Unmount image
echo "Unmount image"
sudo umount /mnt/rootfs
sudo losetup -d $devicePath

# Recompress image
echo "Recompress image"
xz -z $IMAGE_NAME

# Move image to completed_images and rename
echo "Move image to completed_images and rename"
mv $IMAGE_NAME.xz ../completed_images/$PSPI_IMAGE_NAME