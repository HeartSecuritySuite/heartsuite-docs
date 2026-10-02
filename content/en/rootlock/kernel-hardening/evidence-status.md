---
title: "Which kernel evidence is published today"
linkTitle: "Evidence Status"
weight: 16
description: "Build #43 is the kernel that ships. Its checker pack has no guest boot. The 18 August 2026 pack is build #37. 5.19.6 remains the legacy measured stream."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "evidence", "procurement"]
type: docs
aliases:
  - /docs/kernel-hardening/evidence-status/
toc: true
---

**Subject:** Root Lock kernel evidence  
**Kernel that ships:** `6.18.9-hs` build `#43`, packaging `6.18.9-HeartSuite-3`. The BPF syscall is off.  
**Checker pack for that binary:** [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) (2026-10-02). Config and checker only. No guest boot.  
**18 August 2026 pack:** build `#37`, [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt). That pack includes the Debian 12 guest boot.  
**Legacy stream:** kernel **5.19.6** (maintenance-only; see [Kernel Support Policy](kernel-support-policy/#519-stream-deprecation))

---

## Summary

| Stream | Role | Config SHA-256 | Evidence pack | Comparison matrix | Checker run | Runtime verification |
|---|---|---|---|---|---|---|
| **6.18.9-hs build #43** | Kernel that ships | `d6a08a04…` in [pack](../evidence-pack-6.18.9.txt) | [Published](../evidence-pack-6.18.9.txt) | [Published](kernel-comparison-matrix-6.18.9/) | 2026-10-02 (`e870d01`) | Not repeated |
| **6.18.9-hs build #37** | 18 August 2026 pack | `3cd18247…` in [pack](../evidence-pack-6.18.9-2026-08-18.txt) | [Published](../evidence-pack-6.18.9-2026-08-18.txt) | Scores kept in that pack | 2026-08-18 (`e870d01`) | 2026-08-18 (Debian 12 guest) |
| **5.19.6** | Legacy / existing fleets | [Published](../evidence-pack-5.19.6.txt) | [Published](../evidence-pack-5.19.6.txt) | [Published](kernel-comparison-matrix-5.19.6/) | 2026-05-19 (`b9b83a0`) | 2026-05-19 (Debian 12 VM) |

5.19.6 scores are legacy. Build #37 is the 18 August measurement. Build #43 is the kernel that ships.

---

## What the build #43 pack contains

- **Identity** — `file` `#43`, vmlinuz SHA-256 `f2e47498…`, packaging config SHA-256 `d6a08a04…` in [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt)
- **Automated scores** — checker `e870d01`, run 2026-10-02: overall 153/259 (59.1%), attack-surface 62/131 (47.3%), exploit-resistance 78/110 (70.9%)
- **Runtime** — not repeated. The Debian 12 guest boot is the build #37 pack.
- **What moved since #37** — `CONFIG_BPF_SYSCALL`, `CONFIG_KEXEC`, `CONFIG_KEXEC_FILE`, `CONFIG_CRASH_DUMP`, and `CONFIG_PROC_VMCORE` are unset. `CONFIG_IO_URING` stays `y`.
- **Buyer pages** — [Procurement Brief](procurement-brief/), [Threat model](auditor-brief/), and the [6.18.9 matrix](kernel-comparison-matrix-6.18.9/) use these checker totals. Arch and vanilla columns stay the 18 August rows.

## What the 18 August 2026 pack contains

- **Identity** — uname `6.18.9-hs`, `file` `#37`, vmlinuz SHA-256 `1b44fffb…`, config SHA-256 `3cd18247…` in [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt)
- **Automated scores** — checker `e870d01`: overall 148/259 (57.1%), attack-surface 57/131 (43.5%), exploit-resistance 78/110 (70.9%)
- **Runtime** — Debian 12 guest: LSM `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm`, Root Lock activation at t+4s. Procurement, the threat model, and the 6.18.9 matrix cite this guest when they name a booted LSM list.

**Known limits of this publication**

- Era-matched Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are in the pack.
- Guest `/boot/config-6.18.9-hs` is an 11-line initramfs stub, and `CONFIG_IKCONFIG` is off, so the running kernel does not export its config either. Analysis therefore uses the pin payload config, whose SHA-256 is recorded in the pack.
- This pack is the 18 August 2026 run. It is not the kernel that ships.

---

## What remains from 5.19.6

The 5.19.6 pack is unchanged and still reproducible (checker `b9b83a0`, SHA `d67caa6…` / `fa227f1d…`). Do not add 5.19.6 percentages to a 6.18.9-hs deployment report.

---

## Evidence parity roadmap

| Milestone | Status |
|---|---|
| 18 August 2026 pack: SHA, checker, and runtime notes | **Done** (2026-08-18) |
| Auditor / procurement / 6.18 matrix refresh from the 18 August pack | **Done** (2026-08-18); superseded for checker totals by the #43 row below |
| Build #43 matrix, procurement, and auditor checker totals | **Done** (2026-10-02) |
| Era-matched Arch linux-hardened **6.18.16** row | **Done** (2026-08-18) |
| Era-matched vanilla **6.18.9** `defconfig` | **Done** (2026-08-18) |
| Build #43 checker run on the packaging config | **Done** (2026-10-02) |
| Build #43 guest boot (LSM list, lsmod, dmesg) | Not run |

---

## For procurement and audit teams

**Evaluating a 6.18.9-hs deployment today**

- Use [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) for build #43 (config and checker). Use [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt) when you need the guest boot. Threat model: [auditor brief](auditor-brief/).
- Confirm `uname -r` is `6.18.9-hs`. The `uname -r` string does not contain the word `HeartSuite`, so its absence is not a sign that the maintenance kernel is running.
- On the kernel that ships, the BPF syscall is off, so there is no eBPF program to load. A finding stays on the patch date when that option is set on the kernel you boot.

**Evaluating a 5.19.6 legacy fleet**

- Use [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt). Plan migration per the support policy.

---

## Related pages

- [Hardening matrix for kernel 6.18.9](kernel-comparison-matrix-6.18.9/)
- [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/)
- [Enterprise Adoption Guide](enterprise-adoption-guide/)
