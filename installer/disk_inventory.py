#!/usr/bin/env python3
"""Read-only disk inventory for the future SAIF installer.

This module never partitions, formats, mounts, or writes to a block device.
The live-media device must be supplied explicitly so it can never be offered
as an installation target by this inventory layer.
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from typing import Any

MIN_DISK_BYTES = 16 * 1024**3


def canonical_device(value: str | None) -> str | None:
    if not value or not value.startswith("/dev/"):
        return None
    return os.path.realpath(value)


def flatten_disks(nodes: list[dict[str, Any]]) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for node in nodes:
        if node.get("type") == "disk":
            result.append(node)
        result.extend(flatten_disks(node.get("children") or []))
    return result


def descendants(node: dict[str, Any]) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for child in node.get("children") or []:
        result.append(child)
        result.extend(descendants(child))
    return result


def has_mountpoints(node: dict[str, Any]) -> bool:
    values = node.get("mountpoints")
    if isinstance(values, list):
        return any(value for value in values)
    return bool(values)


def inventory(data: dict[str, Any], source_device: str,
              root_device: str | None = None,
              minimum_bytes: int = MIN_DISK_BYTES) -> dict[str, Any]:
    source = canonical_device(source_device)
    root = canonical_device(root_device)
    if source is None:
        raise ValueError("--source-device must be an explicit /dev path")
    if root is None:
        raise ValueError("--root-device must be an explicit /dev path")

    disks = flatten_disks(data.get("blockdevices") or [])
    output = []
    for disk in disks:
        path = canonical_device(disk.get("path"))
        children = descendants(disk)
        child_paths = {canonical_device(item.get("path")) for item in children}
        child_paths.discard(None)
        mounted = has_mountpoints(disk) or any(
            has_mountpoints(item) for item in children
        )
        source_match = path == source or source in child_paths
        root_match = path == root or root in child_paths if root else False
        transport = str(disk.get("tran") or "").lower()
        removable = bool(disk.get("rm"))
        read_only = bool(disk.get("ro"))
        size = int(disk.get("size") or 0)
        reasons = []
        if source_match:
            reasons.append("live-media")
        if root_match:
            reasons.append("system-root")
        if mounted:
            reasons.append("mounted")
        if removable:
            reasons.append("removable")
        if transport == "usb":
            reasons.append("usb-transport")
        if read_only:
            reasons.append("read-only")
        if size < minimum_bytes:
            reasons.append("below-minimum-size")

        output.append({
            "name": disk.get("name"),
            "path": disk.get("path"),
            "size_bytes": size,
            "model": (disk.get("model") or "").strip(),
            "transport": transport or "unknown",
            "eligible": not reasons,
            "excluded_reasons": reasons,
        })

    return {
        "mode": "read-only-inventory",
        "installation_enabled": False,
        "source_device_required": True,
        "disks": output,
        "warning": "Inventory only. No disk changes are performed.",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-device", required=True,
                        help="explicit live USB/device path, e.g. /dev/sdb")
    parser.add_argument("--root-device", required=True,
                        help="block device backing the running system root")
    parser.add_argument("--minimum-gib", type=int, default=16)
    args = parser.parse_args()

    try:
        completed = subprocess.run(
            ["lsblk", "--json", "--bytes", "--output",
             "NAME,PATH,TYPE,SIZE,MODEL,TRAN,RM,RO,MOUNTPOINTS,PKNAME"],
            check=True, capture_output=True, text=True,
        )
        data = json.loads(completed.stdout)
        result = inventory(
            data, args.source_device, args.root_device,
            max(1, args.minimum_gib) * 1024**3,
        )
    except (OSError, subprocess.CalledProcessError, json.JSONDecodeError,
            ValueError) as exc:
        print(f"SAIF disk inventory failed safely: {exc}", file=sys.stderr)
        return 2

    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
