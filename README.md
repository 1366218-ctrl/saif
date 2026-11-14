# SAIF OS

**SAIF OS** is an independently branded operating-system project targeting desktop first and supported mobile hardware later.

The first product direction uses a maintained Linux kernel foundation because running real Android APKs and Windows desktop applications requires mature kernel interfaces, drivers, and compatibility ecosystems. SAIF owns its product identity, boot and setup experience, system services, package experience, desktop/mobile shells, update/recovery flow, and compatibility integration. A from-scratch SAIF kernel remains a separate long-term research track.

## Current implementation

- Rust `no_std` workspace for SAIF-owned low-level components.
- Buildroot-based x86_64 Linux foundation recipe, pinned to Buildroot 2025.02.19 LTS.
- QEMU image build and serial-console boot test wired into GitHub Actions.
- The prototype is currently a console-only development image. It is not yet a desktop, installer, or Android/Windows compatibility release.

A milestone is considered verified only after CI or reproducible local evidence demonstrates the actual behavior. In particular, a successful Rust test does not prove that the operating-system image boots.

## Build and test

See [Build and test guide](docs/BUILDING.md).

- Build: `./scripts/build-qemu-image.sh`
- Boot validation: `./scripts/test-qemu-boot.sh`

The CI pipeline builds the x86_64 image, boots it in QEMU, checks the serial login banner, and uploads the image and evidence when successful.

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
SAIF OS - Multi-model engineering review enabled.
