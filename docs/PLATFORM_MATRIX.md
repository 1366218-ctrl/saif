# SAIF OS Platform Matrix

This document defines the initial engineering targets. It is a plan, not a claim that any listed platform or application is already supported.

## Product targets

| Area | First target | Later target | Acceptance evidence |
|---|---|---|---|
| Desktop boot | x86_64 UEFI in QEMU | Physical x86_64 PCs and laptops | Reproducible image, boot logs, hardware inventory |
| Desktop applications | Linux-native applications and SAIF packages | Windows applications through Wine | App-by-app install, launch, UI, input, storage, network, audio/graphics tests |
| Android applications | Runtime feasibility prototype on desktop x86_64 | Supported x86_64 and AArch64 devices | APK install, ART execution, framework services, Binder, graphics/audio/input tests |
| Mobile OS environment | AArch64 development board or supported open device | Curated phone/tablet list | Boot, display, touch, suspend/resume, radios, camera, audio, power tests |
| Apple devices | Research only | Only if technical and policy constraints permit | Separate feasibility report; no compatibility promise |

## Kernel and system architecture

- Use a maintained Linux kernel as the first-release hardware and system-call foundation.
- Keep upstream kernel sources as an identified dependency; do not copy or relabel upstream code as SAIF-authored.
- Maintain a SAIF kernel configuration, reproducible patch series, and documented upstream tracking policy.
- Build SAIF-owned system services, boot experience, settings, package manager, desktop/mobile shells, update/recovery flow, and integration layer.
- Use Rust for suitable SAIF-owned components. Choose implementation language per component based on safety, ecosystem maturity, and integration requirements.
- Keep the initial boot and diagnostics loop on x86_64 UEFI/QEMU before physical hardware expansion.

## Windows application path

Evaluate Wine as the compatibility layer, not as a promise of universal Windows support. Validate 32-bit and 64-bit application requirements, graphics translation, audio, input, file dialogs, fonts, networking, and installer behavior. Treat kernel drivers, anti-cheat systems, DRM, and applications requiring proprietary Windows services as explicit compatibility risks.

Proton/game-specific components are a later evaluation and must not be assumed available or integrated in the first milestone.

## Android application path

Evaluate a maintained Android userspace/runtime deployment model. The implementation must account for ART, Android framework services, package management, Binder IPC, graphics composition, audio, input, app lifecycle, permissions, storage, and security boundaries. An APK file association or installer alone does not constitute Android support.

Choose container or virtual-machine boundaries only after validating required kernel interfaces, GPU access, lifecycle behavior, and isolation. Document whether Google Mobile Services are absent, optional, or unavailable; do not imply Play Store compatibility without the required licensing and certification.

## Security, updates, and supply chain

- Track upstream kernel security advisories and define a supported update cadence.
- Sign release artifacts and package repository metadata.
- Design least-privilege services, application isolation, permission prompts, and secure update rollback.
- Generate a Software Bill of Materials (SBOM) for each release.
- Keep a dependency inventory with exact upstream project, version/revision, license, local modifications, and update owner.
- Preserve all required copyright notices and source-offer obligations. Obtain legal review before distributing combined images containing copyleft components.
- Never disable platform security features merely to make an individual application launch without documenting the risk and requiring explicit product-level approval.

## Release gates

1. **Bootable prototype:** reproducible x86_64 UEFI image boots in QEMU and emits captured diagnostics.
2. **Desktop alpha:** SAIF services and shell launch; storage, network, graphics, and input work on a documented virtual target.
3. **Windows compatibility preview:** named applications pass the complete compatibility test protocol; failures and limitations are published.
4. **Android compatibility preview:** named APKs pass installation and runtime tests with documented runtime model and limitations.
5. **Mobile preview:** each physical device model passes boot, display, touch, connectivity, audio, power, and recovery tests.
6. **Public release:** signed artifacts, SBOM, license notices, update/recovery process, and reproducible build documentation are available.

## Non-goals for the first release

- Claiming a new SAIF-authored kernel while using Linux kernel code.
- Claiming every Windows program or Android APK will work.
- Claiming generic installation on arbitrary phones or iPhones.
- Treating a successful CI run for the Rust workspace as proof that a bootable operating system exists.
