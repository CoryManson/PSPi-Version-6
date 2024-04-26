#!/bin/bash
set +x

# "Permission denied" in the github workflow means that your script file does not have the "execute" permission set.
# git update-index --chmod=+x .\.github\actions\build-buildroot-image\build-recalbox.sh

mkdir -p completed_images
cd images

# Create mount directory and mount image file
echo "Make mount directory and mount image"
sudo mkdir -p /mnt/rootfs
sudo mount -o loop,offset=$((512*2048)) $IMAGE_NAME /mnt/rootfs

# Add files to /boot
echo "Add files to /boot"
sudo cp $GITHUB_WORKSPACE/rpi/configs/recalbox/config.txt /mnt/rootfs/config.txt
sudo cp $GITHUB_WORKSPACE/rpi/configs/recalbox/recalbox-user-config.txt /mnt/rootfs/recalbox-user-config.txt
sudo cp $GITHUB_WORKSPACE/rpi/overlays/* /mnt/rootfs/overlays/
sudo mkdir -p /mnt/rootfs/drivers
sudo cp $GITHUB_WORKSPACE/rpi/drivers/bin/* /mnt/rootfs/drivers/

# Copy squashfs to working directory
echo "Copy squashfs to working directory"
sudo cp /mnt/rootfs/boot/recalbox ./recalbox

# Unpack squashfs
echo "Unpack squashfs"
unsquashfs recalbox

# Add custom.sh to recalbox
echo "Add custom.sh to recalbox"
cp $GITHUB_WORKSPACE/rpi/scripts/recalbox/custom.sh ./squashfs-root/recalbox/share_init/system/custom.sh
chmod +x ./squashfs-root/recalbox/share_init/system/custom.sh

# Update S12populateshare to copy custom.sh into system at boot
echo "Update S12populateshare to copy custom.sh into system at boot"
sed -i "`wc -l < ./squashfs-root/etc/init.d/S12populateshare`i\\# copy pspi custom.sh\\" ./squashfs-root/etc/init.d/S12populateshare
sed -i "`wc -l < ./squashfs-root/etc/init.d/S12populateshare`i\\cp "/recalbox/share_init/system/custom.sh" "/recalbox/share/system/custom.sh"\\" ./squashfs-root/etc/init.d/S12populateshare

# Add driver libraries
echo "Add driver libraries"
cp $GITHUB_WORKSPACE/rpi/libraries/recalbox/* ./squashfs-root/usr/lib/

# repack squashfs
echo "Repack squashfs"
mksquashfs squashfs-root filesystem.squashfs -comp xz

# Copy squashfs back to image
echo "Copy squashfs back to image"
sudo cp filesystem.squashfs /mnt/rootfs/boot/recalbox

# Unmount image
echo "Unmount image"
sudo umount /mnt/rootfs

# Recompress image
echo "Recompress image"
gzip -9 $IMAGE_NAME
echo "Move image to completed_images & rename"
mv $IMAGE_NAME.gz ../completed_images/$PSPI_IMAGE_NAME