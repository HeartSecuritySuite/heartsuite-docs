---
title: "Distribution Compatibility Matrix"
linkTitle: "Distro Compatibility"
weight: 7
description: "Which Linux distributions Root Lock by HeartSuite supports for the HS kernel — validation tiers, boot paths, RPM and Debian family notes, workload fit, and how to report compatibility issues."
categories: ["Reference"]
tags: ["kernel", "debian", "ubuntu", "alpine", "rhel", "rocky", "enterprise", "compatibility"]
type: docs
toc: true
---

**Overview**: Which Linux distributions HeartSuite has validated for the HS kernel, what each support tier means, and where RHEL-family images need customer-side validation before production Lockdown.

**Subject:** Root Lock by HeartSuite HS kernel (5.19 and 6.18 lines; v1.6.4 commercial baseline: kernel 6.18.9)  
**Audience:** Procurement, security architects, and platform engineers selecting or certifying a base OS for Root Lock by HeartSuite.

This matrix states which distributions HeartSuite has validated in release testing, which are officially supported without a specific gate run, and where customer-side validation is required before production Lockdown. It complements the workload-level exclusions in [System Requirements](../../introduction/system-requirements/) and the buyer-facing deployment guidance in the [Enterprise Adoption Guide](enterprise-adoption-guide/).

---

## How to read this matrix

Each row assigns a **tier** that tells you what HeartSuite has tested and what you own in procurement:

| Tier | Meaning for buyers |
|------|-------------------|
| **Validated** | Passed the cross-distro release gate on the listed version. HeartSuite installs, boots the HS kernel, completes Setup Mode, and reaches Lockdown on this combination in CI. |
| **Supported** | Listed in official system requirements and expected to work with the standard installer. May not appear in every gate run; validate in your staging environment before fleet rollout. |
| **Compatible (customer validation)** | Same RPM or Debian family as a validated build, but HeartSuite has not published branded testing for your exact minor or vendor image. You run install and Lockdown on your gold image before production. |
| **Not supported** | Outside architecture or distribution scope. Use HJFS on a standard kernel or a supported base OS. |

**Columns in the main table**

- **HS kernels** — Root Lock by HeartSuite ships two kernel lines: **5.19** and **6.18**. New commercial baselines use the 6.18 line (for example, `6.18.9-HeartSuite-1.0` for v1.6.4). Either line may be selected at install; both enforce the same Root Lock by HeartSuite contract.
- **Boot** — How the installer sets the default kernel entry. UEFI Secure Boot for the **HS kernel entry** remains [incomplete](enterprise-adoption-guide/#secure-boot-firmware-compatibility-and-roadmap); the original distribution kernel (Non-HS) retains its signing status for maintenance and recovery.

A **cross-distro release gate** runs after every kernel update. The April 2026 v1.6.4 gate validated: Debian 12, Debian 13 (Trixie), Ubuntu 24.04, Fedora 41, Rocky 9.7, CentOS Stream 9, Alpine 3.21, and openSUSE Tumbleweed. See the [Roadmap](../../roadmap/#v164-multi-distro-release-april-2026) for release history.

---

## Main compatibility table

| Distribution | Versions | Tier | HS kernels | Boot | Notes |
|--------------|----------|------|------------|------|-------|
| **Debian** | 13 (Trixie) | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. Primary reference for new deployments. |
| **Debian** | 12 (Bookworm) | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. |
| **Debian** | 11 (Bullseye) | **Supported** | 5.19, 6.18 | GRUB | In system requirements; validate on your image before fleet Lockdown. |
| **Ubuntu** | 24.04 LTS | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. |
| **Ubuntu-derived** | Other LTS / current releases | **Supported** | 5.19, 6.18 | GRUB | Derivatives sharing Debian packaging and GRUB (Mint, Pop!_OS, etc.). Staging validation recommended. |
| **Rocky Linux** | 9.7 | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. Lead RPM reference for enterprise RHEL-compatible fleets. |
| **Fedora** | 41 | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. Fast-moving upstream; useful for CI and pre-production, not a long-term LTS substitute. |
| **CentOS Stream** | 9 | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. **Faster churn** than Rocky or RHEL — retest after every `dnf update` that changes the kernel ABI or boot stack. |
| **RHEL** | 8.x, 9.x | **Compatible (customer validation)** | 5.19, 6.18 | GRUB | RHEL-compatible; branded RHEL minor testing not yet published. Validate on **your** subscribed minor and gold image. SELinux Enforcing may need a targeted policy module — see [RHEL operational note](lsm-comparison/#co-existence). |
| **AlmaLinux** | 8.x, 9.x | **Compatible (customer validation)** | 5.19, 6.18 | GRUB | Treat as equivalent to Rocky Linux for compatibility expectations; validate on your minor. |
| **Alpine Linux** | 3.21 | **Validated** | 5.19, 6.18 | extlinux (GRUB where present) | April 2026 gate. OpenRC service units ship alongside systemd variants. Installer falls back to **console instructions** when extlinux automation cannot set the default entry. |
| **Alpine Linux** | Other 3.x | **Supported** | 5.19, 6.18 | extlinux | Same OpenRC and extlinux behaviour as 3.21; staging validation recommended. |
| **openSUSE** | Tumbleweed | **Validated** | 5.19, 6.18 | GRUB | April 2026 gate. **Development and CI only** — rolling release; not a procurement baseline for regulated production. |
| **SUSE Linux Enterprise (SLES)** | Any | **Compatible (customer validation)** | 5.19, 6.18 | GRUB | Enterprise SUSE images vary by subscription and SP level. Contact support before committing a SLES gold image. |
| **Other Linux** | — | **Not supported** | — | — | Contact support@heartsecsuite.com for roadmap or HJFS alternatives. |
| **Non-x86** | ARM, RISC-V, etc. | **Not supported** | — | — | x86_64 only. |

**Architecture:** x86_64 (64-bit) only. No ARM or other ISA builds are offered for the HS kernel.

**Secure Boot (all distributions):** HS kernel UEFI Secure Boot support is incomplete. Deployments with mandatory Secure Boot for the HS entry may require MOK enrollment during install or booting the HS kernel with Secure Boot disabled while retaining the signed Non-HS kernel for maintenance. Details: [Enterprise Adoption Guide → Secure Boot](enterprise-adoption-guide/#secure-boot-firmware-compatibility-and-roadmap).

---

## Tier definitions

### Validated

HeartSuite ran the full cross-distro release gate on the stated distribution version: install bundle, HS kernel boot, Setup Mode, service lifecycle (systemd or OpenRC), and Lockdown smoke checks. These rows are the default answer for RFP compatibility questions tied to v1.6.4 and later kernel bundles.

### Supported

Officially in [System Requirements](../../introduction/system-requirements/) and covered by commercial support when install and Lockdown succeed on the customer image. HeartSuite may not re-run every gate on every supported minor; your staging environment is the final gate before production.

### Compatible (customer validation)

Same packaging family or ABI lineage as a validated build, but HeartSuite has not published test results for your exact vendor branding, minor release, or gold image. Rocky 9.7 validation implies Rocky 9.x and AlmaLinux 9.x are structurally compatible; RHEL 8/9 require validation on the customer's subscribed minor until branded RHEL matrices are published.

### Not supported

Outside current product scope. Use a supported distribution, the Non-HS kernel on a separate host for incompatible workloads, or [HJFS](../../hjfs/) on a standard kernel where custom kernels are prohibited.

---

## RPM / RHEL family

RPM-based support expanded in the **v1.6.4 multi-distro release (April 2026)**. This matrix is the authoritative source for distribution tiers; [System Requirements](../../introduction/system-requirements/) and [FAQs](../../faqs/) link here for current status.

**Lead with Rocky 9.7 (Validated).** For enterprise fleets standardizing on RHEL-compatible userspace, Rocky Linux 9.7 is the reference RPM image: GRUB defaulting, SELinux stacking, and coordinated bundle install match what HeartSuite tests in CI.

| Distribution | Guidance |
|--------------|----------|
| **Rocky Linux 9.7** | Validated — default RPM choice for new deployments. |
| **Fedora 41** | Validated — suitable for engineering and pre-production; shorter support window than Rocky or RHEL. |
| **CentOS Stream 9** | Validated with **faster churn warning**: Stream tracks RHEL development; kernel and userspace updates land more aggressively than Rocky. Re-validate after significant `dnf` upgrades. |
| **RHEL 8 / RHEL 9** | **Compatible — customer validation on their minor.** Binaries are RHEL-compatible, but HeartSuite has not published branded RHEL minor test matrices. Run the install bundle on your subscribed RHEL gold image and complete Setup Mode before fleet Lockdown. |
| **AlmaLinux 8 / 9** | **Compatible — equivalent to Rocky.** Expect the same installer behaviour as Rocky on the same major version; validate on your minor. |

**SELinux on RHEL-family systems:** HeartSuite VFS hooks run before the LSM chain. SELinux can only add restrictions after HeartSuite allows an operation; it cannot bypass HeartSuite denials. On RHEL and Fedora, SELinux is Enforcing by default. As with any new kernel module on RHEL, a targeted SELinux policy entry may be needed for HeartSuite-specific operations. If AVC denials appear, use `ausearch` and `audit2allow` to build a targeted module — HeartSuite enforcement is unaffected. Full hook-order detail: [LSM Comparison → Co-existence](lsm-comparison/#co-existence) (*RHEL operational note*).

---

## Debian and Ubuntu family

Debian and Ubuntu-derived distributions remain the longest-supported install path and the majority of documentation examples.

| Distribution | Guidance |
|--------------|----------|
| **Debian 12 / 13** | Validated (April 2026 gate). Preferred for new Debian-based gold images. |
| **Debian 11** | Supported — widely deployed; validate on your image if you remain on Bullseye. |
| **Ubuntu 24.04 LTS** | Validated (April 2026 gate). |
| **Other Ubuntu-derived** | Supported — derivatives using `.deb` packages and GRUB. AppArmor is present on Ubuntu but disabled in the HS kernel build; Snap and LXD confinement that depends on AppArmor userspace LSM is unavailable on the HS kernel. See [System Requirements → Software compatibility](../../introduction/system-requirements/#software-compatibility-notes). |

Installer behaviour on Debian/Ubuntu: sets the HS kernel as the GRUB default and reboots automatically when GRUB automation succeeds (v1.6.4+). The original distribution kernel remains in GRUB as Maintenance and vanilla entries for recovery.

---

## Alpine Linux

Alpine is a supported, validated path for minimal and container-adjacent appliances.

| Topic | Detail |
|-------|--------|
| **Validated version** | Alpine 3.21 (April 2026 gate). |
| **Init system** | **OpenRC** — HeartSuite ships OpenRC service unit variants alongside systemd oneshots. |
| **Boot loader** | Many Alpine images use **extlinux** rather than GRUB. The installer sets the HS kernel as default where automation applies; when extlinux cannot be updated automatically, the installer prints **console instructions** for the operator to complete the default entry change. |
| **Tier for other 3.x** | Supported — same packaging model; validate before production. |

Alpine's musl-based userspace is fully within scope when the distribution version is supported or validated. Workload exclusions (eBPF, FUSE, dynamic containers after Lockdown, KVM host mode) apply regardless of distribution — see [Workload fit](#workload-fit-not-distro-specific) below.

---

## SUSE family

| Distribution | Guidance |
|--------------|----------|
| **openSUSE Tumbleweed** | **Validated** (April 2026 gate) for **development and CI only**. Rolling updates make it unsuitable as a fixed procurement baseline for regulated production. |
| **SUSE Linux Enterprise (SLES)** | **Compatible — contact support.** SP level, BCI vs full SLES, and partner images affect boot stack and package layout. Engage support@heartsecsuite.com before standardizing a SLES gold image. |

---

## Workload fit (not distro-specific)

Distribution compatibility answers whether Root Lock by HeartSuite **installs and boots** on your base OS. Whether the **workload** belongs on the HS kernel is a separate decision — the same across every row in the matrix.

Root Lock by HeartSuite deliberately removes kernel features used as bypass primitives. Workloads that depend on those features require the **Non-HS kernel** (maintenance mode) or a **separate host**, regardless of whether the distribution is Validated or Supported.

| Requirement | On HS kernel? | Reference |
|-------------|---------------|-----------|
| Local eBPF tooling (Falco, Cilium Tetragon, bpftrace, bcc, etc.) | No | [System Requirements](../../introduction/system-requirements/#software-compatibility-notes) |
| FUSE mounts (sshfs, s3fs, AppImage, gocryptfs, …) | No | Same |
| Dynamic Kubernetes (HPA, pod reschedule after Lockdown) | No | [How Root Lock by HeartSuite Compares](../../introduction/how-it-compares/) |
| KVM **hypervisor host** (running VMs from this kernel) | No | [System Requirements](../../introduction/system-requirements/#software-compatibility-notes) |
| Rootless / unprivileged user-namespace containers | No | Same |
| HS kernel as **guest** inside KVM, VMware, or cloud hypervisors | Yes | Same |
| Fixed appliance, regulated server, closed workload set | Yes | [Deployment Scenarios](../../introduction/deployment-scenarios/) |

Full exclusion table and container-host install notes: [System Requirements](../../introduction/system-requirements/). Decision tree for mixed environments: [Enterprise Adoption Guide → Compatibility](enterprise-adoption-guide/#compatibility-and-certification).

---

## HJFS alternative

Organizations with a strict **no custom or modified kernel** policy — certification rules, cloud provider-managed kernels, or vendor OS support contracts that forbid replacing the distribution kernel — should not force the HS kernel onto those images.

**HeartSuite Joint File System (HJFS)** provides per-program, per-version file isolation and automatic backup on a **completely standard kernel**. No kernel replacement is required. HJFS is deployable on any distribution where a standard kernel is mandated, including cloud instances where the provider owns the kernel image.

| Scenario | Path |
|----------|------|
| File isolation without custom kernel | [HJFS documentation](../../hjfs/) |
| Execution and network controls without HS kernel | [HeartSuite Exec Lock](../../../exec-lock/) alongside HJFS where applicable |
| Full three-layer coverage when HS kernel is acceptable | Root Lock by HeartSuite (HS kernel) + HJFS on the same host |

HJFS limits, deployment scenarios, and comparison to kernel-level enforcement: [HJFS how-it-compares](../../hjfs/how-it-compares/) and [HJFS limits](../../hjfs/introduction/limits/). Procurement mapping: [Enterprise Adoption Guide → Honest limitations](enterprise-adoption-guide/#honest-limitations).

---

## Reporting issues

If install or HS kernel boot fails on a Supported or Compatible distribution, contact HeartSuite support with enough context to reproduce the failure:

**Email:** support@heartsecsuite.com

**Include:**

1. **`/var/log/heartsuite/install.log`** — installer steps and outcome (see [Appendices](../../appendices/)).
2. **Kernel identity:** output of `uname -r` (expected to end in `HeartSuite` when the HS kernel is active, for example `6.18.9-HeartSuite-1.0`).
3. **OS identity:** contents of `/etc/os-release`.
4. **Root Lock by HeartSuite version** and whether the failure occurs during install, first HS boot, Setup Mode, or Lockdown.
5. **Boot loader** in use (GRUB vs extlinux) and whether UEFI Secure Boot is enabled.

For non-blocking bugs on supported platforms, open a GitHub issue using the Bug Report template on the public repository. **Do not** use public issues for security vulnerabilities — email support@heartsecsuite.com for responsible disclosure.

Kernel update recovery procedures if a new HS kernel fails to boot: [Updating Root Lock by HeartSuite](../../maintenance/updating-heartsuite/).

---

## Related reading

- [Kernel Support Policy](kernel-support-policy/) — LTS strategy, patch targets, version-string semantics, and notification
- [System Requirements](../../introduction/system-requirements/) — Architecture, kernel lines, and software exclusion table
- [Enterprise Adoption Guide](enterprise-adoption-guide/) — Secure Boot status, fleet operations, procurement decision tree
- [LSM Comparison](lsm-comparison/) — SELinux co-existence and RHEL operational note
- [Procurement Brief](procurement-brief/) — Hardening posture comparison for buyers
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — Scanner false-positive workflow for HS kernel hosts
- [How Root Lock by HeartSuite Compares](../../introduction/how-it-compares/) — What requires a separate kernel or host
- [Deployment Scenarios](../../introduction/deployment-scenarios/) — Where Root Lock by HeartSuite fits in production
- [Roadmap](../../roadmap/#v164-multi-distro-release-april-2026) — v1.6.4 multi-distro validation history
- [HJFS documentation](../../hjfs/) — Standard-kernel alternative for strict kernel policies
- [Before You Begin](../../getting-started/before-you-begin/) — Prerequisites and cloud vs local install paths