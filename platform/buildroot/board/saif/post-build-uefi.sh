#!/bin/sh
set -eu

BOARD_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
EFI_BOOT_DIR="$BINARIES_DIR/efi-part/EFI/BOOT"

test -s "$EFI_BOOT_DIR/bootx64.efi"
mkdir -p "$EFI_BOOT_DIR"
cp "$BOARD_DIR/grub-uefi.cfg" "$EFI_BOOT_DIR/grub.cfg"
