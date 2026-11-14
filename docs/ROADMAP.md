# SAIF OS Roadmap

Status labels: Planned, In progress, and Verified. A milestone becomes Verified only when its implementation and reproducible validation evidence are committed.

## M0: Repository foundation
- [x] Project identity and initial scope
- [x] Architecture and roadmap documentation
- [x] Rust workspace and CI configuration
- [x] Rust CI executed successfully on the current main revision (format, Clippy, tests)
- [x] Android/Windows compatibility requirements documented
- [ ] Reproducible platform build instructions

## M1: Platform selection and boot prototype
- [x] Select a maintained Linux kernel foundation for the first compatibility-focused product release (ADR-0008)
- [ ] Complete upstream, licensing, security-update, and hardware-support review
- [ ] Pin supported kernel baseline and toolchain after compatibility/build validation
- [ ] Define reproducible x86_64 UEFI image build
- [ ] Build the first SAIF bootable image
- [ ] Boot in QEMU and emit a serial startup marker
- [ ] Capture and validate boot diagnostics and hardware inventory

## M2: SAIF platform base
- [ ] Kernel configuration and reproducible upstream integration
- [ ] Init/service supervision and system lifecycle
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

The first public milestone is a verified QEMU boot, not a claim of application compatibility. Android and Windows support require the dedicated milestones above.
