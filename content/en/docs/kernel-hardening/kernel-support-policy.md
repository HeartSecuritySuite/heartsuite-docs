---
title: "Kernel Support Policy"
linkTitle: "Kernel Support Policy"
weight: 10
description: "HeartSuite kernel support policy for HS kernel streams, LTS strategy, patch targets, update delivery, version-string semantics, 5.19 deprecation, and boundaries versus distribution-vendor maintenance models."
categories: ["Reference"]
tags: ["kernel", "support", "patching", "lifecycle", "enterprise", "rhel"]
type: docs
toc: true
---

**Overview**: How HeartSuite maintains, patches, and delivers the HS kernel under subscription — LTS strategy, coordinated update bundles, and how that differs from distribution-vendor errata programs such as RHEL.

**Audience**: Procurement, risk, compliance, and platform teams evaluating Root Lock by HeartSuite kernel maintenance alongside existing distribution patching programs.

**Related reading**: [Enterprise Adoption Guide](enterprise-adoption-guide/), [Updating HeartSuite](../../maintenance/updating-heartsuite/), [Kernel Security Transparency](../../security/), [Distro Compatibility Matrix](distro-compatibility-matrix/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

---

## What this policy covers

This policy describes how HeartSuite supports the **HS kernel** — the custom-built Linux kernel that Root Lock by HeartSuite requires for Lockdown enforcement — under a commercial **subscription**.

It applies to:

- **HS kernel streams** currently shipped and supported:
  - **6.18** — primary LTS stream and commercial baseline (HeartSuite v1.6.4 ships kernel **6.18.9**).
  - **5.19** — legacy stream for existing deployments; no longer the default for new installations.
- **Coordinated update bundles** that deliver the HS kernel together with matching userspace components (Dashboard, daemon, tools, and installer). Kernel changes are not published or supported as standalone kernel-only packages outside these bundles.
- **Integration with subscription terms** — patch targets, notification channels, and binding service-level commitments appear in your subscription agreement. This page states public targets and operational boundaries so buyers can align internal change-control and vulnerability-management programs before contract signature.

> **Note**: This policy does not replace the subscription agreement. Where this page and your agreement differ, the agreement controls.

---

## LTS-only strategy

HeartSuite commits to **mainline LTS kernel bases only** — not arbitrary upstream version chasing and not long-lived forks of non-LTS releases.

**Why LTS-only**

- LTS branches receive upstream security and stability maintenance for a defined period, which gives HeartSuite a predictable rebuild base.
- HeartSuite's security model depends on a **fixed, published kernel configuration** (compiled-out subsystems, enforcement hooks, and Lockdown integration). Rebuilding on a known LTS tag preserves that contract while absorbing upstream fixes that apply to the compiled-in code paths.
- Chasing every upstream minor release would multiply validation cost without improving the enforcement properties buyers adopt Root Lock by HeartSuite for.

**Commercial baseline**

- New subscriptions and new fleet images should standardize on the **6.18** stream.
- HeartSuite v1.6.4 (April 2026) established **6.18.9** as the commercial release baseline for multi-distribution support.

When HeartSuite advances the LTS base (for example, a future move within the 6.18 LTS line or to a subsequent LTS series), customers receive advance notice and migration bundles as described under [Customer notification](#customer-notification) and [5.19 stream deprecation](#519-stream-deprecation).

---

## How HeartSuite differs from the distribution-vendor model

Enterprise Linux distributions such as RHEL follow a **frozen-base, backport-within-base** model: the upstream kernel version number visible in `uname` stays on a vendor branch for years, while individual CVE fixes are cherry-picked onto that branch. Vendor errata, advisory identifiers, and scanner feeds are built around that model.

HeartSuite follows a **different model**, aligned with how Root Lock by HeartSuite is built and validated:

| Aspect | Typical frozen-base distribution (RHEL-style) | HeartSuite HS kernel |
|---|---|---|
| Version identity | Long-lived vendor branch (for example, 5.14 on RHEL 9) with backported patches | Rebuild on an **LTS upstream tag** with a **HeartSuite-specific configuration** |
| CVE remediation | Backport upstream fix patches onto frozen base; errata per advisory | **Rebuild** on updated LTS within the stream; **structural neutralization** where vulnerable code is compiled out; **Lockdown bounds** where paths remain reachable |
| Live patching | kpatch or equivalent may be offered for subset of CVEs | **Not offered** — see [What HeartSuite does not provide](#what-heartsuite-does-not-provide) |
| Third-party kernel modules | kABI / stable module interface across minor updates | **Not a design goal** on the HS kernel — enforcement architecture intentionally diverges from general-purpose distro kernels |
| Delivery unit | Distribution package manager and errata channels | **Coordinated `heartsuite-install.sh` bundle** with userspace stack |

HeartSuite is honest about the trade-off: the HS kernel is **not** a drop-in substitute for a distribution kernel in every operational sense. It **is** the enforcement kernel for Lockdown. The distribution **Non-HS kernel** remains on the system for maintenance and recovery; distribution errata still apply to packages and to the Non-HS kernel path.

For deployment implications, coexistence with distribution maintenance, and fleet patterns, see the [Enterprise Adoption Guide](enterprise-adoption-guide/).

---

## HS kernel version string anatomy

The running kernel version is shown by `uname -r`. On an HS deployment, the string identifies the HeartSuite build, not a distribution errata package.

**Example**: `6.18.9-HeartSuite-1.0`

| Component | Value | Meaning |
|---|---|---|
| Upstream LTS base | `6.18.9` | The mainline LTS kernel version HeartSuite built from for this release. This is the upstream tag lineage, not a count of every upstream commit merged since a prior HeartSuite build. |
| Vendor segment | `HeartSuite` | Identifies the binary as an HS kernel built and supported by HeartSuite, distinct from the distribution kernel packages on the same host. |
| HeartSuite build release | `1.0` | HeartSuite's patch/release ordinal for this upstream base — increments when HeartSuite ships a new rebuild or bundle for the same LTS line (security rebuilds, coordinated stack updates). |

Legacy 5.19 deployments follow the same pattern (for example, `5.19.6-HeartSuite-<release>`).

### What the version string does **not** mean

Procurement and scanner teams trained on distribution errata often misread custom kernel strings. The HS kernel version string **does not** imply:

- **Full upstream parity** — The string does not assert that every fix present in a newer upstream kernel is backported. HeartSuite rebuilds on the LTS base with the published HeartSuite configuration; fixes apply to **compiled-in** paths or are addressed through structural absence and Lockdown bounds as documented on the [Kernel Security Transparency](../../security/) page.
- **Distribution errata equivalence** — A match against a distribution CVE feed or `rpm -q kernel` version is not valid for the HS kernel. The HS kernel is not the distribution enforcement kernel.
- **Scanner "fixed in version" logic** — Vulnerability scanners that compare `uname -r` to NVD "fixed version" thresholds will produce false positives for HS kernels. Use HeartSuite's per-CVE status and [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) guidance instead of raw version-string matching.
- **kABI or DKMS compatibility** — The string does not promise binary compatibility with out-of-tree kernel modules built for the distribution kernel or for prior HS builds.
- **Live-patch level** — There is no parallel "kpatch level" or running-patch suffix; updates require a coordinated bundle and reboot path.
- **Secure Boot readiness** — Version format does not indicate UEFI Secure Boot signing status for the HS kernel entry. Secure Boot support for the HS kernel remains incomplete; see the [Enterprise Adoption Guide](enterprise-adoption-guide/#secure-boot-firmware-compatibility-and-roadmap) for current status.

For independent verification of what **is** in the build, HeartSuite publishes the kernel `.config` SHA-256 and evidence packs for each supported stream.

---

## Update delivery

HS kernel updates are delivered only as part of **coordinated HeartSuite release bundles**.

### Bundle format and integrity

- Updates ship as a self-extracting **`heartsuite-install.sh`** bundle with a published **`heartsuite-install.sh.sha256`** checksum file.
- Before execution, verify integrity:

  ```bash
  sha256sum -c heartsuite-install.sh.sha256
  ```

  Expected output: `heartsuite-install.sh: OK`

- Each bundle updates the HS kernel (`vmlinuz-<version>-HeartSuite-<release>`), userspace tools, Dashboard files, and GRUB defaults together so the enforcement stack stays paired and tested.

### Applying an update

The running HS kernel cannot replace itself. Updates use the documented **two-reboot Non-HS path**:

1. Reboot from the HS kernel to the **Non-HS kernel** (distribution maintenance kernel).
2. Run `bash heartsuite-install.sh` on the Non-HS kernel.
3. Reboot into the new HS kernel and complete any post-install review the Dashboard indicates.

Root Lock by HeartSuite is **not** active on the Non-HS kernel. Schedule updates in a planned maintenance window. If Lockdown is engaged, disengage through the Dashboard's Maintenance (`[m]`) before updating.

Full step-by-step procedures, failure recovery, and Lockdown considerations are in [Updating HeartSuite](../../maintenance/updating-heartsuite/).

### Golden image alternative

Teams that provision from images may **reprovision from an updated golden image** instead of in-place bundle application. This is equivalent from a support perspective when the image contains a bundle version HeartSuite has published for that stream. Image pipelines should pin bundle version, checksum, and HS kernel string in build metadata for audit traceability.

---

## Patch commitment tiers

HeartSuite classifies kernel-related security work using the reachability model on the [Kernel Security Transparency](../../security/) page. The tables below are **public targets** for coordinated bundle delivery. **Binding SLAs** — including business-day definitions, escalation, and credit terms — are set in your **subscription agreement**.

Clock start for timed tiers: **HeartSuite confirmation** that the issue applies to the supported HS kernel stream (reachable path or required rebuild), based on upstream vendor/public confirmation and HeartSuite analysis.

| Tier | Criteria | Target delivery |
|---|---|---|
| **Critical** | Actively exploited in the wild **or** remote unauthenticated RCE on a **reachable** HS kernel path (compiled in, triggerable on a supported deployment profile) | **15 business days** from HeartSuite confirmation |
| **Important** | Reachable HS path, **no** known active exploitation | **30 business days** from HeartSuite confirmation |
| **Moderate / Low (reachable)** | Reachable but lower practical impact on standard server profiles; Lockdown may bound post-exploitation | **Next scheduled coordinated bundle** |
| **Not Affected** | Vulnerable subsystem **compiled out** or path documented as unreachable on HS; Score on HeartSuite **0.0** | **No patch required** — status documented on the CVE page; bundle may still ship for other reasons |

**Notes**

- Many high-severity CVEs are **Not Affected** on HS kernels because the attack surface was never compiled in. Those entries do not consume patch-tier clocks.
- For reachable CVEs, Lockdown limits persistence and arbitrary code execution even before a rebuild ships; patching remains part of defense-in-depth and subscription commitments for reachable paths.
- HeartSuite does **not** commit to per-CVE errata identifiers in the distribution-vendor style. Bundle manifests list addressed CVEs for the release.

---

## Customer notification

HeartSuite notifies subscription customers through the following channels:

| Channel | Content |
|---|---|
| **Email** | Sent to contacts registered on the subscription (security advisories, bundle availability, stream-deprecation notices). Ensure procurement keeps technical and security distribution lists current with HeartSuite. |
| **Release notes** | Published on this documentation site with each coordinated release — summary of kernel stream, version string, and notable CVE or configuration changes. |
| **Bundle manifest** | Shipped with or referenced by the bundle — includes version identifiers, checksum, and the CVE list addressed in that build. |
| **Machine-readable feeds** | JSON advisory artefacts under [`/advisories/`](/advisories/index.json) — CONFIG-gate SBOM, OSV (279 entries), and CycloneDX SBOM published for `hs-v1.6.4-kernel-6.18.9` (`gate_status: PASS`). Catalogue schema: `hs-advisory-catalog/v1`. Detail: [Supply Chain and Advisory Feeds](supply-chain-and-advisories/#published-advisory-feeds-hs-kernel). |

**Major stream deprecation**: HeartSuite provides **at least 30 days' advance notice** before ending support for an HS kernel stream (for example, end of 5.19 support). Notice includes migration bundle availability and recommended maintenance windows.

Machine-readable advisory feeds are **published** as JSON under [`/advisories/`](/advisories/index.json) on each annotated `hs-v*` release tag. For the current release (`hs-v1.6.4-kernel-6.18.9`, `gate_status: PASS`): CONFIG-gate Not-Affected SBOM at [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json), OSV at [`/advisories/osv.json`](/advisories/osv.json) (279 entries), and CycloneDX SBOM at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json). **OVAL XML** for OpenSCAP is not yet published — use the JSON feeds, CVE transparency page, bundle manifests, and email advisories as authoritative sources. Feed URLs and schemas: [Supply Chain and Advisory Feeds](supply-chain-and-advisories/#published-advisory-feeds-hs-kernel).

---

## 5.19 stream deprecation

The upstream **5.19** branch is **end-of-life**. HeartSuite no longer recommends 5.19 for new deployments or new golden images.

**Support window for existing deployments**

- HeartSuite continues to ship **5.19 migration and security bundles** for deployments already on the 5.19 HS stream **through end of calendar year 2026**, subject to subscription status.
- After that date, 5.19 HS kernel support ends unless extended terms are agreed in writing. Engage HeartSuite support before the cutoff to plan fleet migration.

**Migration path**

1. Schedule maintenance using the [Updating HeartSuite](../../maintenance/updating-heartsuite/) two-reboot path (or reprovision from a 6.18 golden image).
2. Apply the published **5.19 → 6.18 migration bundle** for your distribution and HeartSuite version.
3. Reboot into the 6.18 HS kernel, review Dashboard queues for any new program activity, and re-engage Lockdown if required.
4. Update vulnerability-management and configuration baselines to reference the new version string and published 6.18 config hash.

Functional differences between streams (configuration, module footprint, CVE tables) are summarized in the [Distro Compatibility Matrix](distro-compatibility-matrix/) and stream-specific evidence materials.

---

## Support boundaries

### Subscription scope

- The HS kernel is **included in the Root Lock by HeartSuite subscription**. There is **no separate kernel-only support contract**.
- Incidents, rebuild requests, deployment guidance, and coordinated updates for kernel behaviour are handled under the same subscription that enables Lockdown.
- Verification artifacts (config SHA-256, evidence packs, CVE transparency data, bundle checksums) are provided as part of the product documentation and subscription deliverables.

### Coexistence with distribution subscriptions

On a host running Root Lock by HeartSuite:

| Kernel | Role | Patching |
|---|---|---|
| **HS kernel** | Enforcement kernel for Setup Mode and Lockdown | **HeartSuite coordinated bundles only** |
| **Non-HS kernel** | Maintenance, recovery, and distribution-compatible work | **Distribution errata and package updates** apply as usual |

Root Lock by HeartSuite **replaces the enforcement kernel** for protected operation; it does **not** remove the distribution kernel or cancel distribution maintenance obligations on the Non-HS path. During maintenance on the Non-HS kernel, the host behaves as a standard distribution system without Lockdown enforcement.

Distribution-vendor subscriptions (RHEL, SLES, Ubuntu Pro, and similar extended-support offerings) and third-party agents that require the distribution kernel for full functionality continue to apply to the Non-HS maintenance path and to userspace packages. Agents or tools that require BPF, specific kernel modules, or kernel interfaces absent from the HS kernel must run on the Non-HS kernel or on a separate host — see the [Enterprise Adoption Guide](enterprise-adoption-guide/) compatibility section.

---

## What HeartSuite does not provide

HeartSuite does **not** offer the following on the HS kernel path:

| Capability | HeartSuite position |
|---|---|
| **kpatch / live kernel patching** | Not supported. Kernel changes require reboot through the coordinated bundle path (or image reprovision). |
| **Arbitrary DKMS or kABI-stable third-party modules** | Not supported as a compatibility guarantee. The HS kernel configuration diverges deliberately from distribution kernels; out-of-tree modules built for distro kernels are not expected to load. |
| **Upstream version chasing** | HeartSuite does not track every mainline release. Only supported **LTS streams** listed in this policy receive builds. |
| **Distribution-style per-CVE errata packages** | CVE remediation is expressed through HeartSuite bundles and transparency documentation, not separate `kernel-` RPM/DEB errata tied to the HS binary. |
| **JSON advisory feeds (CONFIG SBOM / OSV / CycloneDX)** | Published at [`/advisories/`](/advisories/index.json) on `hs-v*` releases — see [Supply Chain and Advisory Feeds](supply-chain-and-advisories/). |
| **OVAL feeds (OpenSCAP)** | Planned; not yet published. |
| **Complete Secure Boot for HS kernel entries** | Incomplete; orthogonal to Lockdown enforcement but relevant to boot-integrity policies — see [Enterprise Adoption Guide](enterprise-adoption-guide/). |

If a workload **requires** live patching, vendor-certified unchanged distribution kernels, or broad third-party kernel module support as non-negotiable constraints, evaluate the Non-HS path, HJFS on a standard kernel, or layered controls described in the Enterprise Adoption Guide rather than the HS kernel.

---

## Related reading

- [Enterprise Adoption Guide](enterprise-adoption-guide/) — Deployment, fleet operations, Secure Boot status, risk ownership, and compatibility decision tree.
- [Updating HeartSuite](../../maintenance/updating-heartsuite/) — Bundle verification, two-reboot procedure, and recovery.
- [Kernel Security Transparency](../../security/) — Per-CVE status, Not Affected rationale, and Score on HeartSuite.
- [Distro Compatibility Matrix](distro-compatibility-matrix/) — Supported distributions, kernel streams, and coexistence notes.
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — Resolving scanner false positives against HS version strings.
- [Supply Chain and Advisory Feeds](supply-chain-and-advisories/) — Published CONFIG SBOM, OSV, and CycloneDX feeds; GPG/cosign and OVAL roadmap.
- [Evidence Status](evidence-status/) — Per-stream config hash and checker publication status.

---

*This page is procurement- and operations-facing. Patch targets are goals for planning; binding commitments are in your subscription agreement. Last updated: 2026-06-23.*
