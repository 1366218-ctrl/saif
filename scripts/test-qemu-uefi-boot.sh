#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_DIR="${1:-$REPO_ROOT/build-output/saif-qemu}"
BOOT_TIMEOUT="${SAIF_UEFI_TIMEOUT:-60}"
LOG_FILE="${SAIF_UEFI_LOG:-$IMAGE_DIR/qemu-uefi-serial.log}"
CODE="$IMAGE_DIR/OVMF_CODE.fd"
VARS_TEMPLATE="$IMAGE_DIR/OVMF_VARS.fd"
DISK="$IMAGE_DIR/saif-uefi-disk.img"
VARS_COPY="$(mktemp "${TMPDIR:-/tmp}/saif-ovmf-vars.XXXXXX")"

cleanup() {
  rm -f "$VARS_COPY"
}
trap cleanup EXIT

for tool in qemu-system-x86_64 timeout; do
  command -v "$tool" >/dev/null 2>&1 || {
    printf 'Missing required test tool: %s\n' "$tool" >&2
    exit 2
  }
done

for file in "$CODE" "$VARS_TEMPLATE" "$DISK"; do
  test -s "$file" || {
    printf 'Required UEFI artifact is missing or empty: %s\n' "$file" >&2
    exit 2
  }
done

cp "$VARS_TEMPLATE" "$VARS_COPY"

set +e
timeout "$BOOT_TIMEOUT" qemu-system-x86_64 \
  -machine pc \
  -m 768 \
  -smp 2 \
  -drive "if=pflash,format=raw,unit=0,readonly=on,file=$CODE" \
  -drive "if=pflash,format=raw,unit=1,file=$VARS_COPY" \
  -drive "file=$DISK,if=ide,format=raw" \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -display none \
  -serial stdio \
  -monitor none \
  -no-reboot >"$LOG_FILE" 2>&1
qemu_status=$?
set -e

cat "$LOG_FILE"

if ! grep -Fq "saif.boot=uefi" "$LOG_FILE"; then
  printf 'UEFI boot marker was not observed in the kernel command line (QEMU exit: %s).\n' "$qemu_status" >&2
  exit 1
fi

if ! grep -Fq "SAIF OS QEMU FOUNDATION" "$LOG_FILE"; then
  printf 'SAIF login banner was not observed after UEFI boot (QEMU exit: %s).\n' "$qemu_status" >&2
  exit 1
fi

if ! grep -Eq 'eth0:|eth0 ' "$LOG_FILE"; then
  printf 'QEMU network interface eth0 was not detected during UEFI boot.\n' >&2
  exit 1
fi

printf 'SAIF_UEFI_BOOT_OK: OVMF loaded the GPT disk through GRUB and the SAIF serial login banner was reached.\n'
