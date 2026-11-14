# SAIF installer foundation

This directory starts the installer work with a deliberately read-only disk
inventory layer. It is not yet a graphical installer and it cannot install SAIF.

## Safety contract

- The live-media device and the block device backing the running root must both
  be passed explicitly with `--source-device` and `--root-device`. If either
  identity is unknown, inventory fails closed instead of listing candidates.
- The live-media disk, running system-root disk, mounted disks, removable media,
  USB-transport disks, read-only disks, and disks below the minimum size are
  excluded from the eligible list.
- If the live-media device is unknown, inventory must not be treated as safe
  input to any future installation operation.
- This code only reads `lsblk` output. It never invokes partitioning,
  formatting, mounting, bootloader installation, or block-device writes.
- `installation_enabled` is permanently false in this foundation.

## Local test

```sh
python3 -m unittest discover -s installer -p 'test_*.py' -v
```

## Current limits

The first deliverable is the disk-safety boundary and test suite. A live boot
environment, graphical installer screens, partition planning, filesystem
creation, bootloader deployment, rollback, and physical-device validation are
not implemented by this change. Those must be added as separate, reviewable
steps. In particular, no install-to-disk action may be wired to this inventory
until source-media detection and the complete destructive-operation safeguards
have been validated in QEMU.
