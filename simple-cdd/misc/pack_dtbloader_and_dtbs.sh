#!/bin/bash

pushd debian/installer/arm64/images/cdrom/
tar xf debian-cd_info.tar.gz
cd grub/
mkdir tmp
mcopy -n -s -i efi.img '::/' tmp/
cp tmp/efi/boot/bootaa64.efi tmp/efi/boot/grubaa64.efi
cp ../../../../../../packaging/dtbloader/debian/boot/efi/EFI/debian/DtbLoader.efi tmp/efi/boot/bootaa64.efi

LINUX_IMAGE="linux-image-6.5.0-custom"
DTB_DIR="tmp/dtb"
mkdir -p $DTB_DIR
python3 ../../../../../../packaging/dtbinstaller/debian/usr/local/bin/install-dtbs.py /usr/lib/$LINUX_IMAGE $DTB_DIR
rm efi.img
/sbin/mkfs.msdos -v -C efi.img 102400
mcopy -o -s -i efi.img tmp/* "::/"
rm tmp -rf
cd ../
rm debian-cd_info.tar.gz
tar zcf debian-cd_info.tar.gz grub/
rm grub/ -rf
popd
