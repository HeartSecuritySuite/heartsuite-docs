---
title: "Hardening matrix for kernel 6.18.9"
linkTitle: "Comparison matrix 6.18.9"
weight: 18
description: "Checker scores for the kernel that ships, 6.18.9-hs build #43. Reference rows are the 18 August 2026 run of the same checker."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison", "6.18"]
type: docs
aliases:
  - /docs/kernel-hardening/kernel-comparison-matrix-6.18.9/
toc: true
---

This page compares hardening-checker scores. It is not the list of which kernel CVEs are Not affected, Affected, or Fixed. That list is [Kernel Security Transparency](../../security/). The 18 August file is build #37, and on that build the BPF syscall is on. The kernel that ships is 6.18.9-hs build #43, and on that build the BPF syscall is off.

**Subject:** kernel that ships, **6.18.9-hs** build **#43** (packaging `6.18.9-HeartSuite-3`).  
**uname -r:** `6.18.9-hs`  
**Config SHA-256 (packaging config):** `d6a08a04f4d6734adbafac431c3ebe46d339a495d907f1c6c569959321cc3684`  
**vmlinuz SHA-256:** `f2e4749856f56cde87f9bcc887620f2d9b0aa2066756e4d3501326660b926c92`  
**Tool:** [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) commit `e870d0141259f875d3d1b54fef49dec7074e4cac`, run 2026-10-02  
**Source file:** [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt)  
**Guest boot:** the Debian 12 boot is build `#37`, in [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt). It was not repeated for build `#43`.  
**Legacy:** [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

Hash the packaging config. Guest `/boot/config-6.18.9-hs` is an 11-line initramfs stub, and `CONFIG_IKCONFIG` is off.

Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are the 18 August 2026 rows. They were not re-run on 2026-10-02. The checker commit is the same, so the columns compare.

---

## Part 1 — Measured comparison

| Config | Source | Kernel | Overall | Attack-surface | Exploit-resistance |
|---|---|---|---|---|---|
| **HS 6.18.9-hs #43** | Packaging config (SHA `d6a08a04…`) | 6.18.9 | **153/259 (59.1%)** | **62/131 (47.3%)** | **78/110 (70.9%)** |
| Arch linux-hardened 6.18.16 | Packaging tag `6.18.16.hardened1-1` `config.x86_64` | 6.18.16-hardened1 | 181/259 (69.9%) | 76/131 (58.0%) | 92/110 (83.6%) |
| Vanilla x86_64 defconfig | `make ARCH=x86_64 defconfig` on linux-6.18.9 | 6.18.9 | 153/259 (59.1%) | 88/131 (67.2%) | 56/110 (50.9%) |

Build `#37` on the same checker was 148/259 (57.1%) overall and 57/131 (43.5%) attack-surface. Exploit-resistance stayed 78/110. Five attack-surface checks moved to OK on `#43`: `CONFIG_BPF_SYSCALL`, `CONFIG_KEXEC`, `CONFIG_KEXEC_FILE`, `CONFIG_CRASH_DUMP`, and `CONFIG_PROC_VMCORE`. `CONFIG_IO_URING` stays `y`.

### Reading the table

- **Attack-surface** = dangerous features disabled. Higher = more things off.
- **Exploit-resistance** = defensive mitigations against memory bugs. Higher = harder to exploit.
- These axes are largely independent.
- Do not compare these percentages to the 5.19.6 pack, because its checker commit (`b9b83a0`) uses different item counts (132 / 109).

### What this shows

HS 6.18.9-hs #43 trails on attack-surface (47.3% vs era-matched Arch 58.0% and vanilla 6.18.9 defconfig 67.2%).

HS 6.18.9-hs #43 sits above vanilla 6.18.9 defconfig on exploit-resistance (70.9% vs 50.9%) and below era-matched Arch 6.18.16 hardened (83.6%).

The overall count ties vanilla 6.18.9 defconfig at 153/259. The mix differs: #43 disables fewer features and turns on more exploit-resistance options.

### Exploit-resistance mitigations — measured

| Mitigation | HS 6.18.9-hs #43 | Arch lh 6.18.16 |
|---|---|---|
| `INIT_ON_ALLOC_DEFAULT_ON` | **=y** | **=y** |
| `INIT_ON_FREE_DEFAULT_ON` | =n | **=y** |
| `HARDENED_USERCOPY` | **=y** | **=y** |
| `FORTIFY_SOURCE` | **=y** | **=y** |
| `SLAB_FREELIST_RANDOM` | **=y** | **=y** |
| `KFENCE` | **=y** (sample interval 0) | **=y** |
| `RANDSTRUCT_FULL` | not found (`RANDSTRUCT_NONE=y`) | not compared here |
| `KSTACK_ERASE` | not found | **=y** |
| `MODULE_SIG` / `MODULE_SIG_FORCE` | **=y** / =n | **=y** / =n |
| `KEXEC` / `KEXEC_FILE` | unset | off (checker OK) |

---

## Part 2 — Qualitative orientation (cross-project)

| Project | Bypass prevention | Exploit resistance | Availability | Primary use case |
|---|---|---|---|---|
| **HeartSuite 6.18.9-hs #43** | Measured 47.3% attack-surface | Moderate–high — 70.9% self_protection (measured) | Commercial | Containment via allowlist + Lockdown |
| **HeartSuite 5.19.6** | Measured 68.9% attack-surface ([matrix](kernel-comparison-matrix-5.19.6/)) | Low — vanilla baseline | Commercial (legacy) | Same product contract; different kernel config |
| Arch linux-hardened 6.18.16 | Moderate | **High** (83.6% ER) | Free | General-purpose hardened desktop/server |
| grsecurity / PaX | High | **Very high** | Paid | Maximum exploit resistance |
| CLIP OS (ANSSI) | High | High | Public (archived) | Government platform |
| KSPP recommended x86-64 | High (intent) | **Very high** (intent) | Public | Industry benchmark |

---

## Part 3 — LSM stack

The `#43` packaging config records:

`CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf,ipe"`

`CONFIG_SECURITY_SELINUX=y` and `CONFIG_DEFAULT_SECURITY_SELINUX` is unset. `CONFIG_BPF_SYSCALL` is unset, so there is no eBPF program to load. That string is the config list. It is not a reading of `/sys/kernel/security/lsm` from a booted `#43` guest.

The Debian 12 guest boot on 2026-08-18 is build `#37`:

| Metric | HS 6.18.9-hs #37 guest | Source |
|---|---|---|
| SELinux fs | **absent** (no `/sys/fs/selinux`) | runtime, 2026-08-18 |
| `/sys/kernel/security/lsm` | `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm` | runtime, 2026-08-18 |
| Root Lock activation | dmesg t+4s, monitor ON | runtime, 2026-08-18 |

---

## Part 4 — CPU mitigations (6.18 naming)

| Mitigation | 6.18.x option | HS 6.18.9-hs #43 |
|---|---|---|
| Spectre v1 | `CONFIG_MITIGATION_SPECTRE_V1` | **=y** |
| Spectre v2 | `CONFIG_MITIGATION_SPECTRE_V2` | **=y** |
| Retbleed | `CONFIG_MITIGATION_RETBLEED` | **=y** |

---

## Summary

| Dimension | HS 6.18.9-hs #43 | HS 5.19.6 (legacy pack) | Arch lh 6.18.16 |
|---|---|---|---|
| Overall checker | **59.1%** | 50.0%† | 69.9% |
| Attack-surface | **47.3%** | **68.9%**† | 58.0% |
| Exploit-resistance | **70.9%** | 28.4%† | **83.6%** |
| `IO_URING` | **=y** | =y | — |
| `KEXEC` / `KEXEC_FILE` | **unset** | `KEXEC=y` | KEXEC off on Arch row |
| Config SHA-256 published | **Yes** (`d6a08a04…`) | **Yes** (`d67caa6…`) | Bundled |

† Different checker commit and item counts — directional only.

For the 5.19.6 dataset see [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/). Raw notes: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt). The 18 August guest boot: [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt). Publication status: [Evidence Status](evidence-status/).
