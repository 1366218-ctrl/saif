# SAIF OS Roadmap

Status labels: Planned, In progress, and Verified. A milestone becomes Verified only when its implementation and reproducible validation evidence are committed.

## M0: Repository foundation
- [x] Project identity and initial scope
- [x] Architecture and roadmap documentation
- [x] Rust workspace and CI checks (configuration added; execution pending)
- [ ] Reproducible local/QEMU build instructions

## M1: First kernel entry
- [ ] Select and pin the boot-image/toolchain approach
- [ ] Build an x86_64 kernel image
- [ ] Boot in QEMU through UEFI
- [ ] Emit serial startup marker
- [ ] Halt safely

## M2: Firmware handoff
- [ ] Define and validate the UEFI handoff contract
- [ ] Parse the UEFI memory map
- [ ] Validate memory regions and alignment
- [ ] Add boot failure diagnostics

## M3: CPU and memory foundations
- [ ] GDT/IDT and exception reporting
- [ ] Physical page-frame allocator
- [ ] Virtual memory and page-table management
- [ ] Heap allocator with tests

## M4: Execution and device model
- [ ] Timer and interrupt routing
- [ ] Cooperative scheduler, then preemptive scheduling
- [ ] Kernel threads and context switching
- [ ] Driver interfaces and initial virtual devices

## M5: User-space foundations
- [ ] System-call ABI
- [ ] Process/address-space model
- [ ] IPC and capability/security model
- [ ] Executable loader and init service

## M6: Product environments
- [ ] Storage and filesystem
- [ ] Networking
- [ ] Desktop shell
- [ ] Mobile shell on supported open hardware

## Platform research track
- [ ] AArch64 boot and hardware survey
- [ ] Mobile device boot-chain feasibility matrix
- [ ] Separate assessment of Apple/iPhone constraints

Nothing beyond the checked items above is represented as implemented by this roadmap.
