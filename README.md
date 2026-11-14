# SAIF OS

**SAIF OS** is an independently branded operating-system project targeting desktop first and supported mobile hardware later.

The first product direction uses a maintained Linux kernel foundation because running real Android APKs and Windows desktop applications requires mature kernel interfaces, drivers, and compatibility ecosystems. SAIF owns its product identity, boot and setup experience, system services, package experience, desktop/mobile shells, update/recovery flow, and compatibility integration. A from-scratch SAIF kernel remains a separate long-term research track.

## Current implementation

- Rust `no_std` workspace for SAIF-owned low-level components.
- Buildroot-based x86_64 Linux foundation recipe, pinned to Buildroot 2025.02.19 LTS.
- Build pipeline now assembles a GPT disk with an EFI System Partition, GRUB2 x86_64 EFI bootloader, and EDK2 OVMF firmware.
- GitHub Actions is configured to test both the existing direct-kernel QEMU path and the new OVMF UEFI disk path.
- The product remains a console-only development image. It is not yet a graphical desktop, live USB installer, disk installer, or Android/Windows compatibility release.

A milestone is considered verified only after CI or reproducible local evidence demonstrates the actual behavior. The UEFI path is pending its first successful CI boot test; a committed workflow is not itself proof of a successful boot.

## Build and test

See [Build and test guide](docs/BUILDING.md).

- Build: `./scripts/build-qemu-image.sh`
- Direct-kernel diagnostic: `./scripts/test-qemu-boot.sh`
- GPT/UEFI boot test: `./scripts/test-qemu-uefi-boot.sh`

The CI pipeline is configured to build the x86_64 images, boot them in QEMU, check the SAIF serial login banner and guest network-device detection, and upload images and evidence when successful.

## Product targets

- **Desktop:** x86_64 UEFI/QEMU first, then documented physical PC hardware.
- **Windows apps:** evaluate Wine and validate applications individually.
- **Android apps:** integrate a maintained Android userspace/runtime model with required kernel interfaces.
- **Mobile:** AArch64 and supported open hardware after the desktop boot and system-service foundations.
- **iPhone:** research only; no generic replacement-OS support is promised.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture decisions](docs/DECISIONS.md)
- [Platform matrix and release gates](docs/PLATFORM_MATRIX.md)
- [Build and test guide](docs/BUILDING.md)
- [Android and Windows app compatibility](docs/APP_COMPATIBILITY.md)
- [Multi-model AI review workflow](docs/AI_REVIEW_WORKFLOW.md)

## Licensing

SAIF-owned code and the distribution license have not yet been selected. The project must preserve upstream kernel and dependency notices, track source provenance, and publish an SBOM before distributing images. No third-party code is represented as SAIF-authored.
