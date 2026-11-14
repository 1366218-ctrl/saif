# SAIF OS Roadmap

Status labels: Planned, In progress, and Verified. A milestone becomes Verified only when its implementation and reproducible validation evidence are committed.

## M0: Repository foundation
- [x] Project identity and initial scope
- [x] Architecture and roadmap documentation
- [x] Rust workspace and CI configuration
- [x] Rust CI executed successfully (format, Clippy, tests)
- [x] Android/Windows compatibility requirements documented
- [x] Reproducible Buildroot/QEMU build and boot-test scripts committed
- [x] Build and test instructions documented

## M1: Linux foundation and first boot
- [x] Select a maintained Linux kernel foundation for the first compatibility-focused product release (ADR-0008)
- [x] Pin Buildroot 2025.02.19 LTS for the first reproducible prototype
- [x] Add SAIF identity overlay and x86_64 QEMU build configuration
- [x] Add CI job to build the image and verify the serial boot banner
- [ ] Verify the complete image build and QEMU boot in GitHub Actions
- [ ] Verify upstream source signature and record source/toolchain provenance
- [ ] Review licensing, security-update policy, and hardware support
- [ ] Capture and validate boot diagnostics and virtual hardware inventory

## M1.5: Live environment and installer (In progress)
- [ ] Validate the UEFI disk image and OVMF boot in CI
- [ ] Verify a live boot path that runs without touching an installed system
- [ ] Complete and test live-media identification and read-only disk inventory
- [ ] Build the graphical installer shell and disk-selection review screen
- [ ] Add partition planning, BitLocker detection, and explicit destructive confirmation
- [ ] Implement installation writes only after QEMU safety tests pass
- [ ] Validate install, reboot, recovery, and Windows-preservation paths in QEMU

## M2: SAIF platform base
- [ ] Select a production-oriented base userspace beyond the console prototype
- [ ] Kernel configuration and reproducible upstream integration policy
- [ ] SAIF init/service supervision and system lifecycle
- [ ] Storage layout, filesystem policy, and device discovery
- [ ] Network, graphics, display, input, and audio integration
- [ ] Security model, permissions, sandboxing, and secrets handling
- [ ] Crash reporting, logs, recovery, and rollback

## M3: SAIF system services and package experience
- [ ] SAIF package format and signed repository metadata
- [ ] Install, update, uninstall, and dependency resolution
- [ ] Settings, system information, and diagnostics
- [ ] Desktop shell and application launcher
- [ ] Accessibility, localization, and input methods

## M4: Windows application compatibility
- [ ] Evaluate and integrate Wine
- [ ] Windows app installation and desktop integration
- [ ] Graphics, audio, input, storage, and network validation
- [ ] Build a versioned Windows application test suite
- [ ] Publish a compatibility matrix with known limitations

## M5: Android application compatibility
- [ ] Select Android userspace/runtime deployment model
- [ ] Provide required Linux-kernel interfaces, including Binder where required
- [ ] Integrate ART, Android framework services, and package management
- [ ] Integrate graphics, audio, input, storage, networking, and app lifecycle
- [ ] Install and run a curated APK test suite
- [ ] Publish a compatibility matrix with known limitations

## M6: Mobile and product delivery
- [ ] AArch64 boot and hardware survey
- [ ] Mobile shell for supported open hardware
- [ ] Device compatibility matrix and physical-device testing
- [ ] Secure installer, updates, recovery, and rollback
- [ ] Release signing, SBOM, license notices, and distribution pipeline

## Platform research track
- [ ] Separate feasibility assessment for Apple/iPhone restrictions
- [ ] Evaluate virtualization/container boundaries for application isolation and performance

The first public milestone is a verified QEMU boot to the SAIF console banner, not a claim of application compatibility. Android and Windows support require the dedicated milestones above.
