# Architecture Decision Records

## ADR-0001: Clean repository foundation
**Status:** Accepted

SAIF OS is an independent operating-system project. Existing application repositories are out of scope and must not be modified as part of this work.

## ADR-0002: Rust for the kernel core
**Status:** Accepted

Use Rust with no_std for kernel code where practical. Architecture entry and hardware-specific operations may use small, reviewed assembly routines. Toolchain and target details will be pinned when the first boot-image path is selected.

## ADR-0003: x86_64 UEFI and QEMU first
**Status:** Accepted

Start with a repeatable virtual target. Do not begin with physical-device support before a reliable boot and diagnostics loop exists.

## ADR-0004: Desktop and mobile are staged targets
**Status:** Accepted

Keep the kernel and architecture layers reusable, but treat device support and user interfaces as later milestones. Do not promise generic iPhone replacement support; investigate platform restrictions independently.

## ADR-0005: Evidence-based status
**Status:** Accepted

A feature is not complete because it is documented or listed in a plan. Mark it implemented only when code exists and the relevant build/test evidence is available.

## ADR-0006: Android and Windows application compatibility is a core requirement
**Status:** Accepted

The product goal includes installing and running Android APKs and Windows desktop applications. These require separate runtime and API compatibility stacks. An installer or executable loader alone is not sufficient.

**Implementation policy:** Evaluate a Wine-based Windows compatibility environment and a maintained Android userspace/runtime deployment model. Before selecting a final kernel strategy, compare a native SAIF kernel with compatibility subsystems, a SAIF host with virtualized guest environments, and a Linux-derived kernel foundation with SAIF-owned services and user experience.

The comparison must document licensing, security maintenance, hardware support, performance, and project ownership. No option is selected by this record. The decision requires a documented engineering spike and evidence.

## ADR-0007: Compatibility claims require application-level tests
**Status:** Accepted

A supported application must be tested through installation, launch, UI rendering, input, storage, network, and relevant audio/graphics behavior. Compatibility is published as a versioned matrix. Universal Windows or Android compatibility is not promised.
