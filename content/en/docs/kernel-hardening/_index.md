---
title: "Kernel Hardening"
weight: 108
description: "Objective, measurement-backed analysis of Root Lock by HeartSuite's kernel hardening posture — design rationale, comparison against industry references, and reproducible evidence."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison"]
type: docs
toc: false
---

Root Lock by HeartSuite runs a custom-built Linux kernel (5.19.6) with a specific hardening philosophy: remove the kernel subsystems that make security-control bypass possible, rather than patch around them.

This section documents that posture with reproducible measurements. Every number derives from the open-source `kernel-hardening-checker` tool applied identically to HeartSuite and the reference kernels. No estimates. The raw evidence file and the config SHA-256 are included so any qualified team can verify independently.

## In this section

- [Comparison Matrix](kernel-comparison-matrix-5.19.6/) — Full scoring table: HeartSuite vs vanilla defconfig, Debian, NixOS hardened, Arch hardened, and KSPP target. Two axes: attack-surface reduction and exploit-resistance mitigations.
- [LSM Comparison](lsm-comparison/) — HeartSuite vs SELinux, AppArmor, and TOMOYO: enforcement model, bypass-primitive resistance, and co-existence.
- [Auditor Brief](auditor-brief/) — Threat model, measured strengths and gaps, residual risks, and self-reproduction commands for security auditors and red teams.
- [Procurement Brief](procurement-brief/) — Plain-language comparison table and decision guide for buyers.
- [Analyst Summary](analyst-summary/) — Non-technical summary for journalists and analysts, with fact-checker citations.
