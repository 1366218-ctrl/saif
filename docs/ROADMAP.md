# SAIF OS Roadmap

Status labels: Planned, In progress, and Verified. A milestone becomes Verified only when its implementation and reproducible validation evidence are committed.

## M0: Repository foundation
- [x] Project identity and initial scope
- [x] Architecture and roadmap documentation
- [x] Rust workspace and CI checks (configuration committed; execution pending)
- [x] Android/Windows compatibility requirements documented
- [ ] Reproducible build instructions

## M1: Feasibility and boot prototype
- [ ] Compare native-kernel, virtualized-runtime, and Linux-derived approaches
- [ ] Record a compatibility architecture decision with licensing/security review
- [ ] Pin toolchain and boot-image approach
- [ ] Build x86_64 UEFI image
- [ ] Boot in QEMU and emit serial startup marker
- [ ] Capture and validate UEFI memory map

## M2: Kernel foundations
- [ ] GDT/IDT and exception reporting
- [ ] Physical page-frame allocator
- [ ] Virtual memory and page-table management
- [ ] Heap allocator with tests
- [ ] Timer, interrupt routing, and scheduler

## M3: Hardware and operating-system services
- [ ] PCI and device discovery
- [ ] Storage and filesystem
- [ ] Network stack
- [ ] Graphics, display, input, and audio foundations
- [ ] Power management and device lifecycle

## M4: Windows application compatibility
- [ ] POSIX-like user-space ABI and system libraries
- [ ] Evaluate and integrate Wine
- [ ] Package installation and desktop integration
- [ ] Build a versioned Windows application test suite
- [ ] Publish a compatibility matrix

## M5: Android application compatibility
- [ ] Select Android userspace/runtime deployment model
- [ ] Implement or provide required Linux-kernel interfaces
- [ ] Integrate ART, Android framework services, and package management
- [ ] Integrate Binder, graphics, audio, input, and lifecycle
- [ ] Install and run a curated APK test suite
- [ ] Publish a compatibility matrix

## M6: Product environments
- [ ] Desktop shell and settings
- [ ] Mobile shell for supported open hardware
- [ ] Secure updates, recovery, installer, and rollback
- [ ] Accessibility, localization, and app distribution

## Platform research track
- [ ] AArch64 boot and hardware survey
- [ ] Device compatibility matrix for target mobile hardware
- [ ] Separate feasibility assessment for Apple/iPhone restrictions

The first public milestone is a verified QEMU boot, not a claim of application compatibility. Android and Windows support require the dedicated milestones above.
