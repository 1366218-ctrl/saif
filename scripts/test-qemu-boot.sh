#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_DIR="${1:-$REPO_ROOT/build-output/saif-qemu}"
BOOT_TIMEOUT="${SAIF_QEMU_TIMEOUT:-45}"
LOG_FILE="${SAIF_QEMU_LOG:-$IMAGE_DIR/qemu-serial.log}"

command -v qemu-system-x86_64 >/dev/null 2>&1 || {
  printf 'qemu-system-x86_64 is required for the boot test.\n' >&2
  exit 2
}
test -s "$IMAGE_DIR/saif-qemu-bzImage"
test -s "$IMAGE_DIR/saif-qemu-rootfs.ext2"

set +e
timeout "$BOOT_TIMEOUT" qemu-system-x86_64 \
  -machine pc \
  -m 512 \
  -smp 2 \
  -kernel "$IMAGE_DIR/saif-qemu-bzImage" \
  -drive "file=$IMAGE_DIR/saif-qemu-rootfs.ext2,if=virtio,format=raw" \
  -append "root=/dev/vda rootwait console=ttyS0" \
  -display none \
  -serial stdio \
  -monitor none \
  -no-reboot >"$LOG_FILE" 2>&1
qemu_status=$?
set -e

cat "$LOG_FILE"
if ! grep -Fq "SAIF OS QEMU FOUNDATION" "$LOG_FILE"; then
  printf 'SAIF boot marker was not observed (QEMU exit: %s).\n' "$qemu_status" >&2
  exit 1
fi

printf 'SAIF_QEMU_BOOT_OK: serial console reached the SAIF login banner.\n'
