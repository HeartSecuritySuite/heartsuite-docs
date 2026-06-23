---
title: "Kernel Hardening"
weight: 108
description: "Objective, measurement-backed analysis of Root Lock by HeartSuite's kernel hardening posture — design rationale, comparison against industry references, and reproducible evidence."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison"]
type: docs
toc: false
---

**Overview**: Root Lock by HeartSuite runs custom-built Linux kernels (5.19 legacy and 6.18 primary LTS) that remove the subsystems attackers use to bypass security controls, rather than patching around them. This section covers buyer evaluation, support policy, compatibility, scanner hygiene, and reproducible evidence.

## For buyers and procurement

Start here if you are evaluating the HS kernel for a regulated or enterprise fleet:

- [Procurement Brief](procurement-brief/) — Comparison table and decision guide at a glance.
- [Enterprise Adoption Guide](enterprise-adoption-guide/) — CISO and procurement guidance: deployment, fleet operations, Secure Boot status, supply chain, recovery, and honest limitations.
- [Distro Compatibility Matrix](distro-compatibility-matrix/) — Validated and supported distributions, RHEL-family guidance, workload fit, and HJFS alternative.
- [Kernel Support Policy](kernel-support-policy/) — LTS strategy, patch targets, update delivery, version-string semantics, and boundaries versus distribution-vendor maintenance models.
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — How enterprise Linux security teams verify CVE status without upstream version false positives.
- [Supply Chain and Advisory Feeds](supply-chain-and-advisories/) — SHA-256 today; published JSON feeds at `/advisories/` (CONFIG-gate SBOM, OSV with 279 entries, CycloneDX SBOM for `hs-v1.6.4-kernel-6.18.9`); roadmap for GPG/cosign signing and OVAL.

**Reading guide**: Several pages name Red Hat Enterprise Linux (RHEL), RHSA advisories, and OVAL feeds as **familiar anchors** for procurement and vulnerability-management teams — the same errata-first discipline applies on Rocky, AlmaLinux, Ubuntu LTS, Debian, and SUSE. HeartSuite is not a RHEL-only product; the [Distro Compatibility Matrix](distro-compatibility-matrix/) lists validated bases across RPM and Debian families.

## Evidence and technical reference

Every measured number derives from the open-source `kernel-hardening-checker` tool applied identically to HeartSuite and reference kernels. No estimates. Raw evidence files and config SHA-256 hashes are included so any qualified team can verify independently.

- [Evidence Status](evidence-status/) — 5.19.6 published vs 6.18.9 commercial baseline (in progress).
- [Comparison Matrix (6.18.9)](kernel-comparison-matrix-6.18.9/) — Primary stream structure; measured scores pending publication.
- [Comparison Matrix (5.19.6)](kernel-comparison-matrix-5.19.6/) — Legacy stream, fully measured: HeartSuite vs vanilla defconfig, Arch hardened, and KSPP target.
- [Auditor Brief](auditor-brief/) — Threat model, measured strengths and gaps, residual risks, and self-reproduction commands for security auditors and red teams.
- [LSM Comparison](lsm-comparison/) — HeartSuite vs SELinux, AppArmor, and TOMOYO: enforcement model, bypass-primitive resistance, and co-existence.
- [Analyst Summary](analyst-summary/) — Non-technical summary for journalists and analysts, with fact-checker citations.