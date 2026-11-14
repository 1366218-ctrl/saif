# Architecture Decision Records

## ADR-0001: Clean repository foundation
**Status:** Accepted

SAIF OS is an independent operating-system project. Existing application repositories are out of scope and must not be modified as part of this work.

## ADR-0002: Rust for SAIF-owned low-level components
**Status:** Accepted

Use Rust for SAIF-owned low-level components and services where practical. The first product release uses a maintained Linux kernel, so this record does not imply that SAIF is implementing a new kernel from scratch. Architecture-specific boot and hardware work must be reviewed and tested.

## ADR-0003: x86_64 UEFI and QEMU first
**Status:** Accepted

Start with a repeatable virtual target. Do not begin with physical-device support before a reliable boot and diagnostics loop exists.

## ADR-0004: Desktop and mobile are staged targets
**Status:** Accepted

Keep platform-independent SAIF components reusable, but treat device support and user interfaces as staged milestones. Do not promise generic iPhone replacement support; investigate Apple platform restrictions independently.

## ADR-0005: Evidence-based status
**Status:** Accepted

A feature is not complete because it is documented or listed in a plan. Mark it implemented only when code exists and the relevant build/test evidence is available.

## ADR-0006: Android and Windows application compatibility is a core requirement
**Status:** Accepted

The product goal includes installing and running Android APKs and Windows desktop applications. These require separate runtime and API compatibility stacks. An installer or executable loader alone is not sufficient.

The initial evaluation considered a native SAIF kernel with compatibility subsystems, a SAIF host with virtualized guest environments, and a Linux-derived kernel foundation with SAIF-owned services and user experience. ADR-0008 records the selected first-release direction and supersedes the open selection language in this record.

## ADR-0007: Compatibility claims require application-level tests
**Status:** Accepted

A supported application must be tested through installation, launch, UI rendering, input, storage, network, and relevant audio/graphics behavior. Compatibility is published as a versioned matrix. Universal Windows or Android compatibility is not promised.

## ADR-0008: Prefer application compatibility over a from-scratch kernel for the first product release
**Status:** Accepted

The product requirement prioritizes practical Android APK and Windows application support. Reimplementing the Linux kernel interfaces needed by Android while also building a Win32 compatibility environment would make a first usable release substantially less achievable.

**Decision:** Build SAIF as an independently branded and engineered operating-system product on a maintained Linux kernel foundation for the first release. SAIF will own its boot experience, system services, package/install experience, desktop and mobile shells, update/recovery system, design language, and compatibility integration. Evaluate Wine for Windows applications and a maintained Android runtime/userspace deployment model for APKs.

This changes the original all-new-kernel ambition. It does not mean claiming the Linux kernel as SAIF-authored. Kernel provenance, upstream security updates, and all third-party licenses must be preserved and documented. A future SAIF-native kernel may be developed as a separate long-term research track, but it must not block the compatibility-focused product.

**Release gate:** Do not advertise Windows or Android support until real applications pass installation and runtime tests on documented target hardware.
