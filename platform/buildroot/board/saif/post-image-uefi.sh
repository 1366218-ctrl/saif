#!/bin/sh
set -eu

BOARD_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOTFS_IMAGE="$BINARIES_DIR/rootfs.ext2"
EFI_BOOT_DIR="$BINARIES_DIR/efi-part/EFI/BOOT"
GENIMAGE_CFG="$BINARIES_DIR/genimage-uefi.cfg"
GENIMAGE_TMP="$BUILD_DIR/genimage-uefi.tmp"
ROOTPATH_TMP="$BUILD_DIR/genimage-uefi-root"

test -s "$ROOTFS_IMAGE"
test -s "$EFI_BOOT_DIR/bootx64.efi"
test -s "$BINARIES_DIR/bzImage"

ROOT_UUID="$(dumpe2fs "$ROOTFS_IMAGE" 2>/dev/null | sed -n 's/^Filesystem UUID: *\(.*\)/\1/p')"
if [ -z "$ROOT_UUID" ]; then
    echo "Could not determine the root filesystem UUID" >&2
    exit 1
fi

sed "s/UUID_TMP/$ROOT_UUID/g" "$BOARD_DIR/grub-uefi.cfg" > "$EFI_BOOT_DIR/grub.cfg"
sed "s/UUID_TMP/$ROOT_UUID/g" "$BOARD_DIR/genimage-uefi.cfg" > "$GENIMAGE_CFG"

rm -rf "$GENIMAGE_TMP" "$ROOTPATH_TMP"
mkdir -p "$ROOTPATH_TMP"
trap 'rm -rf "$ROOTPATH_TMP"' EXIT

"$HOST_DIR/bin/genimage" \
    --rootpath "$ROOTPATH_TMP" \
    --tmppath "$GENIMAGE_TMP" \
    --inputpath "$BINARIES_DIR" \
    --outputpath "$BINARIES_DIR" \
    --config "$GENIMAGE_CFG"

test -s "$BINARIES_DIR/disk.img"
