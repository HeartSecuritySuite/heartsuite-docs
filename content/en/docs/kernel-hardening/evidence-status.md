---
title: "Kernel Evidence Status"
weight: 16
description: "Publication status of HS kernel hardening evidence — 5.19.6 legacy stream (published) and 6.18.9 primary commercial baseline (in progress)."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "evidence", "procurement"]
type: docs
toc: true
---

**Subject:** Root Lock by HeartSuite HS kernel evidence parity  
**Commercial baseline:** HeartSuite v1.6.4 — kernel **6.18.9** (`6.18.9-HeartSuite-1.0`)  
**Legacy stream:** kernel **5.19.6** (maintenance-only; see [Kernel Support Policy](kernel-support-policy/#519-stream-deprecation))

---

## Summary

| Stream | Role | Config SHA-256 | Evidence pack | Comparison matrix | Checker run | Runtime verification |
|---|---|---|---|---|---|---|
| **6.18.9** | Primary LTS / new deployments | **Pending publication** | **In progress** | [Structure published](kernel-comparison-matrix-6.18.9/) | **Pending publication** | **Pending publication** |
| **5.19.6** | Legacy / existing fleets | [Published](../evidence-pack-5.19.6.txt) | [Published](../evidence-pack-5.19.6.txt) | [Published](kernel-comparison-matrix-5.19.6/) | 2026-05-19 (`b9b83a0`) | 2026-05-19 (Debian 12 VM) |

HeartSuite ships two HS kernel lines with the same Root Lock enforcement contract. **New subscriptions and fleet images should standardize on 6.18.** Public hardening evidence for that stream is being brought to parity with the 5.19.6 publication; until then, procurement and audit teams should treat 5.19.6 measurements as **illustrative of design philosophy**, not as a score-for-score substitute for 6.18.9.

---

## What is published today (5.19.6)

The following artifacts are complete and independently reproducible:

- **Config identity** — SHA-256 for `config-5.19.6-HeartSuite-1.0` and `config-5.19.6-HeartSuite-2.0` in [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)
- **Automated scores** — `kernel-hardening-checker` commit `b9b83a0`, era-matched comparison against Arch linux-hardened 5.19.11 and vanilla defconfig, in [`kernel-comparison-matrix-5.19.6.md`](kernel-comparison-matrix-5.19.6/)
- **Runtime posture** — module inventory, SELinux permissive state, HeartSuite enforcement trace, bypass-primitive grep results (sections 2–5 of the evidence pack)
- **Buyer and auditor summaries** — [Procurement Brief](procurement-brief/) and [Auditor Brief](auditor-brief/) (detailed measured sections currently reference 5.19.6 data)

---

## What is in progress (6.18.9)

The 6.18 LTS port closed known gaps documented for 5.19.6 — notably **`CONFIG_IO_URING`** and **`CONFIG_KEXEC`** are disabled in the 6.18.x HS config (design intent recorded in the deviation registry). Public publication still requires:

1. **Canonical config SHA-256** for `config-6.18.9-HeartSuite-1.0` (and any subsequent bundle revision)
2. **`evidence-pack-6.18.9.txt`** — raw checker output, per-category scores, bypass-primitive verification, module inventory, runtime LSM state
3. **Era-matched comparison** — HS 6.18.9 vs Arch linux-hardened (or equivalent) on the **same 6.18.x** Kconfig namespace
4. **Runtime verification** — `uname -r`, `/boot/config-*` hash match, `lsmod`, SELinux state, HeartSuite activation in dmesg on a representative validated distribution

The [Kernel Hardening Comparison Matrix (6.18.9)](kernel-comparison-matrix-6.18.9/) page mirrors the 5.19.6 structure. Sections that depend on measured output are marked **Pending publication — engage support for pre-release evidence** until the artifacts above are released.

---

## Evidence parity roadmap

| Milestone | Target content | Status |
|---|---|---|
| Structure parity | 6.18.9 comparison matrix page layout matching 5.19.6 | **Done** (this docs release) |
| Config publication | SHA-256 + path for `config-6.18.9-HeartSuite-1.0` | Pending |
| Checker publication | Full `kernel-hardening-checker` run on HS 6.18.9 + era-matched references | Pending |
| Runtime pack | VM or gate-validated runtime section (modules, LSM, enforcement) | Pending |
| Brief refresh | Procurement and Auditor briefs updated with 6.18.9 measured tables | Pending (intros dual-stream; body follows evidence) |
| Legacy sunset comms | 5.19 stream deprecation timeline in [Kernel Support Policy](kernel-support-policy/#519-stream-deprecation) | Published (policy); evidence remains for audit history |

---

## For procurement and audit teams

**Evaluating a 6.18.9 deployment today**

- Use [Distro Compatibility Matrix](distro-compatibility-matrix/) and [Kernel Support Policy](kernel-support-policy/) for support boundaries, version strings, and patch targets.
- Use [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) for vulnerability-management workflows — do not infer HS reachability from upstream `6.18.9` alone.
- For hardening scores comparable to the 5.19.6 publication, request **pre-release evidence** through your HeartSuite support channel. Reference HeartSuite v1.6.4 / tag `hs-v1.6.4-kernel-6.18.9` and the expected version string `6.18.9-HeartSuite-1.0`.

**Evaluating a 5.19.6 legacy fleet**

- Full public evidence remains authoritative for that stream. Plan migration to 6.18 per the support policy; do not extend 5.19.6 checker scores to 6.18.9 without the published 6.18 pack.

**Reproducing 5.19.6 measurements now**

See [Auditor Brief](auditor-brief/#how-to-reproduce-these-measurements) for `kernel-hardening-checker` commands and expected SHA-256.

---

## Related pages

- [Kernel Hardening Comparison Matrix (6.18.9)](kernel-comparison-matrix-6.18.9/) — primary stream structure (measured sections pending)
- [Kernel Hardening Comparison Matrix (5.19.6)](kernel-comparison-matrix-5.19.6/) — legacy stream, fully measured
- [Enterprise Adoption Guide](enterprise-adoption-guide/) — supply chain, verification, and regulated-deployment context
