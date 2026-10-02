---
title: "Kernel hardening"
linkTitle: "Kernel Hardening"
weight: 108
description: "Buyer briefs, scanner hygiene, distro fit, and measured evidence."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison"]
type: docs
aliases:
  - /docs/kernel-hardening/
toc: false
---

**Overview**: Root Lock by HeartSuite runs custom-built Linux kernels (5.19 legacy and 6.18 primary LTS). This section covers buyer evaluation, support policy, compatibility, scanner hygiene, and reproducible evidence.

## For buyers and procurement

Start here if you are evaluating the Root Lock kernel for a regulated or enterprise fleet:

- [Procurement Brief](procurement-brief/) — Comparison table and decision guide at a glance.
- [Enterprise Adoption Guide](enterprise-adoption-guide/) — CISO and procurement guidance: deployment, fleet operations, Secure Boot status, supply chain, recovery, and honest limitations.
- [Distro Compatibility Matrix](distro-compatibility-matrix/) — Validated and supported distributions, RHEL-family guidance, workload fit, and HJFS alternative.
- [Kernel Support Policy](kernel-support-policy/) — LTS strategy, patch targets, update delivery, version-string semantics, and boundaries versus distribution-vendor maintenance models.
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — How enterprise Linux security teams verify CVE status without upstream version false positives.
- [Supply Chain and Advisory Feeds](supply-chain-and-advisories/) — SHA-256 today; published JSON feeds at `/advisories/` (CONFIG-gate SBOM, OSV with 279 entries, CycloneDX SBOM for `hs-v1.6.4-kernel-6.18.9`); roadmap for GPG/cosign signing and OVAL.

**Reading guide**: Several pages name Red Hat Enterprise Linux (RHEL), RHSA advisories, and OVAL feeds because procurement and vulnerability-management teams already know them. The same errata-first discipline applies on Rocky, AlmaLinux, Ubuntu LTS, Debian, and SUSE, and the [Distro Compatibility Matrix](distro-compatibility-matrix/) lists validated bases across both the RPM and Debian families.

## Evidence and technical reference

Every measured number derives from the open-source `kernel-hardening-checker` tool applied identically to HeartSuite and reference kernels, with no estimates. Raw evidence files and config SHA-256 hashes are included so any qualified team can verify independently.

- [Evidence Status](evidence-status/) — 6.18.9-hs #37 pack published 2026-08-18; 5.19.6 remains the legacy pack.
- [Comparison Matrix (6.18.9)](kernel-comparison-matrix-6.18.9/) — Scores are the 18 August 2026 measurement (build #37).
- [Comparison Matrix (5.19.6)](kernel-comparison-matrix-5.19.6/) — Legacy stream, fully measured: HeartSuite vs vanilla defconfig, Arch hardened, and KSPP target.
- [Threat model and residual risk](auditor-brief/) — Threat model for the kernel that ships, August #37 measured scores, residual risks, and reproduction commands.
- [LSM Comparison](lsm-comparison/) — HeartSuite vs SELinux, AppArmor, and TOMOYO: enforcement model, bypass-primitive resistance, and co-existence.
- [Analyst Summary](analyst-summary/) — Non-technical summary for journalists and analysts, with fact-checker citations.
