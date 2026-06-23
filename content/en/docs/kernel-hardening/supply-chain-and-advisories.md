---
title: "Supply Chain and Advisory Feeds"
linkTitle: "Supply Chain & Advisories"
weight: 14
description: "HeartSuite HS kernel supply-chain artefacts — SHA-256 bundle integrity, bundle manifest fields, reproducible config hashes, published machine-readable advisory feeds (CONFIG-gate SBOM, OSV, CycloneDX), and roadmap for GPG/cosign signing and OVAL."
categories: ["Reference"]
tags: ["kernel", "supply-chain", "sbom", "oval", "osv", "cosign", "gpg", "procurement", "compliance", "integrity"]
type: docs
toc: true
---

**Overview**: What supply-chain artefacts HeartSuite publishes today (SHA-256 bundle integrity, CONFIG-gate SBOM, OSV, CycloneDX) and what remains on the roadmap (GPG/cosign signing, OVAL).

**Audience**: Procurement, vendor risk, GRC, and platform security teams mapping HeartSuite deliverables to supply-chain questionnaires, SOC 2 / ISO evidence requests, and enterprise Linux vulnerability-management programs.

**Related reading**: [Kernel Support Policy](kernel-support-policy/), [Enterprise Adoption Guide](enterprise-adoption-guide/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/), [Evidence Status](evidence-status/), [Auditor Brief](auditor-brief/), [Updating HeartSuite](../../maintenance/updating-heartsuite/).

---

## What this page covers

This page states **what HeartSuite publishes today** for HS kernel supply-chain verification and **what is on the roadmap** — without overstating availability.

It is the single reference for:

- **Bundle integrity** — SHA-256 checksums now; GPG and cosign signing planned.
- **Bundle manifests** — version identifiers, addressed CVE list, and checksum references shipped with coordinated releases.
- **Reproducible configuration evidence** — published `.config` SHA-256 per supported HS kernel stream.
- **Machine-readable advisories** — Published JSON feeds under [`/advisories/`](/advisories/index.json) (catalogue: `hs-advisory-catalog/v1`). For the current release (`hs-v1.6.4-kernel-6.18.9`, `gate_status: PASS`): CONFIG-gate Not-Affected SBOM, OSV (279 entries at [`/advisories/osv.json`](/advisories/osv.json)), and CycloneDX bundle SBOM. **OVAL XML** for OpenSCAP remains on the roadmap.
- **SBOM** — CycloneDX bundle SBOM published at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json); SPDX dual-format support will be stated at GA.

For patch targets, notification channels, and support boundaries, see the [Kernel Support Policy](kernel-support-policy/). For fleet deployment and buyer-facing limitations, see the [Enterprise Adoption Guide](enterprise-adoption-guide/).

---

## Summary: today versus roadmap

| Artefact | Today | Roadmap status |
|---|---|---|
| **Installer bundle checksum** | Published `heartsuite-install.sh.sha256` (SHA-256) | GPG-signed checksum manifest; cosign signature on bundle (target: general availability — **no date committed**) |
| **Bundle manifest** | Version IDs, CVE list addressed in build, checksum reference | Same fields, plus signing key IDs and SBOM reference when SBOM ships |
| **Kernel `.config` hash** | SHA-256 published per stream on this site and in evidence packs | Continues per stream; referenced from published advisory feeds |
| **CONFIG-gate SBOM (JSON)** | Published at [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json) on each `hs-v*` release (schema `hs-cve-config-sbom/v1`) | Updated with coordinated bundles; gated by CVE↔CONFIG crosswalk in CI |
| **OSV (HS kernel)** | Published at [`/advisories/osv.json`](/advisories/osv.json) (279 entries; alias of `osv/all.json`) for `hs-v1.6.4-kernel-6.18.9` | Encodes config-gate and transparency-page reachability |
| **OVAL (HS kernel)** | **Not published** | Planned OpenSCAP definitions; use OSV/CONFIG SBOM and [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) until OVAL ships |
| **SBOM (CycloneDX)** | Published at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json) for `hs-v1.6.4-kernel-6.18.9` | SPDX dual-format at GA if offered |
| **RHSA-style errata IDs** | **Not offered** | Not planned — advisories remain bundle- and transparency-page-centric |
| **HS kernel source (GPL)** | On written request via [support@heartsecsuite.com](mailto:support@heartsecsuite.com) | Public kernel source repository not offered at this time |

HeartSuite does **not** commit to delivery dates for roadmap items on this page. When an artefact reaches general availability, this page and the [Kernel Support Policy](kernel-support-policy/) will be updated and customers will be notified through subscription email and release notes.

---

## What you can verify today

### Installer and bundle integrity (SHA-256)

Coordinated HeartSuite updates ship as a self-extracting **`heartsuite-install.sh`** bundle. Each distribution includes a companion **`heartsuite-install.sh.sha256`** file.

Before execution, verify integrity:

```bash
sha256sum -c heartsuite-install.sh.sha256
```

Expected output: `heartsuite-install.sh: OK`

This is the **only generally available cryptographic integrity check** for bundles today. It confirms the file you received matches the checksum HeartSuite published for that release. It does **not** by itself prove publisher identity — that is why GPG and cosign are on the roadmap (see below).

Full install procedure and maintenance-window context: [Updating HeartSuite](../../maintenance/updating-heartsuite/).

### Reproducible kernel configuration (SHA-256 per stream)

Every released HS kernel stream publishes the **SHA-256 hash of the exact kernel `.config`** used for that build. This hash is the anchor for independent hardening verification:

- Compare the published hash to the config on a running system: `sha256sum /boot/config-$(uname -r)`
- Re-run the open-source `kernel-hardening-checker` against that config to reproduce attack-surface and exploit-resistance scores (commands in the [Auditor Brief](auditor-brief/))
- Cross-check stream-specific raw output in `evidence-pack-*.txt` artefacts referenced from the comparison and auditor pages

Config hashes are **per stream** (for example, 6.18 primary LTS and legacy 5.19), not a single global value. Publication status per stream is tracked in [Evidence Status](evidence-status/).

This model is intentionally **reproducible on the customer side** — auditors do not need to trust opaque scoring claims if they verify the hash and re-run the checker.

### Kernel Security Transparency (CVE rationale)

Per-CVE status, config gates, and Score on HeartSuite are published on the [Kernel Security Transparency](../../security/) page. This is the authoritative **human-readable** advisory layer for the HS kernel.

Machine-readable mirrors:

| Feed | URL | Format |
|---|---|---|
| **Catalogue** | [`/advisories/index.json`](/advisories/index.json) | `hs-advisory-catalog/v1` — release tag, feed list, publication flags |
| **CONFIG-gate SBOM** | [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json) | `hs-cve-config-sbom/v1` — validated `CONFIG_*` not-set claims per CVE group |
| **OSV** | [`/advisories/osv.json`](/advisories/osv.json) | OSV — 279 entries for `hs-v1.6.4-kernel-6.18.9` (alias of `osv/all.json`) |
| **CycloneDX SBOM** | [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json) | CycloneDX-1.5 coordinated bundle SBOM |

Feeds are published on this documentation site when HeartSuite cuts an annotated `hs-v*` kernel release. Publication is automated from HeartSuite's internal release pipeline; customers do not need access to private build repositories to consume the feeds.

### HS kernel source code (GPL)

HeartSuite distributes the HS kernel as binaries in the coordinated `heartsuite-install.sh` bundle. Portions of the HS kernel are subject to the GNU General Public License.

HeartSuite does **not** maintain a public kernel source repository at this time. **Corresponding source code** for the HS kernel build you are running is available on **written request** under GPL obligations.

Email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) and include:

- Output of `uname -r` (for example, `6.18.9-HeartSuite-1.0`)
- HeartSuite product version (for example, v1.6.4)
- Release tag or `heartsuite-install.sh.sha256` reference if known

HeartSuite will provide source matching that build. Independent verification of kernel configuration does **not** require source access — use the published `.config` SHA-256 and reproduction steps in the [Auditor Brief](auditor-brief/).

### Subscription notification

Security advisories, bundle availability, and stream-deprecation notices go to contacts registered on the subscription (email), supplemented by release notes on this site. See [Customer notification](kernel-support-policy/#customer-notification) in the Kernel Support Policy.

---

## Bundle manifest

Each coordinated release is accompanied by a **bundle manifest** (shipped with the bundle or referenced in release documentation). Manifests are the release-level changelog for procurement and vulnerability-management traceability.

### Published fields (today)

| Field | Purpose | Example / notes |
|---|---|---|
| **HeartSuite product version** | Identifies the coordinated stack release | For example, HeartSuite v1.6.4 |
| **HS kernel version string** | Running kernel identity after install | For example, `6.18.9-HeartSuite-1.0` — see [version-string anatomy](kernel-support-policy/#hs-kernel-version-string-anatomy) |
| **Stream** | Supported LTS line | `6.18` (primary) or `5.19` (legacy) |
| **Bundle checksum** | SHA-256 of `heartsuite-install.sh` | Must match `heartsuite-install.sh.sha256` |
| **Config SHA-256** | Hash of the kernel `.config` for this build | Links reproducible verification to this release |
| **CVE list addressed** | CVE identifiers remediated or reclassified in this bundle | Not an exhaustive fleet CVE report — only items **changed** in this build |
| **Release date** | Publication date of the bundle | For change-control and audit timelines |
| **Distribution targets** | Validated distro families for this bundle | See [Distro Compatibility Matrix](distro-compatibility-matrix/) |

Manifests do **not** replace the [Kernel Security Transparency](../../security/) page for reachability analysis. A CVE omitted from the "addressed" list may still be **Not Affected** on HS kernels because the vulnerable subsystem was never compiled in.

### Planned manifest extensions

When signing and SBOM artefacts ship, manifests will add **non-breaking** references:

- GPG key fingerprint and signature file location
- Cosign bundle signature digest (OCI/sigstore-style provenance)
- SBOM document URI and format (`SPDX` or `CycloneDX`)

Existing SHA-256 verification remains valid for customers who have not yet adopted the new artefacts.

---

## Roadmap: GPG and cosign signed bundles

**Today**: Integrity is **SHA-256 only** — detect accidental corruption or tampering in transit if you verify against the published checksum before execution.

**Planned**:

| Mechanism | Intended role |
|---|---|
| **GPG signatures** | Prove the checksum manifest and release metadata were issued by HeartSuite's signing key; support `gpg --verify` in install pipelines |
| **Cosign (or equivalent OCI signing)** | Attach signatures to bundle artefacts for CI/CD and image pipelines that already consume sigstore-compatible provenance |

**What HeartSuite is not claiming yet**:

- No published GPG public key or cosign policy on this site today.
- No requirement that customers use signing before install — SHA-256 verification remains the baseline until signing is generally available.
- Signing addresses **publisher authenticity** and **pipeline integration**; it does not change the HS kernel's CVE reachability model or Lockdown semantics.

Teams with mandatory code-signing policies should treat SHA-256 + config-hash verification as the current interim control and engage HeartSuite support for questionnaire language until GPG/cosign GA.

---

## Published advisory feeds (HS kernel)

Enterprise Linux teams often use **OVAL** definitions with OpenSCAP, or **OSV** entries in broader SCA tooling, to reduce false positives from raw NVD version matching.

**Published today** (JSON under `/advisories/`, absolute base `https://docs.heartsecsuite.com/advisories/`):

For release tag **`hs-v1.6.4-kernel-6.18.9`** (`gate_status: PASS` in the catalogue):

- **`index.json`** — Feed catalogue (`hs-advisory-catalog/v1`) with release tag, HeartSuite version, kernel base, and per-feed `published` flags.
- **`hs-cve-config-sbom.json`** — CONFIG-gate Not-Affected manifest (`hs-cve-config-sbom/v1`) produced by the CVE↔CONFIG crosswalk gate in Core Secure CI.
- **`osv.json`** — 279 OSV entries derived from the CONFIG SBOM and transparency page (alias of `osv/all.json`).
- **`sbom.cyclonedx.json`** — CycloneDX bill of materials for the coordinated bundle.

**Not yet published**: **OVAL XML** for OpenSCAP. Teams that require OVAL today should ingest the published CONFIG SBOM and OSV feeds, plus the manual workflow in [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

Scanners that compare `uname -r` to upstream "fixed in" versions will still generate noise on HS kernel boots until your toolchain consumes these feeds or the manual hygiene workflow.

### What the feeds encode

The feeds encode logic that version strings alone cannot express:

| Data element | Purpose |
|---|---|
| **Product / stream scope** | Distinguish HS kernel (`HeartSuite` in `uname -r`) from distribution maintenance-kernel boots on the same host |
| **Config gates** | Map CVEs to `CONFIG_*` options — **Not Affected** when subsystem is compiled out |
| **Score on HeartSuite** | Environmental applicability (including 0.0 neutralisation) |
| **Reachable / bounded** | Flag CVEs where code path exists and Lockdown bounds post-exploitation |
| **Fixed-in-bundle boundaries** | Tie remediation to HeartSuite build release and bundle manifest CVE list |
| **Config SHA-256 reference** | Anchor feed evaluations to the published `.config` hash for the stream |

The feeds **do not** replicate RHSA numbering or distribution errata semantics. HeartSuite remediation is expressed through **coordinated bundles** and transparency documentation, not per-CVE RPM errata on the HS binary.

### Automation workflow

1. Pull the catalogue: `curl -fsS https://docs.heartsecsuite.com/advisories/index.json`
2. Ingest `hs-cve-config-sbom.json` and `osv.json` into your vulnerability-management platform.
3. For CVEs not covered by machine-readable entries, use **[CVE Hygiene for Scanners](cve-hygiene-for-scanners/)**:
   - Confirm boot context (`HeartSuite` in `uname -r` vs maintenance kernel).
   - Look up the CVE on [Kernel Security Transparency](../../security/).
   - Verify config gates with `grep CONFIG_* /boot/config-$(uname -r)`.
   - Record false positives in your scanner exception register with transparency links.

Continue using **distribution OVAL/errata** for Non-HS kernel maintenance windows and for non-kernel packages.

OVAL XML general availability will be announced in release notes when ready.

---

## SBOM (CycloneDX published; SPDX at GA)

**Published**: CycloneDX bundle SBOM at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json) for `hs-v1.6.4-kernel-6.18.9` (`published: true` on the cyclonedx-sbom entry in [`/advisories/index.json`](/advisories/index.json)).

**Scope** (CycloneDX generator):

- Coordinated bundle contents — HS kernel binary, userspace daemon/Dashboard/tools, and installer dependencies relevant to the enforcement stack.
- **Linkage**: Bundle manifest references the SBOM URL; catalogue records release tag and HeartSuite version.

**Roadmap**: SPDX and/or dual SPDX+CycloneDX support will be stated at GA if offered.

**Complementary artefacts** (always available):

- Published kernel `.config` SHA-256 and `evidence-pack-*.txt` for reproducible hardening measurement (5.19.6 published; 6.18.9 in progress — see [Evidence Status](evidence-status/))
- CONFIG-gate SBOM at [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json)
- Bundle SHA-256 manifests
- CVE transparency and bundle manifest CVE lists

SBOM publication improves **dependency inventory and procurement automation**; it does not replace config-gate CVE analysis for the HS kernel.

---

## Mapping to common procurement questions

| Question | Honest answer | Primary reference |
|---|---|---|
| How do we verify the installer was not corrupted? | `sha256sum -c heartsuite-install.sh.sha256` before execution | This page; [Updating HeartSuite](../../maintenance/updating-heartsuite/) |
| How do we prove signing authority? | **Not yet** — GPG/cosign roadmap | Roadmap section above |
| How do we automate CVE false-positive reduction for the HS kernel? | Ingest published [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json) and [`/advisories/osv.json`](/advisories/osv.json) (279 entries); manual workflow for gaps | [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) |
| Where is the SBOM? | CycloneDX at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json) | This page |
| What identifies a release for audit? | Bundle manifest + `uname -r` + config SHA-256 | [Kernel Support Policy](kernel-support-policy/) |
| Do you publish RHSA-style errata? | **No** | [Kernel Support Policy](kernel-support-policy/#patch-commitment-tiers) |

---

## What HeartSuite does not provide (supply-chain scope)

To set expectations for RFPs and vendor-risk assessments:

| Capability | Status |
|---|---|
| GPG-signed bundles (GA) | Roadmap — SHA-256 only today |
| Cosign / sigstore bundle signatures (GA) | Roadmap |
| OVAL definitions for HS kernel (GA) | Planned — not published |
| OSV entries for HS kernel | Published at [`/advisories/osv.json`](/advisories/osv.json) — 279 entries for `hs-v1.6.4-kernel-6.18.9` |
| CONFIG-gate Not-Affected SBOM | Published at [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json) on `hs-v*` releases |
| CycloneDX SBOM on docs site | Published at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json) for `hs-v1.6.4-kernel-6.18.9` |
| SPDX SBOM (GA) | Roadmap — CycloneDX is the published machine-readable format today |
| RHSA-equivalent advisory numbering | Not planned |
| kpatch/live-patch provenance | Not applicable — live patching not offered on HS kernel |

If a control framework **requires** GA OVAL feeds or GPG/cosign signing before production approval, plan for the interim artefacts in this document and document compensating controls (published JSON feeds, manual CVE hygiene, config-hash verification, bundle manifest retention) until roadmap items ship.

---

## Related reading

- [Kernel Support Policy](kernel-support-policy/) — Patch targets, bundle delivery, notification, version strings, and "does not provide" boundaries.
- [Evidence Status](evidence-status/) — 5.19.6 vs 6.18.9 publication status.
- [Enterprise Adoption Guide](enterprise-adoption-guide/) — Fleet operations, supply-chain summary, Secure Boot status, and honest limitations.
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — HS kernel CVE verification; ingest published OSV/CONFIG SBOM feeds; OVAL interim workflow.
- [Auditor Brief](auditor-brief/) — Threat model, reproduction commands, evidence packs.
- [Distro Compatibility Matrix](distro-compatibility-matrix/) — Stream and distribution validation.
- [Kernel Security Transparency](../../security/) — Per-CVE status and config gates.
- [Updating HeartSuite](../../maintenance/updating-heartsuite/) — Bundle verification and two-reboot update path.

---

*This page is procurement- and GRC-facing. Availability statements reflect public deliverables as of the last-updated date; roadmap items have no committed GA dates unless separately agreed in writing. Last updated: 2026-06-23.*
