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
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
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

if ! grep -Eq 'eth0:|eth0 ' "$LOG_FILE"; then
  printf 'QEMU network interface eth0 was not detected.\n' >&2
  exit 1
fi

if grep -Fq "Waiting for interface eth0 to appear" "$LOG_FILE" || grep -Fq "Starting network: FAIL" "$LOG_FILE"; then
  printf 'SAIF network startup did not complete successfully.\n' >&2
  exit 1
fi

printf 'SAIF_QEMU_BOOT_OK: serial login banner and QEMU network interface detected.\n'
