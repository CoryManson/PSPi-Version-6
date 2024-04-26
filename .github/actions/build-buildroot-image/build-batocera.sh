#!/bin/bash
set +x

# "Permission denied" in the github workflow means that your script file does not have the "execute" permission set.
# git update-index --chmod=+x .\.github\actions\build-buildroot-image\build-batocera.sh

mkdir -p completed_images
cd images

# Create mount directory and mount image file
echo "Make mount directory and mount image"
sudo mkdir -p /mnt/rootfs
sudo mount -o loop,offset=$((512*2048)) $IMAGE_NAME /mnt/rootfs

# Add files to /boot
echo "Add files to /boot"
sudo cp $GITHUB_WORKSPACE/rpi/configs/batocera/config.txt /mnt/rootfs/config.txt
sudo cp $GITHUB_WORKSPACE/rpi/overlays/* /mnt/rootfs/overlays/
sudo mkdir -p /mnt/rootfs/drivers
sudo cp $GITHUB_WORKSPACE/rpi/drivers/bin/* /mnt/rootfs/drivers/

# Copy squashfs to working directory
echo "Copy squashfs to working directory"
sudo cp /mnt/rootfs/boot/batocera ./batocera

# Unpack squashfs
echo "Unpack squashfs"
unsquashfs batocera

# Add custom.sh
echo "Add custom.sh"
cp $GITHUB_WORKSPACE/rpi/scripts/batocera/custom.sh ./squashfs-root/usr/share/batocera/datainit/system/custom.sh
chmod +x ./squashfs-root/usr/share/batocera/datainit/system/custom.sh

# Update S12populateshare to copy custom.sh into system at boot
echo "Update S12populateshare to copy custom.sh into system at boot"
sed -i '/bios\/ps2/i\            system\/custom.sh \\' ./squashfs-root/etc/init.d/S12populateshare

# Add driver libraries
echo "Add driver libraries"
cp $GITHUB_WORKSPACE/rpi/libraries/batocera/* ./squashfs-root/usr/lib/

# Add Multimedia keys for volume control
echo "Add Multimedia keys for volume control"
cp $GITHUB_WORKSPACE/rpi/configs/batocera/multimedia_keys.conf ./squashfs-root/usr/share/batocera/datainit/system/configs/multimedia_keys.conf

# update S12populateshare to copy multimedia_keys.conf into system at boot
echo "Update S12populateshare to copy multimedia_keys.conf into system at boot"
sed -i '/bios\/ps2/i\            system\/configs\/multimedia_keys.conf \\' ./squashfs-root/etc/init.d/S12populateshare

# repack squashfs
echo "Repack squashfs"
mksquashfs squashfs-root filesystem.squashfs -comp zstd

# Copy squashfs back to image
echo "Copy squashfs back to image"
sudo cp filesystem.squashfs /mnt/rootfs/boot/batocera

# Unmount image
echo "Unmount image"
sudo umount /mnt/rootfs

# Recompress image
echo "Recompress image"
gzip -9 $IMAGE_NAME
echo "Move image to completed_images & rename"
mv $IMAGE_NAME.gz ../completed_images/$PSPI_IMAGE_NAME