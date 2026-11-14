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
