---
title: "Procurement Brief: Kernel Hardening at a Glance"
weight: 5
description: "Plain-language comparison of Root Lock by HeartSuite HS kernel hardening against industry alternatives — 6.18.9 primary commercial baseline; measured tables reference the published 5.19.6 legacy stream until 6.18.9 evidence ships."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "procurement", "comparison"]
type: docs
toc: true
---

**Overview**: Side-by-side comparison of HeartSuite's kernel hardening choices against community hardened kernels and industry benchmarks — start here if you are evaluating the HS kernel for procurement.

**Subject:** Root Lock by HeartSuite HS kernel — **6.18.9 primary** (commercial baseline, HeartSuite v1.6.4), **5.19.6 legacy**  
**Evidence status:** Measured scores on this page reference the **published 5.19.6** stream (2026-05-19, [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker)). New deployments use **6.18.9**; config hash and checker parity for that stream are in progress — see [Evidence Status](evidence-status/) and [Kernel Hardening Comparison Matrix (6.18.9)](kernel-comparison-matrix-6.18.9/).  
**Legacy technical data (measured):** [kernel-comparison-matrix-5.19.6.md](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

For enterprise buyers and CISOs evaluating the custom kernel in regulated environments — including deployment patterns, Secure Boot status, fleet management, risk transfer, supply chain artifacts, recovery paths, compatibility, and alternatives for strict "no custom kernel" policies — see the [Enterprise Adoption Guide](enterprise-adoption-guide/). Kernel support policy, distribution compatibility, and scanner hygiene: [Kernel Support Policy](kernel-support-policy/), [Distro Compatibility Matrix](distro-compatibility-matrix/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

---

## What this document covers

Every Linux kernel ships with hundreds of configuration choices that determine how easy it is to exploit vulnerabilities or escape security controls. This document compares HeartSuite's kernel choices to a directly comparable community-hardened kernel and the KSPP industry benchmark.

All numbers in the tables below are outputs of the same measurement tool applied identically to each **5.19.6-era** kernel configuration. No estimates. The Arch linux-hardened comparison uses the 5.19.11 release — the same kernel generation as HeartSuite 5.19.6, making scores directly comparable. **Do not** apply these figures to **6.18.9** deployments; request pre-release 6.18.9 evidence via support or watch [Evidence Status](evidence-status/) for publication.

---

## At a glance

| What you care about | HS 5.19.6 | Arch linux-hardened 5.19.11 | KSPP benchmark |
|---|---|---|---|
| Dangerous features disabled | **68.9%** (91/132 checks) | 58.3% (77/132) | 99.2% (131/132) |
| Exploit-resistance mitigations | 28.4% (31/109 checks) | **63.3%** (69/109) | 85.3% (93/109) |
| Loadable kernel modules at runtime | **0 loaded** (9 available) | Hundreds | Not measured |
| BPF subsystem disabled | **Yes** | No | Yes |
| AppArmor / TOMOYO / YAMA / Landlock / IMA / EVM disabled | **Yes (all 6)** | No | No |
| Module signing enforced | No | **Yes** | Yes |
| Independently verifiable | **Yes** — SHA-256 published | Yes | Yes |

*KSPP benchmark anchored to kernel 6.17; its version-agnostic recommendations set the de facto industry target but are not directly score-comparable to 5.19.x.*

---

## What HeartSuite is optimized for

HeartSuite removes or disables the kernel features that are most commonly used to *bypass* security controls — not necessarily those used to *exploit* vulnerabilities.

This means:

- **Attacker cannot use BPF** to override security decisions at runtime. (Arch linux-hardened keeps BPF enabled; it's widely used by system tools and container runtimes.)
- **Attacker cannot use user namespaces** (`CONFIG_USER_NS=n`) to create a fake root environment. (Arch linux-hardened 5.19.11 keeps user namespaces enabled for container use.)
- **Attacker cannot use FUSE or overlay filesystems** to confuse path-based enforcement.
- **No competing security policies** (AppArmor, SELinux at runtime, YAMA, Landlock, IMA, EVM) that could interfere with or be manipulated to weaken HeartSuite's decisions.

What HeartSuite does *not* add — and dedicated hardened kernels do:

- Memory initialization on allocation/free (`INIT_ON_ALLOC_DEFAULT_ON`, `INIT_ON_FREE_DEFAULT_ON`)
- Bounds-checking on kernel-to-user copies (`HARDENED_USERCOPY`)
- Compiler-level hardening (`FORTIFY_SOURCE`, `RANDSTRUCT`, `GCC_PLUGIN_LATENT_ENTROPY`)
- Allocator randomization (`SLAB_FREELIST_RANDOM`, `SLAB_FREELIST_HARDENED`)
- Kernel stack erasure on syscall return (`KSTACK_ERASE`)

These mitigations slow down or prevent exploitation of kernel memory bugs. Arch linux-hardened 5.19.11 scores 69/109 (63.3%) on this axis vs HS's 31/109 (28.4%). HeartSuite 5.19.6 sits at the vanilla upstream baseline for exploit-resistance. For deployments where the primary concern is a compromised process escaping its enforcement boundary — not kernel memory exploitation — HeartSuite covers the relevant threat at the right operating point; the Decision guide below covers when adding exploit-resistance hardening alongside HeartSuite makes sense.

---

## Broader market landscape

| Product | Bypass Prevention | Exploit Resistance | Module Footprint | Availability |
|---|---|---|---|---|
| **HeartSuite 5.19.6** | **Very High** — BPF/FUSE/OVERLAY/AppArmor/TOMOYO/USER_NS disabled | Low — vanilla upstream baseline | **~9 modules** | Commercial |
| Arch linux-hardened 5.19.11 | Moderate — keeps BPF, FUSE, AppArmor, USER_NS | **High** — HARDENED_USERCOPY, FORTIFY_SOURCE, INIT_ON_ALLOC, SLAB_FREELIST | Hundreds | Free, open-source |
| grsecurity / PaX | High | **Very High** — RBAC + PaX heap/stack protections | Large | Paid subscription |
| CLIP OS (ANSSI) | High — minimal modules, BPF disabled | High — KSPP-style mitigations | ~400 | Public (archived) |
| Hardened Gentoo | Moderate | High | Large | Free, open-source |
| GrapheneOS | High (Android-targeted) | **Very High** — extensive Android hardening patches | Android-specific | Free, open-source |
| Kicksecure / Whonix | Low–Moderate | Low–Moderate — mostly OS-level, not kernel patches | Standard Debian | Free, open-source |

*Note: NixOS `linux_hardened` was removed from nixpkgs in 2025 due to lack of maintenance and is no longer an active project. Qualitative characterizations are drawn from each project's public documentation. Only HS and Arch linux-hardened scores are directly measured and era-matched.*

---

## Decision guide

**Choose HeartSuite if your primary concern is:**

- Preventing a compromised application from escaping its security boundary
- Ensuring no in-kernel feature (BPF, FUSE, namespaces) can be used to bypass your security policy
- Minimizing the total kernel attack surface (9 loadable modules vs. thousands)
- Running a single-purpose security appliance, not a general-purpose server

**Consider adding a hardened kernel layer if your concern is also:**

- Protection against kernel-level exploitation (heap corruption, use-after-free, ROP)
- Compliance requirements that enumerate specific KSPP mitigations
- Environments where root access cannot be fully constrained

**HeartSuite is not a replacement for:** network firewalls, application-layer WAFs, SIEM, endpoint detection/response — it operates at the kernel enforcement layer, not at the network or application layer.

---

## Verification

HeartSuite's kernel configuration is published with a SHA-256 hash. Any qualified security team can reproduce these measurements using the open-source `kernel-hardening-checker` tool:

```
Config SHA-256: d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc
Tool: https://github.com/a13xp0p0v/kernel-hardening-checker (commit b9b83a0)
```

Full methodology and raw data: `evidence-pack-5.19.6.txt`
