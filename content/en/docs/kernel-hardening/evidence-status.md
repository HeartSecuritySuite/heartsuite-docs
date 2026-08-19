---
title: "Which kernel evidence is published today"
linkTitle: "Evidence Status"
weight: 16
description: "6.18.9-hs #37 evidence pack is published (2026-08-18). 5.19.6 remains the legacy measured stream."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "evidence", "procurement"]
type: docs
toc: true
---

**Subject:** Root Lock by HeartSuite kernel evidence  
**Fielded 6.18 pin:** `6.18.9-hs` / packaging `6.18.9-HeartSuite-3` / build **#37**  
**Legacy stream:** kernel **5.19.6** (maintenance-only; see [Kernel Support Policy](kernel-support-policy/#519-stream-deprecation))

---

## Summary

| Stream | Role | Config SHA-256 | Evidence pack | Comparison matrix | Checker run | Runtime verification |
|---|---|---|---|---|---|---|
| **6.18.9-hs #37** | Fielded pin / new deployments | `3cd18247…` in [pack](../evidence-pack-6.18.9.txt) | [Published](../evidence-pack-6.18.9.txt) | [Published](kernel-comparison-matrix-6.18.9/) | 2026-08-18 (`e870d01`) | 2026-08-18 (Debian 12 guest) |
| **5.19.6** | Legacy / existing fleets | [Published](../evidence-pack-5.19.6.txt) | [Published](../evidence-pack-5.19.6.txt) | [Published](kernel-comparison-matrix-5.19.6/) | 2026-05-19 (`b9b83a0`) | 2026-05-19 (Debian 12 VM) |

The two lines do **not** share the same kernel config. 5.19.6 compiled out BPF/FUSE/OVERLAY/USER_NS/AppArmor/TOMOYO. Fielded 6.18.9-hs #37 compiles those in. Treat 5.19.6 scores as **legacy**, not as a substitute for 6.18.9-hs.

---

## What is published today (6.18.9-hs #37)

- **Identity** — uname `6.18.9-hs`, `file` `#37`, vmlinuz SHA-256 `1b44fffb…`, pin config SHA-256 `3cd18247…` in [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt)
- **Automated scores** — checker `e870d01`: overall 148/259 (57.1%), attack-surface 57/131 (43.5%), exploit-resistance 78/110 (70.9%)
- **Runtime** — Debian 12 guest: 74 modules loaded, 4190 `.ko.xz`, LSM `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm`, Root Lock activate at t+4s
- **Buyer and auditor summaries** — [Procurement Brief](procurement-brief/) and [Auditor Brief](auditor-brief/) now follow this pack

**Known limits of this publication**

- Era-matched Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are in the pack.
- Guest `/boot/config-6.18.9-hs` is an 11-line RD stub. `CONFIG_IKCONFIG` is off. Analysis uses the pin payload config whose SHA matches `VERSION_MAP`.
- This is the **fielded** pin, including `IO_URING=y`, `KEXEC=y`, `KEXEC_FILE=y`. It is not a derived unpublished hardening cut.

---

## What remains from 5.19.6

The 5.19.6 pack is unchanged and still reproducible (checker `b9b83a0`, SHA `d67caa6…` / `fa227f1d…`). Do not add 5.19.6 percentages to a 6.18.9-hs deployment report.

---

## Evidence parity roadmap

| Milestone | Status |
|---|---|
| 6.18.9-hs #37 pin SHA + checker + runtime pack | **Done** (2026-08-18) |
| Auditor / procurement / 6.18 matrix refresh from that pack | **Done** (2026-08-18) |
| Era-matched Arch linux-hardened **6.18.16** row | **Done** (2026-08-18) |
| Era-matched vanilla **6.18.9** `defconfig` | **Done** (2026-08-18) |
| `/boot/config-*` matching the pin (stop shipping the RD stub as `config-6.18.9-hs`) | **Open** — installer/product |
| Derived cut with IO_URING/KEXEC/BPF compiled out | **Not this pin** — do not advertise as shipped |

---

## For procurement and audit teams

**Evaluating a 6.18.9-hs deployment today**

- Use [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) and [Auditor Brief](auditor-brief/).
- Confirm `uname -r` is `6.18.9-hs` and `file` on vmlinuz contains `#37`. Absence of the word `HeartSuite` does not mean the maintenance kernel.
- Do not close BPF/FUSE/io_uring scanner findings as compiled-out on this pin.

**Evaluating a 5.19.6 legacy fleet**

- Use [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt). Plan migration per the support policy.

---

## Related pages

- [Hardening matrix for kernel 6.18.9](kernel-comparison-matrix-6.18.9/)
- [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/)
- [Enterprise Adoption Guide](enterprise-adoption-guide/)
