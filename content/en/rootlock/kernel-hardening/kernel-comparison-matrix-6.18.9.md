---
title: "Hardening matrix for kernel 6.18.9"
linkTitle: "Comparison matrix 6.18.9"
weight: 18
description: "18 August 2026 checker pack. The kernel that ships is 6.18.9-hs, and the BPF syscall is off on that kernel."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison", "6.18"]
type: docs
aliases:
  - /docs/kernel-hardening/kernel-comparison-matrix-6.18.9/
toc: true
---

**Subject:** 18 August 2026 checker pack. The kernel that ships is **6.18.9-hs** (packaging `6.18.9-HeartSuite-3`), and the BPF syscall is off on that kernel.  
**uname -r on the pack:** `6.18.9-hs`  
**Config SHA-256 (pin payload):** `3cd1824742b9a15e9467c774c5f62081f9547f730ad7cd9bce464a7d286a7db9`  
**vmlinuz SHA-256:** `1b44fffb9b570497f19f4c68e170602b542bc84bfe9f49d936c123dc59f5db8a`  
**Tool:** [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) commit `e870d0141259f875d3d1b54fef49dec7074e4cac`, run 2026-08-18  
**Source file:** [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt)  
**Legacy (published):** [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

> This page is the 18 August 2026 checker pack. It is not the kernel that ships. Hash the pack's payload config, not guest `/boot/config-6.18.9-hs`, which is an 11-line initramfs stub.

---

## Part 1 — Measured comparison

Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are era-matched 6.18.x (no 6.18.9-hardened in the Arch archive).

| Config | Source | Kernel | Overall | Attack-surface | Exploit-resistance |
|---|---|---|---|---|---|
| **HS 6.18.9-hs #37** | Pin payload config (SHA `3cd18247…`) | 6.18.9 | **148/259 (57.1%)** | **57/131 (43.5%)** | **78/110 (70.9%)** |
| Arch linux-hardened 6.18.16 | Packaging tag `6.18.16.hardened1-1` `config.x86_64` | 6.18.16-hardened1 | 181/259 (69.9%) | 76/131 (58.0%) | 92/110 (83.6%) |
| Vanilla x86_64 defconfig | `make ARCH=x86_64 defconfig` on linux-6.18.9 | 6.18.9 | 153/259 (59.1%) | 88/131 (67.2%) | 56/110 (50.9%) |

### Reading the table

- **Attack-surface** = dangerous features disabled. Higher = more things off.
- **Exploit-resistance** = defensive mitigations against memory bugs. Higher = harder to exploit.
- These axes are largely independent.
- Do not compare these percentages to the 5.19.6 pack, because its checker commit (`b9b83a0`) uses different item counts (132 / 109).

### What this shows

HS 6.18.9-hs trails on attack-surface (43.5% vs era-matched Arch 58.0% and vanilla 6.18.9 defconfig 67.2%).

HS 6.18.9-hs sits above vanilla 6.18.9 defconfig on exploit-resistance (70.9% vs 50.9%) and below era-matched Arch 6.18.16 hardened (83.6%).

### Exploit-resistance mitigations — measured

| Mitigation | HS 6.18.9-hs #37 | Arch lh 6.18.16 |
|---|---|---|
| `INIT_ON_ALLOC_DEFAULT_ON` | **=y** | **=y** |
| `INIT_ON_FREE_DEFAULT_ON` | =n | **=y** |
| `HARDENED_USERCOPY` | **=y** | **=y** |
| `FORTIFY_SOURCE` | **=y** | **=y** |
| `SLAB_FREELIST_RANDOM` | **=y** | **=y** |
| `KFENCE` | **=y** (sample interval 0) | **=y** |
| `RANDSTRUCT_FULL` | not found | not compared here |
| `KSTACK_ERASE` | not found | **=y** |
| `MODULE_SIG` / `MODULE_SIG_FORCE` | **=y** / =n | **=y** / =n |

---

## Part 2 — Qualitative orientation (cross-project)

| Project | Bypass prevention | Exploit resistance | Availability | Primary use case |
|---|---|---|---|---|
| **HeartSuite 6.18.9-hs #37** | Measured 43.5% attack-surface | Moderate–high — 70.9% self_protection (measured) | Commercial | Containment via allowlist + Lockdown |
| **HeartSuite 5.19.6** | Measured 68.9% attack-surface ([matrix](kernel-comparison-matrix-5.19.6/)) | Low — vanilla baseline | Commercial (legacy) | Same product contract; different kernel config |
| Arch linux-hardened 6.18.16 | Moderate | **High** (83.6% ER) | Free | General-purpose hardened desktop/server |
| grsecurity / PaX | High | **Very high** | Paid | Maximum exploit resistance |
| CLIP OS (ANSSI) | High | High | Public (archived) | Government platform |
| KSPP recommended x86-64 | High (intent) | **Very high** (intent) | Public | Industry benchmark |

---

## Part 3 — LSM stack (measured)

| Metric | HS 6.18.9-hs #37 | Source |
|---|---|---|
| SELinux fs | **absent** (no `/sys/fs/selinux`) | runtime |
| `/sys/kernel/security/lsm` | `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm` | runtime |
| Root Lock activation | dmesg t+4s, monitor ON | runtime |
| Alt-LSMs in config | YAMA, LANDLOCK, LOCKDOWN_LSM, IMA, EVM, APPARMOR, TOMOYO all =y | pin grep |

---

## Part 4 — CPU mitigations (6.18 naming)

| Mitigation | 6.18.x option | HS 6.18.9-hs #37 |
|---|---|---|
| Spectre v1 | `CONFIG_MITIGATION_SPECTRE_V1` | **=y** (checker OK) |
| Spectre v2 | `CONFIG_MITIGATION_SPECTRE_V2` | **=y** (checker OK) |
| Retbleed | `CONFIG_MITIGATION_RETBLEED` | **=y** (checker OK) |

---

## Summary

| Dimension | HS 6.18.9-hs #37 | HS 5.19.6 (legacy pack) | Arch lh 6.18.16 |
|---|---|---|---|
| Overall checker | **57.1%** | 50.0%† | 69.9% |
| Attack-surface | **43.5%** | **68.9%**† | 58.0% |
| Exploit-resistance | **70.9%** | 28.4%† | **83.6%** |
| IO_URING / KEXEC off | **No** | No | KEXEC off on Arch row |
| Config SHA-256 published | **Yes** (`3cd18247…`) | **Yes** (`d67caa6…`) | Bundled |

† Different checker commit and item counts — directional only.

For the 5.19.6 dataset see [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/). Raw 6.18 notes: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt). Publication status: [Evidence Status](evidence-status/).
