# SAIF OS Architecture

## Design principles

1. Keep the product layers modular and make privileged operations explicit.
2. Prefer maintained upstream components where compatibility and hardware support depend on them.
3. Prefer memory-safe Rust for suitable SAIF-owned services and low-level components.
4. Keep boot and runtime behavior observable through serial logs and structured diagnostics.
5. Do not describe planned subsystems as implemented.
6. Preserve upstream provenance, security updates, and license obligations.

## Initial platform

The first executable prototype is an x86_64 Linux system generated with Buildroot and booted under QEMU. Buildroot is pinned to its 2025.02.19 LTS release for reproducibility. The current target is a console-only image with a SAIF identity overlay. It is a Linux-based prototype, not a custom SAIF kernel.

Desktop and mobile are product targets, not assumptions that every device has an open boot chain. AArch64 and physical-device support follow a reliable x86_64 build and boot loop.

## Product layers

- **Firmware/boot:** QEMU or physical firmware starts the Linux boot image through the selected boot path. The initial CI prototype uses QEMU's direct Linux kernel boot to reduce bootloader variables.
- **Kernel and drivers:** maintained Linux kernel and selected configuration, tracked as upstream dependencies.
- **Base userspace:** Buildroot-generated root filesystem for the initial prototype. A richer desktop distribution/runtime will be selected as the product needs grow.
- **SAIF platform services:** future SAIF-owned initialization, system lifecycle, settings, diagnostics, package management, updates, and recovery.
- **Compatibility runtimes:** future Wine integration for Windows applications and a maintained Android userspace/runtime model for APKs.
- **Shells:** future SAIF desktop shell and a separate mobile shell for supported AArch64 hardware.

## Prototype boot contract

The initial QEMU image must boot the Linux kernel, mount its root filesystem, start the serial getty, and display the exact SAIF prototype banner on the serial console. CI captures the console output and preserves the image, resolved Buildroot configuration, version metadata, and SHA-256 checksums as artifacts.

This banner check validates a real boot to the login prompt. It does not validate a graphical session, physical hardware, Windows applications, or Android applications.

## Security and supply chain

No production security guarantee is claimed. Before public releases, define the privilege model, application isolation, update signing, recovery/rollback, kernel security-update policy, threat model, SBOM, and license notices. Production builds must verify upstream source signatures and record complete toolchain/source provenance.

## Compatibility boundary

Windows and Android compatibility are separate runtime projects. An installer, file association, or successful process start is not sufficient. Each supported application must pass installation, launch, UI, input, storage, network, and relevant audio/graphics tests on documented hardware.
