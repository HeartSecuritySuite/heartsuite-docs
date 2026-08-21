---
title: "How long each Root Lock kernel is maintained"
linkTitle: "Kernel Support Policy"
weight: 10
description: "LTS streams, patch targets, 5.19 deprecation, and how Root Lock kernel maintenance differs from a distro vendor's model."
categories: ["Reference"]
tags: ["kernel", "support", "patching", "lifecycle", "enterprise", "rhel"]
type: docs
toc: true
---

**Overview**: How HeartSuite maintains, patches, and delivers the Root Lock kernel under subscription — LTS strategy, coordinated update bundles, and how that differs from distribution-vendor errata programs such as RHEL.

**Audience**: Procurement, risk, compliance, and platform teams evaluating Root Lock kernel maintenance alongside existing distribution patching programs.

**Related reading**: [Enterprise Adoption Guide](enterprise-adoption-guide/), [Updating Root Lock](../../maintenance/updating-heartsuite/), [Kernel Security Transparency](../../security/), [Distro Compatibility Matrix](distro-compatibility-matrix/), [CVE Hygiene for Scanners](cve-hygiene-for-scanners/).

---

## What this policy covers

This policy describes how HeartSuite supports the **Root Lock kernel** — the custom-built Linux kernel that Root Lock by HeartSuite requires for Lockdown enforcement — under a commercial **subscription**.

It applies to:

- **Root Lock kernel streams** currently shipped and supported:
  - **6.18** — primary LTS stream and commercial baseline (HeartSuite v1.6.4 ships kernel **6.18.9**).
  - **5.19** — legacy stream for existing deployments; no longer the default for new installations.
- **Coordinated update bundles** that deliver the Root Lock kernel together with matching userspace components (Dashboard, daemon, tools, and installer). Kernel changes are not published or supported as standalone kernel-only packages outside these bundles.
- **Integration with subscription terms** — patch targets, notification channels, and binding service-level commitments appear in your subscription agreement. This page states public targets and operational boundaries so buyers can align internal change-control and vulnerability-management programs before contract signature.

> **Note**: This policy does not replace the subscription agreement. Where this page and your agreement differ, the agreement controls.

---

## LTS-only strategy

HeartSuite's **current** commercial baseline is a **mainline LTS** kernel (6.18). New streams are LTS bases — not arbitrary upstream version chasing.

The **5.19** stream is a legacy exception: 5.19 was a short-lived mainline release. It remains in this policy only for existing deployments until the deprecation window closes.

**Why LTS-only**

- LTS branches receive upstream security and stability maintenance for a defined period, which gives HeartSuite a predictable rebuild base.
- HeartSuite's security model depends on a **fixed, published kernel configuration** (compiled-out subsystems, enforcement hooks, and Lockdown integration). Rebuilding on a known LTS tag preserves that contract while absorbing upstream fixes that apply to the compiled-in code paths.
- Chasing every upstream minor release would multiply validation cost without improving the enforcement properties buyers adopt Root Lock for.

**Commercial baseline**

- New subscriptions and new fleet images should standardize on the **6.18** stream.
- HeartSuite v1.6.4 (April 2026) established **6.18.9** as the commercial release baseline for multi-distribution support.

When HeartSuite advances the LTS base (for example, a future move within the 6.18 LTS line or to a subsequent LTS series), customers receive advance notice and migration bundles as described under [Customer notification](#customer-notification) and [5.19 stream deprecation](#519-stream-deprecation).

---

## How HeartSuite differs from the distribution-vendor model

Enterprise Linux distributions such as RHEL follow a **frozen-base, backport-within-base** model. The upstream kernel version number visible in `uname` stays on a vendor branch for years, while individual CVE fixes are cherry-picked onto that branch. Vendor errata, advisory identifiers, and scanner feeds are built around that model.

HeartSuite follows a **different model**, aligned with how Root Lock is built and validated:

| Aspect | Typical frozen-base distribution (RHEL-style) | Root Lock kernel |
|---|---|---|
| Version identity | Long-lived vendor branch (for example, 5.14 on RHEL 9) with backported patches | Rebuild on an **LTS upstream tag** with a **HeartSuite-specific configuration** |
| CVE remediation | Backport upstream fix patches onto frozen base; errata per advisory | **Rebuild** on updated LTS within the stream; **structural neutralization** where vulnerable code is compiled out; **Lockdown bounds** where paths remain reachable |
| Live patching | kpatch or equivalent may be offered for subset of CVEs | **Not offered** — see [What Root Lock does not provide](#what-root-lock-does-not-provide) |
| Third-party kernel modules | kABI / stable module interface across minor updates | **Not a design goal** on the Root Lock kernel — enforcement architecture intentionally diverges from general-purpose distro kernels |
| Delivery unit | Distribution package manager and errata channels | **Coordinated `heartsuite-install.sh` bundle** with userspace stack |

HeartSuite is honest about the trade-off: the Root Lock kernel is **not** a drop-in substitute for a distribution kernel in every operational sense. It **is** the enforcement kernel for Lockdown.

The distribution **maintenance kernel** remains on the system for maintenance and recovery. Distribution errata still apply to packages and to the maintenance kernel path.

For deployment implications, coexistence with distribution maintenance, and fleet patterns, see the [Enterprise Adoption Guide](enterprise-adoption-guide/).

---

## Root Lock kernel version string anatomy {#hs-kernel-version-string-anatomy}

The running kernel version is shown by `uname -r`. On a Root Lock deployment, the string identifies the HeartSuite build, not a distribution errata package.

**Fielded 6.18 pin:** `uname -r` is **`6.18.9-hs`**. Packaging label is `6.18.9-HeartSuite-3` (build **#37**). Absence of the word `HeartSuite` in `uname -r` does **not** mean you are on the maintenance kernel.

**Legacy 5.19 example:** `5.19.6-HeartSuite-1.0`

| Component | Fielded 6.18 example | Meaning |
|---|---|---|
| Upstream LTS base | `6.18.9` | The mainline LTS kernel version HeartSuite built from for this release. This is the upstream tag lineage, not a count of every upstream commit merged since a prior HeartSuite build. |
| Vendor segment | `hs` in `uname`; `HeartSuite` in the packaging label | Identifies the binary as an Root Lock kernel. Match `uname -r` to [Evidence Status](evidence-status/) and the distro matrix, not to a single historical suffix. |
| HeartSuite build | packaging `6.18.9-HeartSuite-3`, `file` **#37** | HeartSuite's rebuild/bundle identity for this upstream base. |

On 6.18 the HS-vs-maintenance test is `uname -r` plus `file` on vmlinuz, as documented in [Evidence Status](evidence-status/). The fielded pin is `6.18.9-hs`.

### What the version string does **not** mean

Procurement and scanner teams trained on distribution errata often misread custom kernel strings. The Root Lock kernel version string **does not** imply:

- **Full upstream parity** — The string does not assert that every fix present in a newer upstream kernel is backported. HeartSuite rebuilds on the LTS base with the published HeartSuite configuration; fixes apply to **compiled-in** paths or are addressed through structural absence and Lockdown bounds as documented on the [Kernel Security Transparency](../../security/) page.
- **Distribution errata equivalence** — A match against a distribution CVE feed or `rpm -q kernel` version is not valid for the Root Lock kernel. The Root Lock kernel is not the distribution enforcement kernel.
- **Scanner "fixed in version" logic** — Vulnerability scanners that compare `uname -r` to NVD "fixed version" thresholds will produce false positives for Root Lock kernels. Use HeartSuite's per-CVE status and [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) guidance instead of raw version-string matching.
- **kABI or DKMS compatibility** — The string does not promise binary compatibility with out-of-tree kernel modules built for the distribution kernel or for prior HS builds.
- **Live-patch level** — There is no parallel "kpatch level" or running-patch suffix; updates require a coordinated bundle and reboot path.
- **Secure Boot readiness** — Version format does not indicate UEFI Secure Boot signing status for the Root Lock kernel entry. Secure Boot support for the Root Lock kernel remains incomplete; see the [Enterprise Adoption Guide](enterprise-adoption-guide/#secure-boot-firmware-compatibility-and-roadmap) for current status.

For independent verification of what **is** in the build, HeartSuite publishes the kernel `.config` SHA-256 and evidence packs for each supported stream.

---

## Update delivery

Root Lock kernel updates are delivered only as part of **coordinated HeartSuite release bundles**.

### Bundle format and integrity

- Updates ship as a self-extracting **`heartsuite-install.sh`** bundle with a published **`heartsuite-install.sh.sha256`** checksum file.
- Before execution, verify integrity:

  ```bash
  sha256sum -c heartsuite-install.sh.sha256
  ```

  Expected output: `heartsuite-install.sh: OK`

- Each bundle updates the Root Lock kernel (`vmlinuz-<version>-HeartSuite-<release>`), userspace tools, Dashboard files, and GRUB defaults together so the enforcement stack stays paired and tested.

### Applying an update

The installer will not overwrite Root Lock while that kernel is booted.

1. If Lockdown is applied, unseal from the console first. That trip is not the install boot.
2. From a terminal in Setup Mode, run `bash heartsuite-install.sh` and type `YES`. That takes one stock or maintenance boot and continues the update. The default stays Root Lock.
3. If you are already on the original distro kernel or the maintenance kernel and Lockdown is not applied, run the installer. There is no `YES` step.

Root Lock is **not** loaded on that stock or maintenance boot: it does not block, log, or take backups. Choose a time when that gap is acceptable.

Full step-by-step procedures, failure recovery, and Lockdown considerations are in [Updating Root Lock](../../maintenance/updating-heartsuite/).

### Pre-configured image alternative

Teams that provision from images may **reprovision from an updated pre-configured image** instead of in-place bundle application. This is equivalent from a support perspective when the image contains a bundle version HeartSuite has published for that stream.

Image pipelines should pin bundle version, checksum, and Root Lock kernel string in build metadata for audit traceability.

In-place bundle application after Lockdown still needs the console unseal on that host. Teams that will not open a console on every node should treat image reprovision as the fleet path. Package installs on a live sealed host are a different job — [Protecting During Maintenance](../../maintenance/protecting-during-maintenance/).

---

## Patch commitment tiers

HeartSuite classifies kernel-related security work using the reachability model on the [Kernel Security Transparency](../../security/) page. The tables below are **public targets** for coordinated bundle delivery. **Binding SLAs** — including business-day definitions, escalation, and credit terms — are set in your **subscription agreement**.

Clock start for timed tiers: **HeartSuite confirmation** that the issue applies to the supported Root Lock kernel stream (reachable path or required rebuild), based on upstream vendor/public confirmation and HeartSuite analysis.

| Tier | Criteria | Target delivery |
|---|---|---|
| **Critical** | Actively exploited in the wild **or** remote unauthenticated RCE on a **reachable** Root Lock kernel path (compiled in, triggerable on a supported deployment profile) | **15 business days** from HeartSuite confirmation |
| **Important** | Reachable HS path, **no** known active exploitation | **30 business days** from HeartSuite confirmation |
| **Moderate / Low (reachable)** | Reachable but lower practical impact on standard server profiles; Lockdown may bound post-exploitation | **Next scheduled coordinated bundle** |
| **Not Affected** | Vulnerable subsystem **compiled out** or path documented as unreachable on the Root Lock kernel; Score on Root Lock **0.0** | **No patch required** — status documented on the CVE page; bundle may still ship for other reasons |

**Notes**

- Many high-severity CVEs are **Not Affected** on Root Lock kernels because the attack surface was never compiled in. Those entries do not consume patch-tier clocks.
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

**Major stream deprecation**: HeartSuite provides **at least 30 days' advance notice** before ending support for an Root Lock kernel stream (for example, end of 5.19 support). Notice includes migration bundle availability and recommended maintenance windows.

Machine-readable advisory feeds are **published** as JSON under [`/advisories/`](/advisories/index.json) on each annotated `hs-v*` release tag.

For the current release (`hs-v1.6.4-kernel-6.18.9`, `gate_status: PASS`): CONFIG-gate Not-Affected SBOM at [`/advisories/hs-cve-config-sbom.json`](/advisories/hs-cve-config-sbom.json), OSV at [`/advisories/osv.json`](/advisories/osv.json) (279 entries), and CycloneDX SBOM at [`/advisories/sbom.cyclonedx.json`](/advisories/sbom.cyclonedx.json).

**OVAL XML** for OpenSCAP is not yet published. Use the JSON feeds, CVE transparency page, bundle manifests, and email advisories as authoritative sources. Feed URLs and schemas: [Supply Chain and Advisory Feeds](supply-chain-and-advisories/#published-advisory-feeds-hs-kernel).

---

## 5.19 stream deprecation

The upstream **5.19** branch is **end-of-life**. HeartSuite no longer recommends 5.19 for new deployments or new pre-configured images.

**Support window for existing deployments**

- HeartSuite continues to ship **5.19 migration and security bundles** for deployments already on the 5.19 HS stream **through end of calendar year 2026**, subject to subscription status.
- After that date, 5.19 Root Lock kernel support ends unless extended terms are agreed in writing. Email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) before the cutoff to plan fleet migration.

**Migration path**

1. Schedule maintenance using [Updating Root Lock](../../maintenance/updating-heartsuite/) (or reprovision from a 6.18 pre-configured image).
2. Apply the published **5.19 → 6.18 migration bundle** for your distribution and HeartSuite version.
3. Reboot into the 6.18 Root Lock kernel, review Dashboard queues for any new program activity, and re-engage Lockdown if required.
4. Update vulnerability-management and configuration baselines to reference the new version string and published 6.18 config hash.

Functional differences between streams (configuration, module footprint, CVE tables) are summarized in the [Distro Compatibility Matrix](distro-compatibility-matrix/) and stream-specific evidence materials.

---

## Support boundaries

### Subscription scope

- The Root Lock kernel is **included in the Root Lock subscription**. There is **no separate kernel-only support contract**.
- Incidents, rebuild requests, deployment guidance, and coordinated updates for kernel behaviour are handled under the same subscription that enables Lockdown.
- Verification artifacts (config SHA-256, evidence packs, CVE transparency data, bundle checksums) are provided as part of the product documentation and subscription deliverables.

### Coexistence with distribution subscriptions

On a host running Root Lock:

| Kernel | Role | Patching |
|---|---|---|
| **Root Lock kernel** | Enforcement kernel for Setup Mode and Lockdown | **HeartSuite coordinated bundles only** |
| **Maintenance kernel** | Maintenance, recovery, and distribution-compatible work | **Distribution errata and package updates** apply as usual |

Root Lock **replaces the enforcement kernel** for protected operation; it does **not** remove the distribution kernel or cancel distribution maintenance obligations on the maintenance-kernel path. During maintenance on the maintenance kernel, the host behaves as a standard distribution system without Lockdown enforcement.

Distribution-vendor subscriptions (RHEL, SLES, Ubuntu Pro, and similar extended-support offerings) and third-party agents that require the distribution kernel for full functionality continue to apply to the maintenance-kernel path and to userspace packages.

Agents or tools that require BPF, specific kernel modules, or kernel interfaces absent from the Root Lock kernel should run on a kernel that still exposes those interfaces, or on a separate host.

The Root Lock kernel omits these by design to eliminate bypass primitives and attack surface. See the [Enterprise Adoption Guide](enterprise-adoption-guide/) compatibility section and [Reduced Kernel Footprint](../introduction/heartsuite-overview/#reduced-kernel-footprint).

---

## What Root Lock does not provide

Root Lock does **not** offer the following on the Root Lock kernel path:

| Capability | HeartSuite position |
|---|---|
| **kpatch / live kernel patching** | Not supported. Kernel changes require reboot through the coordinated bundle path (or image reprovision). |
| **Arbitrary DKMS or kABI-stable third-party modules** | Not supported as a compatibility guarantee. The Root Lock kernel configuration diverges deliberately from distribution kernels; out-of-tree modules built for distro kernels are not expected to load. |
| **Upstream version chasing** | HeartSuite does not track every mainline release. Only supported **LTS streams** listed in this policy receive builds. |
| **Distribution-style per-CVE errata packages** | CVE remediation is expressed through HeartSuite bundles and transparency documentation, not separate `kernel-` RPM/DEB errata tied to the HS binary. |
| **JSON advisory feeds (CONFIG SBOM / OSV / CycloneDX)** | Published at [`/advisories/`](/advisories/index.json) on `hs-v*` releases — see [Supply Chain and Advisory Feeds](supply-chain-and-advisories/). |
| **OVAL feeds (OpenSCAP)** | Planned; not yet published. |
| **Complete Secure Boot for Root Lock kernel entries** | Incomplete; orthogonal to Lockdown enforcement but relevant to boot-integrity policies — see [Enterprise Adoption Guide](enterprise-adoption-guide/). |

If a workload **requires** live patching, vendor-certified unchanged distribution kernels, or broad third-party kernel module support as non-negotiable constraints, evaluate the maintenance-kernel path, HJFS on a standard kernel, or layered controls described in the Enterprise Adoption Guide rather than the Root Lock kernel.

---

## Related reading

- [Enterprise Adoption Guide](enterprise-adoption-guide/) — Deployment, fleet operations, Secure Boot status, risk ownership, and compatibility decision tree.
- [Updating Root Lock](../../maintenance/updating-heartsuite/) — Bundle verification, update procedure, and recovery.
- [Kernel Security Transparency](../../security/) — Per-CVE status, Not Affected rationale, and Score on Root Lock.
- [Distro Compatibility Matrix](distro-compatibility-matrix/) — Supported distributions, kernel streams, and coexistence notes.
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — Resolving scanner false positives against HS version strings.
- [Supply Chain and Advisory Feeds](supply-chain-and-advisories/) — Published CONFIG SBOM, OSV, and CycloneDX feeds; GPG/cosign and OVAL roadmap.
- [Evidence Status](evidence-status/) — Per-stream config hash and checker publication status.

---

*This page is procurement- and operations-facing. Patch targets are goals for planning; binding commitments are in your subscription agreement. Last updated: 2026-06-23.*
