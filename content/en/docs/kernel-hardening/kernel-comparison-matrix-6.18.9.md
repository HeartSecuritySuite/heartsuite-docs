---
title: "Kernel Hardening Comparison Matrix (6.18.9)"
weight: 18
description: "Comparison matrix structure for Root Lock by HeartSuite kernel 6.18.9 (HeartSuite v1.6.4 commercial baseline). Measured checker scores and config SHA-256 pending publication."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison", "6.18"]
type: docs
toc: true
---

**Subject:** Root Lock by HeartSuite, kernel **6.18.9** (HeartSuite v1.6.4 commercial baseline)  
**Expected version string:** `6.18.9-HeartSuite-1.0`  
**Config SHA-256:** *Pending publication — engage support for pre-release evidence*  
**Tool:** [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) — commit and run date *pending publication*  
**Source file:** `evidence-pack-6.18.9.txt` (*not yet published*; see [Evidence Status](evidence-status/))  
**Legacy reference (published):** [Kernel Hardening Comparison Matrix (5.19.6)](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

> **Publication note:** This page mirrors the structure of the 5.19.6 matrix so procurement and audit teams know what evidence to expect. Numeric scores, config hashes, and runtime measurements for 6.18.9 are **in progress**. Sections marked *Pending publication* will be replaced with measured values when `evidence-pack-6.18.9.txt` ships.

---

## Part 1 — Measured comparison (same kernel era)

All configs in this section must be built from the **6.18.x** kernel tree for scores to be directly comparable — same Kconfig namespace, same option universe as the HS 6.18.9 commercial baseline.

| Config | Source | Kernel | Overall | Attack-surface | Exploit-resistance |
|---|---|---|---|---|---|
| **HS 6.18.9** | HS canonical config | 6.18.9 | *Pending publication — engage support for pre-release evidence* | *Pending publication* | *Pending publication* |
| Arch linux-hardened (era-matched) | Arch packaging @ 6.18.x tag | 6.18.x | *Pending publication* | *Pending publication* | *Pending publication* |
| Vanilla x86_64 defconfig (checker bundle) | Bundled in kernel-hardening-checker | 6.18.x | *Pending publication* | *Pending publication* | *Pending publication* |

### Reading the table

- **Attack-surface** measures how many dangerous kernel features are disabled. Higher = more things turned off.
- **Exploit-resistance** measures how many defensive mitigations against memory bugs are enabled. Higher = harder to exploit.
- These two axes are **largely independent** and optimized for different threat models.
- **Do not** compare 5.19.6 published scores to 6.18.9 placeholders — kernel generations use different Kconfig option sets and checker item counts.

### What this will show (when published)

Based on HS design intent and the published 5.19.6 analysis, the 6.18.9 era-matched run is expected to demonstrate:

- Continued **attack-surface leadership** on bypass-primitive disables (`BPF_SYSCALL`, `FUSE_FS`, `OVERLAY_FS`, alt-LSMs, `USER_NS`, and related subsystems).
- **Improved bypass coverage vs 5.19.6** — `CONFIG_IO_URING` and `CONFIG_KEXEC` are disabled in the 6.18.x HS config (both remained enabled in 5.19.6; see [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt) section 3).
- **Exploit-resistance** likely remains near the vanilla upstream baseline for the 6.18 line unless a future release explicitly adopts additional KSPP-style mitigations — *to be confirmed by measured checker output*.

*Pending publication — engage support for pre-release evidence.*

### Bypass-primitive disables — side by side

| Option | HS 6.18.9 (design / pending verify) | HS 5.19.6 (published) | Notes |
|---|---|---|---|
| `CONFIG_BPF_SYSCALL` | **=n** (expected) | **=n** | BPF LSM can override MAC decisions |
| `CONFIG_IO_URING` | **=n** (expected) | =y | io_uring bypasses VFS hooks via `fget()` — **closed in 6.18.x** |
| `CONFIG_FUSE_FS` | **=n** (expected) | **=n** | FUSE allows path-confusion attacks |
| `CONFIG_OVERLAY_FS` | **=n** (expected) | **=n** | Overlay `d_path()` breaks sandbox lookup |
| `CONFIG_SECURITY_APPARMOR` | **=n** (expected) | **=n** | Redundant LSM adds attack surface |
| `CONFIG_SECURITY_TOMOYO` | **=n** (expected) | **=n** | Same rationale as AppArmor |
| `CONFIG_KEXEC` | **=n** (expected) | =y | kexec destroys Lockdown state — **closed in 6.18.x** |
| `CONFIG_MODULE_SIG` | =n (expected) | =n | Unsigned modules can unload HeartSuite |

Checker-verified 6.18.9 column values and Arch linux-hardened 6.18.x reference column: *Pending publication — engage support for pre-release evidence.*

### Exploit-resistance mitigations — side by side

| Mitigation | HS 6.18.9 | Arch lh 6.18.x (era-matched) |
|---|---|---|
| `INIT_ON_ALLOC_DEFAULT_ON` | *Pending publication* | *Pending publication* |
| `INIT_ON_FREE_DEFAULT_ON` | *Pending publication* | *Pending publication* |
| `HARDENED_USERCOPY` | *Pending publication* | *Pending publication* |
| `FORTIFY_SOURCE` | *Pending publication* | *Pending publication* |
| `SLAB_FREELIST_RANDOM` | *Pending publication* | *Pending publication* |
| `KFENCE` | *Pending publication* | *Pending publication* |
| `RANDSTRUCT_FULL` | *Pending publication* | *Pending publication* |
| `KSTACK_ERASE` | *Pending publication* | *Pending publication* |
| `MODULE_SIG` / `MODULE_SIG_FORCE` | *Pending publication* | *Pending publication* |

---

## Part 2 — Qualitative orientation (cross-project)

These projects were not scored with the checker in the pending 6.18.9 analysis pass — either because their configs were unavailable for automated download, because they are paywalled, or because a meaningful era-matched config was not yet selected. Characterizations follow each project's public documentation and design goals. **HS 6.18.9** row incorporates known port deltas vs 5.19.6; checker-backed claims await publication.

| Project | Bypass Prevention | Exploit Resistance | Module Footprint | Availability | Primary Use Case |
|---|---|---|---|---|---|
| **HeartSuite 6.18.9** | **Very High** — same bypass-removal philosophy as 5.19.6; **IO_URING and KEXEC disabled** (port improvement) | Low–Moderate (expected) — *pending measured confirmation* | Minimal loadable module set (expected; *pending runtime count*) | Commercial | Containment of untrusted code on dedicated appliance |
| **HeartSuite 5.19.6** | **Very High** — BPF/FUSE/OVERLAY/AppArmor/TOMOYO/USER_NS disabled; IO_URING/KEXEC gaps | Low — vanilla upstream baseline ([measured](kernel-comparison-matrix-5.19.6/)) | **~9 modules** ([measured](../evidence-pack-5.19.6.txt)) | Commercial (legacy stream) | Same; maintenance-only per [Kernel Support Policy](kernel-support-policy/) |
| Arch linux-hardened 6.18.x | Moderate — keeps BPF, FUSE, AppArmor, USER_NS for general-purpose use | **High** — HARDENED_USERCOPY, FORTIFY, INIT_ON_ALLOC, SLAB_FREELIST | Hundreds | Free, open-source | General-purpose hardened desktop/server |
| grsecurity / PaX | High | **Very High** — RBAC + PaX heap/stack protections | Large | Paid subscription | Maximum exploit resistance; enterprise |
| CLIP OS (ANSSI) | High — minimal modules + BPF disabled | High — KSPP-style mitigations | ~400 | Public (archived) | Government/high-security Linux platform |
| KSPP recommended x86-64 | High (intent) | **Very High** (intent) | N/A (reference config) | Public | Industry benchmark for exploit-resistance options |

**Notes on the qualitative table:**

- "Bypass Prevention" = removal of subsystems that can circumvent MAC/LSM enforcement.
- "Exploit Resistance" = mitigations against kernel memory bugs (heap, stack, pointer corruption).
- Only **HeartSuite 5.19.6** scores in this section are fully checker-backed today. **HeartSuite 6.18.9** qualitative row will be reconciled against measured output when the evidence pack publishes.

---

## Part 3 — LSM stack and module count (measured)

| Metric | HS 6.18.9 | Source |
|---|---|---|
| Modules loaded at runtime | *Pending publication — engage support for pre-release evidence* | Runtime measurement |
| Loadable .ko files shipped | *Pending publication* | Runtime measurement |
| modules.builtin entries | *Pending publication* | Runtime measurement |
| SELinux at runtime | *Pending publication* (5.19.6 reference: Permissive, `enforce=0`) | Runtime measurement |
| Active enforcing MAC LSM | HeartSuite (design invariant) | Runtime measurement — dmesg enforcement trace |
| Alt-LSMs (YAMA, LANDLOCK, IMA, EVM, LOCKDOWN_LSM) | All disabled (expected; matches 5.19.6 design) | Config grep — *pending 6.18.9 config publication* |

Design invariant (unchanged from 5.19.6): HeartSuite is the first and final enforcement authority; competing MAC frameworks are not enabled for enforcement. Runtime proof for 6.18.9 awaits the evidence pack.

---

## Part 4 — CPU mitigations (6.18 naming)

Linux 6.18 uses the post-6.1 `CONFIG_MITIGATION_*` option names. The checker should report these directly (unlike 5.19.6, where legacy option names caused false FAILs). Published 6.18.9 values will list confirmed `=y` mitigations from the canonical config.

| Mitigation | 6.18.x option (checker name) | HS 6.18.9 value |
|---|---|---|
| Spectre v1 | `CONFIG_MITIGATION_SPECTRE_V1` | *Pending publication* |
| Spectre v2 | `CONFIG_MITIGATION_SPECTRE_V2` | *Pending publication* |
| Speculative Store Bypass | `CONFIG_MITIGATION_SPEC_STORE_BYPASS` | *Pending publication* |
| Retbleed | `CONFIG_MITIGATION_RETBLEED` | *Pending publication* |
| IBT | `CONFIG_MITIGATION_IBT` | *Pending publication* |

*Pending publication — engage support for pre-release evidence.*

---

## Summary

| Dimension | HS 6.18.9 | HS 5.19.6 (published legacy) | Arch lh 6.18.x (pending) |
|---|---|---|---|
| Overall checker score | *Pending publication* | 50.0% | *Pending publication* |
| Attack-surface reduction | *Pending publication* | **68.9%** | *Pending publication* |
| Exploit-resistance | *Pending publication* | 28.4% | *Pending publication* |
| Bypass-primitive disables (of 8 key) | *Pending verify* (7/8 expected from design) | 5/8 | *Pending publication* |
| KEXEC disabled | **Expected yes** (port delta) | No | *Pending publication* |
| IO_URING disabled | **Expected yes** (port delta) | No | *Pending publication* |
| MODULE_SIG enforced | *Pending publication* | No | *Pending publication* |
| BPF_SYSCALL disabled | **Expected yes** | **Yes** | *Pending publication* |
| FUSE/OVERLAY disabled | **Expected yes** | **Yes** | *Pending publication* |
| Runtime modules loaded | *Pending publication* | **0** | Not measured |
| Config SHA-256 published | **No** (in progress) | **Yes** | N/A |

For the complete published legacy dataset, see [Kernel Hardening Comparison Matrix (5.19.6)](kernel-comparison-matrix-5.19.6/). For publication timeline and pre-release evidence access, see [Evidence Status](evidence-status/).
