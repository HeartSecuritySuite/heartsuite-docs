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

**Subject:** kernel that ships, **6.18.9-hs** build **#43** (packaging `6.18.9-HeartSuite-3`). **5.19.6** is the legacy measured stream.  
**Evidence:** tables below are the 2026-10-02 checker run, [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) (checker `e870d01`, 153/259). The 18 August guest boot is build #37, [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt). Legacy: [5.19.6 matrix](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt).

**Kernel that ships:** `uname -r` is `6.18.9-hs`. The BPF syscall is off. `CONFIG_IO_URING=y`. `CONFIG_KEXEC` and `CONFIG_KEXEC_FILE` are unset.

For deployment, Secure Boot, fleet, and “no custom kernel” alternatives see the [Enterprise Adoption Guide](enterprise-adoption-guide/). Support and scanner notes: [Kernel Support Policy](kernel-support-policy/), [Distro Compatibility Matrix](distro-compatibility-matrix/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

---

## What this document covers

HeartSuite numbers below are outputs of `kernel-hardening-checker` commit `e870d0141259f875d3d1b54fef49dec7074e4cac` applied to the **#43 packaging config** (SHA-256 `d6a08a04f4d6734adbafac431c3ebe46d339a495d907f1c6c569959321cc3684`). Arch, vanilla, and KSPP rows are the 18 August 2026 run of that same commit.

Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are the era-matched 6.18.x peers. Do not mix these percentages with the 5.19.6 pack, because its checker commit (`b9b83a0`) counts a different set of items.

---

## At a glance (6.18.9-hs build #43, checker run 2026-10-02)

| What you care about | HS 6.18.9-hs #43 | Arch linux-hardened 6.18.16 | KSPP x86-64* |
|---|---|---|---|
| Dangerous features disabled (attack-surface) | 47.3% (62/131) | 58.0% (76/131) | 100% (131/131) |
| Exploit-resistance mitigations | 70.9% (78/110) | **83.6%** (92/110) | 84.5% (93/110) |
| Overall checker | 59.1% (153/259) | 69.9% (181/259) | 91.4% (235/257) |
| `MODULE_SIG` | Yes | Yes | Yes |
| `MODULE_SIG_FORCE` | No | No (SHA512 row differs) | Yes (intent) |
| Independently verifiable | **Yes** — pin SHA-256 + pack | Bundled in checker | Bundled in checker |

\* KSPP is a recommendation fragment, not a shipping kernel.

Legacy 5.19.6 glance (checker `b9b83a0`, not comparable item-for-item): attack-surface 68.9% (91/132), exploit-resistance 28.4% (31/109). See the [5.19.6 matrix](kernel-comparison-matrix-5.19.6/).

---

## What changed between 5.19.6 and this pin

On 6.18.9-hs #43, exploit-resistance options `INIT_ON_ALLOC_DEFAULT_ON`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM` / `_HARDENED`, `KFENCE`, and `MODULE_SIG` are **on**. `INIT_ON_FREE_DEFAULT_ON` and `MODULE_SIG_FORCE` stay off. `CONFIG_IO_URING=y`. `CONFIG_KEXEC` and `CONFIG_KEXEC_FILE` are unset. `bpf()` returns `ENOSYS`.

The allowlist constrains programs that have no allowlist entry. On every HeartSuite-kernel boot, including Setup, `heartsuite-kernel-latch.service` sets `kernel.modules_disabled=1` at sysinit, before sshd. A later modprobe stays refused. That latch is a boot script. `HS_lockdown.sh` writes the same setting again if the oneshot is masked.

---

## Broader market landscape

| Tool | Bypass prevention | Exploit resistance | Availability |
|---|---|---|---|
| **Root Lock 6.18.9-hs #43** | Measured 47.3% attack-surface | Moderate–high (measured 70.9% ER) | Commercial |
| **Root Lock 5.19.6** (legacy) | Measured 68.9% attack-surface | Low — vanilla baseline (28.4% ER) | Commercial (legacy) |
| Arch linux-hardened 6.18.16 | Moderate | **High** (83.6% ER measured) | Free, open-source |
| grsecurity / PaX | High | **Very high** | Paid subscription |
| CLIP OS (ANSSI) | High | High | Public (archived) |
| GrapheneOS | High (Android) | **Very high** | Free, open-source |

Arch 6.18.16 is era-matched. The 5.19.6 row uses the older pack.

---

## Decision guide

**Choose Root Lock if your primary concern is:**

- Kernel-enforced allowlist and Lockdown on a dedicated host
- A closed, reviewed program set after Setup Mode
- Running as a **guest** on KVM, VMware, or cloud hypervisors

**Consider extra kernel hardening or a future derived cut if you also need:**

- KSPP items still FAIL on this pack (`INIT_ON_FREE`, `KSTACK_ERASE`, `MODULE_SIG_FORCE`, …)

Root Lock is host-local kernel enforcement, so it does not replace network firewalls, WAFs, SIEM, or EDR hunting.

---

## Verification

```
Packaging config SHA-256: d6a08a04f4d6734adbafac431c3ebe46d339a495d907f1c6c569959321cc3684
vmlinuz SHA-256:          f2e4749856f56cde87f9bcc887620f2d9b0aa2066756e4d3501326660b926c92
uname -r:                 6.18.9-hs
file(1) build:            #43
Tool: https://github.com/a13xp0p0v/kernel-hardening-checker (commit e870d0141259f875d3d1b54fef49dec7074e4cac)
Expected checker:         OK 153 / FAIL 106
```

Hash the packaging config. Guest `/boot/config-6.18.9-hs` is an 11-line initramfs stub. Full notes: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt). The Debian 12 guest boot is build #37: [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt).
