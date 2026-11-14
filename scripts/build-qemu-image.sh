#!/usr/bin/env bash
set -Eeuo pipefail

BUILDROOT_VERSION="${BUILDROOT_VERSION:-2025.02.19}"
JOBS="${SAIF_JOBS:-2}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${SAIF_WORK_ROOT:-$(mktemp -d)}"
OUTPUT_DIR="${SAIF_OUTPUT_DIR:-$REPO_ROOT/build-output/saif-qemu}"
DL_DIR="${SAIF_DL_DIR:-$HOME/.cache/saif-buildroot/dl}"
ARCHIVE="buildroot-${BUILDROOT_VERSION}.tar.xz"
URL="https://buildroot.org/downloads/$ARCHIVE"
BUILDROOT_DIR="$WORK_ROOT/buildroot-$BUILDROOT_VERSION"
BOARD_DIR="$REPO_ROOT/platform/buildroot/board/saif"

cleanup() {
  if [[ -z "${SAIF_WORK_ROOT:-}" ]]; then
    rm -rf "$WORK_ROOT"
  fi
}
trap cleanup EXIT

for tool in curl tar make gcc g++ perl python3; do
  command -v "$tool" >/dev/null 2>&1 || {
    printf 'Missing required build tool: %s\n' "$tool" >&2
    exit 2
  }
done

test -s "$BOARD_DIR/post-build-uefi.sh"
test -s "$BOARD_DIR/post-image-uefi.sh"
test -s "$BOARD_DIR/grub-uefi.cfg"
test -s "$BOARD_DIR/genimage-uefi.cfg"

mkdir -p "$DL_DIR" "$OUTPUT_DIR"
if [[ ! -f "$DL_DIR/$ARCHIVE" ]]; then
  curl --fail --location --retry 3 --output "$DL_DIR/$ARCHIVE" "$URL"
fi

tar -xJf "$DL_DIR/$ARCHIVE" -C "$WORK_ROOT"
make -C "$BUILDROOT_DIR" qemu_x86_64_defconfig

cat >> "$BUILDROOT_DIR/.config" <<EOF
BR2_ROOTFS_OVERLAY="$REPO_ROOT/platform/buildroot/overlay"
BR2_ROOTFS_POST_BUILD_SCRIPT="$BOARD_DIR/post-build-uefi.sh"
BR2_ROOTFS_POST_IMAGE_SCRIPT="$BOARD_DIR/post-image-uefi.sh"
BR2_TARGET_GENERIC_ISSUE="SAIF OS QEMU FOUNDATION"
BR2_TARGET_GENERIC_GETTY=y
BR2_TARGET_GENERIC_GETTY_PORT="ttyS0"
BR2_TARGET_GENERIC_GETTY_BAUDRATE_115200=y
BR2_TARGET_ROOTFS_EXT2=y
BR2_TARGET_ROOTFS_EXT2_4=y
BR2_TARGET_ROOTFS_EXT2_SIZE="256M"
BR2_LINUX_KERNEL_INSTALL_TARGET=y
BR2_TARGET_GRUB2=y
BR2_TARGET_GRUB2_X86_64_EFI=y
BR2_TARGET_EDK2=y
BR2_TARGET_EDK2_PLATFORM_OVMF_X64=y
BR2_PACKAGE_HOST_GENIMAGE=y
BR2_PACKAGE_HOST_DOSFSTOOLS=y
BR2_PACKAGE_HOST_MTOOLS=y
# The runner provides QEMU; do not cross-build a second host QEMU copy.
# BR2_PACKAGE_HOST_QEMU is not set
EOF

make -C "$BUILDROOT_DIR" olddefconfig
make -C "$BUILDROOT_DIR" BR2_DL_DIR="$DL_DIR" -j"$JOBS"

BINARIES="$BUILDROOT_DIR/output/images"
test -s "$BINARIES/bzImage"
test -s "$BINARIES/rootfs.ext2"
test -s "$BINARIES/disk.img"
test -s "$BINARIES/OVMF_CODE.fd"
test -s "$BINARIES/OVMF_VARS.fd"

cp "$BINARIES/bzImage" "$OUTPUT_DIR/saif-qemu-bzImage"
cp "$BINARIES/rootfs.ext2" "$OUTPUT_DIR/saif-qemu-rootfs.ext2"
cp "$BINARIES/disk.img" "$OUTPUT_DIR/saif-uefi-disk.img"
cp "$BINARIES/OVMF_CODE.fd" "$OUTPUT_DIR/OVMF_CODE.fd"
cp "$BINARIES/OVMF_VARS.fd" "$OUTPUT_DIR/OVMF_VARS.fd"
cp "$BUILDROOT_DIR/.config" "$OUTPUT_DIR/buildroot.config"
printf 'Buildroot %s\n' "$BUILDROOT_VERSION" > "$OUTPUT_DIR/buildroot-version.txt"
(
  cd "$OUTPUT_DIR"
  sha256sum saif-qemu-bzImage saif-qemu-rootfs.ext2 saif-uefi-disk.img OVMF_CODE.fd OVMF_VARS.fd buildroot.config buildroot-version.txt > SHA256SUMS
)

printf 'SAIF QEMU and UEFI images created in: %s\n' "$OUTPUT_DIR"
