---
title: "Kernel hardening in one comparison table"
linkTitle: "Procurement Brief"
weight: 5
description: "Side-by-side hardening of the fielded 6.18.9-hs Root Lock kernel against bundled checker references — for procurement and architecture reviews."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "procurement", "comparison"]
type: docs
aliases:
  - /docs/kernel-hardening/procurement-brief/
toc: true
---

**Overview**: Side-by-side comparison of Root Lock kernel configuration choices against community hardened kernels and the KSPP benchmark.

**Subject:** Fielded **6.18.9-hs** (packaging `6.18.9-HeartSuite-3`). **5.19.6** is the legacy measured stream.  
**Evidence:** [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) (2026-08-18, checker `e870d01`). Legacy: [5.19.6 matrix](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt).

**Kernel that ships:** `uname -r` is `6.18.9-hs`. The BPF syscall is off. `CONFIG_IO_URING=y`. `CONFIG_KEXEC` and `CONFIG_KEXEC_FILE` are unset. FUSE is built in. OverlayFS, nftables, and KVM are modules. Thousands of loadable modules ship with it.

**Measured pack:** the tables below are the 18 August 2026 checker run on build #37. That config had the BPF syscall on, and `KEXEC`, `KEXEC_FILE`, and `IO_URING` set. The percentages, the 74-loaded count, and the 4190 `.ko.xz` count are that pack.

For deployment, Secure Boot, fleet, and “no custom kernel” alternatives see the [Enterprise Adoption Guide](enterprise-adoption-guide/). Support and scanner notes: [Kernel Support Policy](kernel-support-policy/), [Distro Compatibility Matrix](distro-compatibility-matrix/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

---

## What this document covers

All numbers below are outputs of `kernel-hardening-checker` commit `e870d0141259f875d3d1b54fef49dec7074e4cac` applied to the **#37 pin config** (SHA-256 `3cd1824742b9a15e9467c774c5f62081f9547f730ad7cd9bce464a7d286a7db9`) and to configs bundled with that checker.

Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are the era-matched 6.18.x peers. Do not mix these percentages with the 5.19.6 pack, because its checker commit (`b9b83a0`) counts a different set of items.

---

## At a glance (6.18.9-hs measurement, 18 August 2026)

| What you care about | HS 6.18.9-hs #37 | Arch linux-hardened 6.18.16 | KSPP x86-64* |
|---|---|---|---|
| Dangerous features disabled (attack-surface) | 43.5% (57/131) | 58.0% (76/131) | 100% (131/131) |
| Exploit-resistance mitigations | 70.9% (78/110) | **83.6%** (92/110) | 84.5% (93/110) |
| Overall checker | 57.1% (148/259) | 69.9% (181/259) | 91.4% (235/257) |
| Loadable modules at runtime (Debian 12 guest) | **74 loaded** (4190 `.ko.xz` shipped) | Hundreds | Not measured |
| BPF syscall compiled out | **No** (`=y`) | No | Yes (intent) |
| AppArmor / TOMOYO / YAMA / Landlock / IMA / EVM compiled out | **No** (all present; live LSM includes them) | No | No |
| `MODULE_SIG` | Yes | Yes | Yes |
| `MODULE_SIG_FORCE` | No | No (SHA512 row differs) | Yes (intent) |
| Independently verifiable | **Yes** — pin SHA-256 + pack | Bundled in checker | Bundled in checker |

\* KSPP is a recommendation fragment, not a shipping kernel.

Legacy 5.19.6 glance (checker `b9b83a0`, not comparable item-for-item): attack-surface 68.9% (91/132), exploit-resistance 28.4% (31/109), 0 modules loaded / 9 `.ko`. See the [5.19.6 matrix](kernel-comparison-matrix-5.19.6/).

---

## What changed between 5.19.6 and this pin

This section describes the August #37 config, not the kernel that ships.

On **5.19.6**, Root Lock compiled out BPF, user namespaces, FUSE, OverlayFS, AppArmor, and TOMOYO, and sat near vanilla on exploit-resistance.

On **6.18.9-hs #37** the picture is reversed:

- The same bypass primitives are compiled in, with OverlayFS as a module (`OVERLAY_FS=m`).
- Live LSM on the measured guest: `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm`.
- Exploit-resistance options `INIT_ON_ALLOC_DEFAULT_ON`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM` / `_HARDENED`, `KFENCE`, and `MODULE_SIG` are **on**.
- `IO_URING`, `KEXEC`, and `KEXEC_FILE` are **=y**.

On this pin, the allowlist constrains programs that have no allowlist entry, and Lockdown, once engaged, also constrains new module loads. Both work by policy decision in the kernel. On that August config the syscalls do not return `ENOSYS`. On the kernel that ships, `bpf()` returns `ENOSYS`. io_uring, FUSE, OverlayFS, and KVM do not.

---

## Broader market landscape

| Tool | Bypass prevention | Exploit resistance | Module footprint | Availability |
|---|---|---|---|---|
| **Root Lock 6.18.9-hs #37** | Low–moderate on compile-out (measured 43.5% AS) | Moderate–high (measured 70.9% ER) | 74 loaded / thousands shipped | Commercial |
| **Root Lock 5.19.6** (legacy) | **Very high** compile-out (measured 68.9% AS) | Low — vanilla baseline (28.4% ER) | **0 loaded / 9 `.ko`** | Commercial (legacy) |
| Arch linux-hardened 6.18.16 | Moderate | **High** (83.6% ER measured) | Hundreds | Free, open-source |
| grsecurity / PaX | High | **Very high** | Large | Paid subscription |
| CLIP OS (ANSSI) | High | High | ~400 | Public (archived) |
| GrapheneOS | High (Android) | **Very high** | Android-specific | Free, open-source |

Arch 6.18.16 is era-matched. The 5.19.6 row uses the older pack.

---

## Decision guide

**Choose Root Lock if your primary concern is:**

- Kernel-enforced allowlist and Lockdown on a dedicated host
- A closed, reviewed program set after Setup Mode
- Running as a **guest** on KVM, VMware, or cloud hypervisors

**Consider extra kernel hardening or a future derived cut if you also need:**

- The 5.19-style compiled-out bypass list (`BPF=n`, `IO_URING=n`, `KEXEC=n`, …)
- KSPP items still FAIL on this pin (`INIT_ON_FREE`, `KSTACK_ERASE`, `MODULE_SIG_FORCE`, …)

Root Lock is host-local kernel enforcement, so it does not replace network firewalls, WAFs, SIEM, or EDR hunting.

---

## Verification

```
Pin config SHA-256: 3cd1824742b9a15e9467c774c5f62081f9547f730ad7cd9bce464a7d286a7db9
vmlinuz SHA-256:    1b44fffb9b570497f19f4c68e170602b542bc84bfe9f49d936c123dc59f5db8a
uname -r:           6.18.9-hs
file(1) build:      #37
Tool: https://github.com/a13xp0p0v/kernel-hardening-checker (commit e870d0141259f875d3d1b54fef49dec7074e4cac)
Expected checker:   OK 148 / FAIL 111
```

Do not hash guest `/boot/config-6.18.9-hs`, because it is an 11-line initramfs stub rather than the build config. Full methodology: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt).
