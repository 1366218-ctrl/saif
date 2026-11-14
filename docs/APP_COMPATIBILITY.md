# Android and Windows Application Compatibility

## Product requirement

SAIF OS is intended to support installing and running Android applications and Windows desktop applications. Compatibility is a first-class product requirement, not an assumption that follows automatically from having a kernel.

## Reality and constraints

Android applications are commonly distributed as APKs or app bundles and depend on Android framework APIs, Android Runtime (ART), Bionic, graphics/media services, package management, and a set of Linux-kernel interfaces. Running an APK therefore requires substantially more than an APK installer.

Windows applications commonly use PE executables and Win32/Win64 APIs, Windows registry behavior, system libraries, graphics/audio interfaces, and sometimes kernel drivers or anti-cheat components. A PE loader alone does not provide Windows compatibility.

No compatibility layer can promise that every application or device driver will work. Compatibility must be measured against named applications and versions.

## Recommended staged strategy

### Windows applications
- Build a stable POSIX-like user-space foundation and graphics/audio/device interfaces.
- Evaluate Wine as the primary compatibility layer rather than reimplementing Win32 from scratch.
- Evaluate Proton components for games only after the graphics stack is mature.
- Treat kernel-mode Windows drivers, anti-cheat, DRM, and applications requiring undocumented Windows behavior as unsupported until proven otherwise.

### Android applications
- Establish the Linux-kernel interfaces required by a maintained Android userspace/runtime stack.
- Evaluate running Android userspace in a managed container or virtual machine, including ART and Android framework services.
- Investigate Binder IPC, package installation, graphics composition, audio, camera, sensors, and input as explicit integration milestones.
- Do not claim APK support until a real APK installs, launches, renders, receives input, and passes a documented compatibility test.

## Kernel architecture implication

A fully independent kernel written from zero is a much larger undertaking than adapting an existing Linux kernel. The project should preserve a clean kernel boundary, but should not commit to reimplementing every Linux interface before validating the compatibility stack.

The first engineering spike must compare:
1. A native SAIF kernel with a Linux-compatibility subsystem.
2. A small SAIF host with a Linux virtual machine for Android and a Wine-based Windows compatibility environment.
3. A Linux-derived kernel foundation with SAIF-owned services and user experience.

The comparison must cover feasibility, licensing, security updates, hardware support, performance, maintainability, and how much of the kernel is genuinely SAIF-owned. The chosen path must be recorded in an ADR before large-scale implementation.

## Acceptance levels

- **Level 0:** design and dependency inventory only.
- **Level 1:** installer/package manager prototype.
- **Level 2:** selected test applications install.
- **Level 3:** selected applications launch and basic UI/input work.
- **Level 4:** graphics, audio, storage, networking, and lifecycle work for the selected test set.
- **Level 5:** published compatibility matrix with regressions tested per release.

The repository currently has no Android or Windows application runtime. These levels are future acceptance criteria, not current capabilities.
