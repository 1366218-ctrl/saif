# SAIF OS

**SAIF OS** is an independent operating-system project targeting desktop and mobile-class devices.

The project is being developed as an independently branded operating-system product. Because Android APK and Windows application compatibility are core requirements, the current recommendation is to use a maintained Linux kernel foundation for the first usable release while SAIF owns the system services, user experience, installation/update flow, and compatibility integration. A from-scratch SAIF kernel remains a separate long-term research track rather than a blocker for the first release.

## Initial direction

- **Kernel language:** Rust (`no_std`) with minimal architecture-specific assembly where required.
- **First target:** x86_64 UEFI, validated in QEMU.
- **Architecture:** keep CPU-specific code isolated so additional targets, including AArch64, can be introduced deliberately.
- **Development principle:** small milestones, reproducible builds, automated checks, and explicit documentation of what is implemented versus planned.

## Current status

This repository is at its initial foundation stage. A feature is considered implemented only after its code, build, and relevant test evidence are present in the repository.

## Roadmap

1. Establish the repository structure and CI checks.
2. Build a minimal x86_64 UEFI boot path and kernel entry.
3. Add serial diagnostics and safe halt behavior.
4. Capture and validate the UEFI memory map.
5. Introduce memory management, interrupts, scheduling, and system-call boundaries incrementally.
6. Add drivers, user-space services, and desktop/mobile shells only after the kernel foundations are verified.

## Important scope note

A general-purpose replacement operating system for iPhone hardware is not assumed to be feasible. Apple platform boot-chain, signing, and hardware restrictions require separate research; mobile support will be pursued first on hardware and boot environments that permit independent operating systems.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture decisions](docs/DECISIONS.md)

## License

No license has been selected yet. Until one is added, all rights are reserved by default.
