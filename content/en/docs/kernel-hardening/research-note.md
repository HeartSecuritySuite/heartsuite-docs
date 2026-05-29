---
title: "Research Note: Bypass-Primitive Removal vs Exploit-Resistance Hardening"
weight: 40
draft: true
description: "Technical research note on HeartSuite Core Secure's kernel hardening approach — design-space analysis, empirical measurements, and open research questions for security researchers and competing projects."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "research", "LSM", "design"]
type: docs
toc: true
---

**Subject:** HeartSuite Core Secure, kernel 5.19.6  
**Config SHA-256:** `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`  
**Measured:** 2026-05-19, kernel-hardening-checker commit `b9b83a0`  
**Full data:** `kernel-comparison-matrix-5.19.6.md`, `evidence-pack-5.19.6.txt`

---

## Design-Space Framing

Linux kernel hardening projects generally optimize along two axes that are largely independent:

**Axis A — Bypass-primitive removal:** Disable kernel subsystems that, if present, allow a process to circumvent enforcement mechanisms (LSMs, VFS hooks, capability checks). Examples: BPF LSM overrides, io_uring's `fget()` hook-bypass, FUSE path confusion, overlay `d_path()` confusion, user-namespace privilege escalation.

**Axis B — Exploit-resistance mitigations:** Add defensive options that make it harder to turn kernel memory bugs into reliable exploits. Examples: heap randomization (`SLAB_FREELIST_RANDOM`), memory initialization (`INIT_ON_ALLOC_DEFAULT_ON`), pointer obfuscation (`RANDSTRUCT`), stack erasure (`KSTACK_ERASE`), bounds checking (`HARDENED_USERCOPY`, `FORTIFY_SOURCE`).

Most published hardening projects optimize heavily for Axis B (KSPP recommendations, NixOS `linux_hardened`, Arch `linux-hardened`). They also make progress on Axis A, but they trade some Axis A coverage for functional requirements (BPF is needed by systemd, eBPF observability tools, and container runtimes; user namespaces are required by rootless containers).

HeartSuite optimizes for Axis A with a specific threat model: **a compromised process on the protected host attempting to bypass a custom kernel-module MAC enforcement layer.** It does not optimize for Axis B.

---

## Empirical Measurements

### Axis A Scores (cut_attack_surface, 132 automated checks)

Era-matched scores (same 5.19.x kernel generation — directly comparable):

| Config | Score | Notes |
|---|---|---|
| HS 5.19.6 | **91/132 (68.9%)** | |
| Arch linux-hardened 5.19.11 | 77/132 (58.3%) | Keeps BPF, USER_NS, FUSE, AppArmor |
| Vanilla x86_64 defconfig 5.17 | 90/132 (68.2%) | Note: nearly identical to HS — see below |

Cross-version reference (not directly comparable; orientation only):

| Config | Score | Kernel | Notes |
|---|---|---|---|
| NixOS linux_hardened | 61/132 (46.2%) | 6.12.50 | Removed from nixpkgs 2025 |
| Arch linux-hardened (current) | 76/132 (57.6%) | 6.15 | Bundled in checker |
| KSPP target | 131/132 (99.2%) | 6.17 | Version-agnostic intent |

### Axis B Scores (self_protection, 109 automated checks)

Era-matched scores (same 5.19.x kernel generation — directly comparable):

| Config | Score | Notes |
|---|---|---|
| HS 5.19.6 | 31/109 (28.4%) | At vanilla baseline |
| Arch linux-hardened 5.19.11 | **69/109 (63.3%)** | Adds HARDENED_USERCOPY, FORTIFY_SOURCE, INIT_ON_ALLOC, SLAB_FREELIST |
| Vanilla x86_64 defconfig 5.17 | 29/109 (26.6%) | |

Cross-version reference (not directly comparable; orientation only):

| Config | Score | Kernel | Notes |
|---|---|---|---|
| NixOS linux_hardened | 88/109 (80.7%) | 6.12.50 | Removed from nixpkgs 2025 |
| Arch linux-hardened (current) | 90/109 (82.6%) | 6.15 | Bundled in checker |
| KSPP target | 93/109 (85.3%) | 6.17 | Version-agnostic intent |

### The Vanilla Defconfig Equivalence Problem

A notable measurement artifact: HS 5.19.6 and a vanilla x86_64 5.17 defconfig score nearly identically on Axis A (91 vs 90 out of 132 checks). The era-matched hardened reference (Arch linux-hardened 5.19.11) actually scores *lower* than HS on Axis A (77/132), because it enables BPF, FUSE, AppArmor and user namespaces for its general-purpose user base. The one-check difference between HS and vanilla is `CONFIG_USELIB` — HS disables the ancient `uselib()` syscall; the vanilla defconfig does not.

This is because the automated checker measures *current state* (option is off), not *intent or mechanism* (was it off because it was never configured, or because it was explicitly suppressed?). Both HS and the vanilla defconfig happen to have BPF, FUSE, and AppArmor disabled — one by design, the other by default.

The distinction is operationally significant:

- A production system built on a vanilla defconfig will accumulate enabled features over time (package installs, driver additions, container runtimes).
- HS's build procedure enforces disables by construction. The deviation registry documents each disable with threat-model rationale, and the release process enforces registry-source parity mechanically on every port.

Any methodology that only compares config snapshots will miss this difference.

---

## Documented Design Rationale

HeartSuite's bypass-primitive disables are documented with per-option rationale:

| Option | HS rationale (short) |
|---|---|
| `CONFIG_BPF_SYSCALL=n` | Root with `CAP_BPF` can load eBPF programs returning "allow" for every security hook, defeating all MAC enforcement at runtime |
| `CONFIG_FUSE_FS=n` | FUSE mounts allow a compromised process to present files under fabricated paths, confusing path-based sandbox lookup |
| `CONFIG_OVERLAY_FS=n` | `d_path()` on overlays produces paths that don't match allowlist entries |
| `CONFIG_SECURITY_APPARMOR=n` | Redundant with HeartSuite as the first and final enforcement authority; adds code paths that may contain exploitable bugs |

The targeting of these specific options tracks the documented VFS/LSM bypass CVE class, not general system security.

---

## Open Research Questions

The following questions are motivated by gaps between the measurement data and a full security assessment. Each is stated with the evidence that motivates it.

**Q1: What is the exploitability delta between HS and KSPP-hardened on a kernel heap corruption bug?**  
Matrix shows HS at 31/109 (28.4%) on Axis B vs KSPP target at 93/109 (85.3%). The gap represents ~62 mitigations. The practical exploitability difference depends on which mitigations are most effective against contemporary heap-spraying and use-after-free primitives. Published empirical data (e.g. exploit kit success rates against `SLAB_FREELIST_RANDOM`-enabled vs disabled kernels) would quantify this gap.

**Q2: Does the vanilla-defconfig equivalence on Axis A hold under a production configuration?**  
Both score ~91/132 on a clean config. After typical production deployment (systemd services, Docker runtime, eBPF tracing tools), a vanilla-seeded system will have BPF, user namespaces, and FUSE enabled. HS's documented build enforcement prevents this. Measuring Axis A on a production-deployed vanilla kernel vs a production HeartSuite deployment would show the true divergence.

**Q3: LSM-stack ordering at runtime on a HS 5.19.6 deployment — resolved.**  
Runtime verification confirms: SELinux is compiled-in but runs permissive with no policy loaded; HeartSuite is the sole enforcing MAC LSM. Full trace in `evidence-pack-5.19.6.txt` §5.

**Q4: Does removing competing LSMs (`YAMA=n`, `LANDLOCK=n`, `IMA=n`) reduce defense-in-depth in meaningful attack scenarios?**  
HS disables all competing MAC layers to ensure HeartSuite is the sole enforcement authority. This eliminates potential conflicts and redundant attack surfaces. It also removes defense-in-depth for attack classes HeartSuite does not cover (e.g. YAMA's `ptrace_scope`). Characterizing which attack classes lose coverage is open.

---

## Design-Space Positioning

Projects plotted qualitatively on both axes (source: each project's public documentation and kernel config). Only HS and Arch linux-hardened 5.19.11 scores are directly measured.

| Project | Axis A (Bypass Prevention) | Axis B (Exploit Resistance) | Primary Constraint |
|---|---|---|---|
| **HeartSuite 5.19.6** | **Very High** — BPF/FUSE/OVERLAY/AppArmor/USER_NS disabled | Low — vanilla upstream baseline | Single-purpose appliance; bypass prevention is the design goal |
| Arch linux-hardened 5.19.11 | Moderate — keeps BPF, FUSE, AppArmor, USER_NS | **High** — HARDENED_USERCOPY, FORTIFY_SOURCE, INIT_ON_ALLOC, SLAB_FREELIST | General-purpose; features required by desktop/server users |
| CLIP OS (ANSSI, archived) | High — minimal modules, BPF disabled | High — KSPP-style mitigations | Government platform; production is not publicly maintained |
| grsecurity / PaX | High | **Very High** — RBAC + PaX heap/stack | Paid; config not publicly available for automated analysis |
| Hardened Gentoo | Moderate | High | General-purpose; community maintained |
| GrapheneOS | High (Android-targeted) | **Very High** — extensive Android hardening patches | Android (aarch64); not applicable to x86 server deployments |
| Kicksecure / Whonix | Low–Moderate | Low–Moderate — mostly OS-level | Privacy-focused; kernel hardening is not the primary axis |

NixOS `linux_hardened` was removed from nixpkgs in 2025 due to lack of maintenance and is excluded from this table as an inactive project.
