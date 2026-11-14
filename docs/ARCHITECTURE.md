# SAIF OS Architecture

## Design principles
1. Keep the kernel small and make privileged operations explicit.
2. Isolate architecture-specific code behind narrow interfaces.
3. Prefer memory-safe Rust; use assembly only at hardware and ABI boundaries.
4. Keep early boot observable through serial diagnostics.
5. Do not describe planned subsystems as implemented.

## Initial platform
The first executable target is x86_64 UEFI in QEMU. This gives the project a repeatable virtual machine target before physical hardware support is attempted. AArch64 is a later architecture target. Desktop and mobile are product targets, not assumptions that every device has an open boot chain.

## Layering
- Boot boundary: UEFI firmware loads the kernel image and transfers control.
- Architecture layer: CPU entry, descriptor tables, interrupts, and low-level context operations.
- Kernel core: platform-independent primitives and policies.
- Drivers: device-specific interfaces and implementations.
- User space (future): process model, system calls, IPC, services, and applications.
- Shells (future): desktop and mobile interaction environments.

## Early boot contract
The first boot milestone must reach a documented kernel entry point, initialize serial output suitable for QEMU, report a clear version/build marker, and stop safely if initialization cannot continue. Memory-map parsing and allocator initialization are separate milestones and must be tested independently.

## Security boundaries
No user-space, isolation, or security guarantee is claimed at this stage. Before such claims are made, the project must define privilege boundaries, memory protection, syscall validation, executable loading, and a threat model.
