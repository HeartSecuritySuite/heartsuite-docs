---
title: "Hardening matrix for kernel 6.18.9"
linkTitle: "Comparison matrix 6.18.9"
weight: 18
description: "Measured checker scores and runtime for the fielded 6.18.9-hs #37 pin, with era-matched Arch 6.18.16 and vanilla 6.18.9 defconfig."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison", "6.18"]
type: docs
toc: true
---

**Subject:** Root Lock by HeartSuite, fielded **6.18.9-hs** (packaging `6.18.9-HeartSuite-3`, build **#37**)  
**uname -r:** `6.18.9-hs`  
**Config SHA-256 (pin payload):** `3cd1824742b9a15e9467c774c5f62081f9547f730ad7cd9bce464a7d286a7db9`  
**vmlinuz SHA-256:** `1b44fffb9b570497f19f4c68e170602b542bc84bfe9f49d936c123dc59f5db8a`  
**Tool:** [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) commit `e870d0141259f875d3d1b54fef49dec7074e4cac`, run 2026-08-18  
**Source file:** [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt)  
**Legacy (published):** [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

> This page measures the **fielded #37 pin**. It is not a derived unpublished cut. `CONFIG_IO_URING`, `CONFIG_KEXEC`, and `CONFIG_KEXEC_FILE` are **=y**. Guest `/boot/config-6.18.9-hs` is an 11-line RD stub — hash the pin payload config.

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
- **Do not** compare these percentages to the 5.19.6 pack (checker `b9b83a0`, 132 / 109 item denominators).

### What this shows

HS 6.18.9-hs **does not** lead attack-surface (43.5% vs era-matched Arch 58.0% and vanilla 6.18.9 defconfig 67.2%). Bypass primitives that 5.19.6 compiled out are **on** here.

HS 6.18.9-hs **does** sit above vanilla 6.18.9 defconfig on exploit-resistance (70.9% vs 50.9%) and below era-matched Arch 6.18.16 hardened (83.6%).

### Bypass-primitive options — measured

| Option | HS 6.18.9-hs #37 | HS 5.19.6 (published pack) |
|---|---|---|
| `CONFIG_BPF_SYSCALL` | **=y** | **=n** |
| `CONFIG_IO_URING` | **=y** | =y |
| `CONFIG_FUSE_FS` | **=y** | **=n** |
| `CONFIG_OVERLAY_FS` | **=m** | **=n** |
| `CONFIG_SECURITY_APPARMOR` | **=y** | **=n** |
| `CONFIG_SECURITY_TOMOYO` | **=y** | **=n** |
| `CONFIG_KEXEC` | **=y** | =y |
| `CONFIG_KEXEC_FILE` | **=y** | =n |
| `CONFIG_USER_NS` | **=y** | **=n** |
| `CONFIG_MODULE_SIG` | **=y** | =n |
| `CONFIG_MODULE_SIG_FORCE` | =n | =n |

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

| Project | Bypass prevention | Exploit resistance | Module footprint | Availability | Primary use case |
|---|---|---|---|---|---|
| **HeartSuite 6.18.9-hs #37** | Low–moderate — BPF/FUSE/OVERLAY/AppArmor/TOMOYO/USER_NS/IO_URING/KEXEC present (measured) | Moderate–high — 70.9% self_protection (measured) | **74 loaded / 4190 `.ko.xz`** (Debian 12 guest) | Commercial | Containment via allowlist + Lockdown on a general-purpose 6.18 config |
| **HeartSuite 5.19.6** | **Very high** compile-out ([measured](kernel-comparison-matrix-5.19.6/)) | Low — vanilla baseline | **0 loaded / 9 `.ko`** | Commercial (legacy) | Same product contract; different kernel config |
| Arch linux-hardened 6.18.16 | Moderate | **High** (83.6% ER) | Hundreds | Free | General-purpose hardened desktop/server |
| grsecurity / PaX | High | **Very high** | Large | Paid | Maximum exploit resistance |
| CLIP OS (ANSSI) | High | High | ~400 | Public (archived) | Government platform |
| KSPP recommended x86-64 | High (intent) | **Very high** (intent) | N/A | Public | Industry benchmark |

---

## Part 3 — LSM stack and module count (measured)

| Metric | HS 6.18.9-hs #37 | Source |
|---|---|---|
| Modules loaded at runtime | **74** | Debian 12 guest, 2026-08-18 |
| Loadable `.ko.xz` shipped | **4190** | `/lib/modules/6.18.9-hs` |
| modules.builtin entries | **198** | same guest |
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
| BPF / FUSE / USER_NS / AppArmor off | **No** | **Yes** | No |
| IO_URING / KEXEC off | **No** | No | KEXEC off on Arch row |
| Runtime modules loaded | **74** | **0** | Not measured |
| Config SHA-256 published | **Yes** (`3cd18247…`) | **Yes** (`d67caa6…`) | Bundled |

† Different checker commit and item counts — directional only.

For the 5.19.6 dataset see [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/). Raw 6.18 notes: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt). Publication status: [Evidence Status](evidence-status/).
