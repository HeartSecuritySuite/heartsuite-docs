---
title: "Kernel hardening in one comparison table"
linkTitle: "Procurement Brief"
weight: 5
description: "Side-by-side hardening of the fielded 6.18.9-hs Root Lock kernel against bundled checker references — for procurement and architecture reviews."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "procurement", "comparison"]
type: docs
toc: true
---

**Overview**: Side-by-side comparison of Root Lock by HeartSuite kernel configuration choices against community hardened kernels and the KSPP benchmark.

**Subject:** Fielded **6.18.9-hs** (packaging `6.18.9-HeartSuite-3`, build **#37**). **5.19.6** is the legacy measured stream.  
**Evidence:** [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) (2026-08-18, checker `e870d01`). Legacy: [5.19.6 matrix](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt).

For deployment, Secure Boot, fleet, and “no custom kernel” alternatives see the [Enterprise Adoption Guide](enterprise-adoption-guide/). Support and scanner notes: [Kernel Support Policy](kernel-support-policy/), [Distro Compatibility Matrix](distro-compatibility-matrix/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

---

## What this document covers

All numbers below are outputs of `kernel-hardening-checker` commit `e870d0141259f875d3d1b54fef49dec7074e4cac` applied to the **#37 pin config** (SHA-256 `3cd1824742b9a15e9467c774c5f62081f9547f730ad7cd9bce464a7d286a7db9`) and to configs bundled with that checker.

Arch linux-hardened **6.18.16-hardened1** is the era-matched 6.18.x peer. Vanilla 6.17.3 is cross-version orientation. **Do not** mix these percentages with the 5.19.6 pack (checker `b9b83a0`).

This page measures the **fielded** pin. It does not describe a derived cut that disables `IO_URING` or `KEXEC`.

---

## At a glance (fielded 6.18.9-hs #37)

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

\* KSPP is a recommendation fragment, not a shipping kernel. Vanilla 6.17.3 in the pack is still cross-version.

Legacy 5.19.6 glance (checker `b9b83a0`, **not** comparable item-for-item): attack-surface 68.9% (91/132), exploit-resistance 28.4% (31/109), 0 modules loaded / 9 `.ko`. See the [5.19.6 matrix](kernel-comparison-matrix-5.19.6/).

---

## What this pin is and is not

On **5.19.6**, Root Lock compiled out BPF, user namespaces, FUSE, OverlayFS, AppArmor, and TOMOYO, and sat near vanilla on exploit-resistance.

On **fielded 6.18.9-hs #37** that story is inverted:

- Bypass primitives above are **compiled in** (`OVERLAY_FS=m`).
- Live LSM on the measured guest: `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm`.
- Exploit-resistance options `INIT_ON_ALLOC_DEFAULT_ON`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM` / `_HARDENED`, `KFENCE`, and `MODULE_SIG` are **on**.
- `IO_URING`, `KEXEC`, and `KEXEC_FILE` are **=y**.

Lockdown and the allowlist still constrain unallowlisted programs and (when engaged) new module loads. That is policy, not `ENOSYS`.

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

**Do not choose it expecting the 5.19.6 compile-out brochure on a 6.18.9-hs host.** BPF, FUSE, OverlayFS, user namespaces, and AppArmor are present on this pin. Local eBPF tooling and FUSE are not `ENOSYS`.

**Consider extra kernel hardening or a future derived cut if you also need:**

- The 5.19-style compiled-out bypass list (`BPF=n`, `IO_URING=n`, `KEXEC=n`, …)
- KSPP items still FAIL on this pin (`INIT_ON_FREE`, `KSTACK_ERASE`, `MODULE_SIG_FORCE`, …)

**Root Lock is not a replacement for** network firewalls, WAFs, SIEM, or EDR hunting. It is host-local kernel enforcement.

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

Do not hash guest `/boot/config-6.18.9-hs` (11-line RD stub). Full methodology: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt).
