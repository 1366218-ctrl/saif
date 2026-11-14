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
BUILDROOT_DIR="$WORK_ROOT/buildroot-${BUILDROOT_VERSION}"
OVERLAY="$REPO_ROOT/platform/buildroot/overlay"

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

mkdir -p "$DL_DIR" "$OUTPUT_DIR"
if [[ ! -f "$DL_DIR/$ARCHIVE" ]]; then
  curl --fail --location --retry 3 --output "$DL_DIR/$ARCHIVE" "$URL"
fi

tar -xJf "$DL_DIR/$ARCHIVE" -C "$WORK_ROOT"
make -C "$BUILDROOT_DIR" qemu_x86_64_defconfig

cat >> "$BUILDROOT_DIR/.config" <<EOF
BR2_ROOTFS_OVERLAY="$OVERLAY"
BR2_TARGET_GENERIC_ISSUE="SAIF OS QEMU FOUNDATION"
BR2_TARGET_GENERIC_GETTY=y
BR2_TARGET_GENERIC_GETTY_PORT="ttyS0"
BR2_TARGET_GENERIC_GETTY_BAUDRATE_115200=y
BR2_TARGET_ROOTFS_EXT2=y
# The runner provides QEMU; do not cross-build a second host QEMU copy.
# BR2_PACKAGE_HOST_QEMU is not set
EOF

make -C "$BUILDROOT_DIR" olddefconfig
make -C "$BUILDROOT_DIR" BR2_DL_DIR="$DL_DIR" -j"$JOBS"

test -s "$BUILDROOT_DIR/output/images/bzImage"
test -s "$BUILDROOT_DIR/output/images/rootfs.ext2"

cp "$BUILDROOT_DIR/output/images/bzImage" "$OUTPUT_DIR/saif-qemu-bzImage"
cp "$BUILDROOT_DIR/output/images/rootfs.ext2" "$OUTPUT_DIR/saif-qemu-rootfs.ext2"
cp "$BUILDROOT_DIR/.config" "$OUTPUT_DIR/buildroot.config"
printf 'Buildroot %s\n' "$BUILDROOT_VERSION" > "$OUTPUT_DIR/buildroot-version.txt"
(
  cd "$OUTPUT_DIR"
  sha256sum saif-qemu-bzImage saif-qemu-rootfs.ext2 buildroot.config buildroot-version.txt > SHA256SUMS
)

printf 'SAIF QEMU image artifacts created in: %s\n' "$OUTPUT_DIR"
