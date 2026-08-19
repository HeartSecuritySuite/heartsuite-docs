---
title: "Which distros boot the Root Lock kernel"
linkTitle: "Distro Compatibility"
weight: 7
description: "Current lab set for Debian, Ubuntu, Rocky, and other bases — kernel line per distro, workload fit on the shipped 6.18 pin, and how to report a problem."
categories: ["Reference"]
tags: ["kernel", "debian", "ubuntu", "alpine", "rhel", "rocky", "enterprise", "compatibility"]
type: docs
toc: true
---

**Overview**: Which Linux distributions Root Lock by HeartSuite currently tests, which kernel line each row uses, and what you still own before production Lockdown. This page follows the live-matrix catalog as of 2026-08-18. It replaces the April 2026 v1.6.4 “Validated” table (Fedora 41, Alpine 3.21 as validated, Ubuntu 22.04 omitted).

**Audience**: Procurement, security architects, and platform engineers selecting a base OS.

This matrix complements the workload notes in [System Requirements](../../introduction/system-requirements/) and the buyer-facing deployment guidance in the [Enterprise Adoption Guide](enterprise-adoption-guide/).

---

## How to read this matrix

Each row assigns a **tier** that says what HeartSuite has run recently and what you own:

| Tier | Meaning for buyers |
|------|-------------------|
| **Supported** | In the current k6 `release-core` lab set (Debian 12/13, Ubuntu 22.04/24.04). Install and initial setup have recent matrix coverage. Lockdown (M2) was **not** release-certified on 2026-08-18 — validate Lockdown on your gold image. |
| **In lab** | In the current catalog (`release-plus` or equivalent) with a named caveat. Not certified. |
| **Experimental** | Catalog `experimental` set, or explicitly not certified. Useful for CI; not a procurement baseline. |
| **Legacy (5.19 only)** | Old-glibc hosts. They take the k5 installer and the 5.19 Root Lock kernel only. A 6.18 install is refused. |
| **Compatible (customer validation)** | Same RPM or Debian family as a tested row, but HeartSuite has not published branded testing for your exact minor or vendor image. You run install and Lockdown on your gold image before production. |
| **Not supported** | Outside architecture or distribution scope. Use HJFS on a standard kernel or a supported base OS. |

Do **not** read “Supported” as “Lockdown certified on this date.” The latest completed M2 `release-core` campaign (2026-08-18) finished **PARTIAL** on all four core guests (`Release eligible: no`).

**Columns**

- **Kernel line** — Which Root Lock kernel the current installer for that row ships. New Debian 12/13 and Ubuntu 22.04/24.04 images use **6.18** (`uname -r` is `6.18.9-hs` on the fielded pin). Debian 11 and Ubuntu 20.04 use **5.19** only. You do not pick both lines at install on a given row.
- **Boot** — How the installer sets the default kernel entry. UEFI Secure Boot for the Root Lock kernel entry remains [incomplete](enterprise-adoption-guide/#secure-boot-firmware-compatibility-and-roadmap). The original distribution kernel (maintenance kernel) keeps its signing status for recovery.

Source for rows and kernel series: `heartsuite/tools/live_matrix/distro_catalog.yaml` (2026-08-18).

---

## Main compatibility table

| Distribution | Versions | Tier | Kernel line | Boot | Notes |
|--------------|----------|------|-------------|------|-------|
| **Debian** | 13 (Trixie) | **Supported** | 6.18 (`6.18.9-hs`) | GRUB | `release-core`. Seedless initial setup can stress OpenSSH split paths. |
| **Debian** | 12 (Bookworm) | **Supported** | 6.18 (`6.18.9-hs`) | GRUB | `release-core`. Primary lab reference. |
| **Debian** | 11 (Bullseye) | **Legacy (5.19 only)** | 5.19 | GRUB | glibc &lt; 2.34. k6 / 6.18 install is not offered. |
| **Ubuntu** | 24.04 LTS | **Supported** | 6.18 (`6.18.9-hs`) | GRUB | `release-core`. Cloud images are UEFI/OVMF pflash; remaining lab PARTIAL is post-seal SSH or kernel ledger, not snapshot create. |
| **Ubuntu** | 22.04 LTS | **Supported** | 6.18 (`6.18.9-hs`) | GRUB | `release-core`. Pair with 24.04. Omitted from the April 2026 public table. |
| **Ubuntu** | 26.04 LTS | **In lab** | 6.18 (`6.18.9-hs`) | GRUB | `release-plus`. First matrix inclusion 2026-08-15. **Not certified.** |
| **Ubuntu** | 20.04 LTS | **Legacy (5.19 only)** | 5.19 | GRUB | Same glibc floor as Debian 11. k6 / 6.18 install is not offered. |
| **Ubuntu-derived** | Other LTS | **Compatible (customer validation)** | Same as the Ubuntu LTS you track | GRUB | Mint, Pop!_OS, and similar `.deb` + GRUB derivatives. Staging validation required. AppArmor is compiled in on the current 6.18 pin — see [Workload fit](#workload-fit-not-distro-specific). |
| **Rocky Linux** | 9 | **In lab** | 6.18 (`6.18.9-hs`) | GRUB | `release-plus`. Last full green BLS path ~2026-07-11; re-validate on the current k6 bundle. Not “Rocky 9.7 always green.” |
| **Fedora** | 42 | **In lab** | 6.18 (`6.18.9-hs`) | GRUB | `release-plus`. Cloud root is often btrfs. Install preflight can refuse until a btrfs-capable module set is present. Not Fedora 41. Not certified. |
| **CentOS Stream** | 9 | **Experimental** | 6.18 (`6.18.9-hs`) | GRUB | Catalog `expected: experimental`. OpenSSH 9.8 can split SSH into two programs; first-run setup may need extra reboots. Faster churn than Rocky. |
| **RHEL** | 8.x, 9.x | **Compatible (customer validation)** | 6.18 unless your image is old-glibc | GRUB | Branded RHEL minor testing is not published. Validate on **your** subscribed minor and gold image. |
| **AlmaLinux** | 8.x, 9.x | **Compatible (customer validation)** | 6.18 unless your image is old-glibc | GRUB | Treat as structurally close to Rocky on the same major; validate on your minor. |
| **Alpine Linux** | 3.21.x (tester pin 3.21.6) | **Experimental** | 6.18 (`6.18.9-hs`) | extlinux (GRUB where present) | Catalog set `experimental`. OpenRC units ship alongside systemd. Installer prints **console instructions** when extlinux automation cannot set the default entry. Lab path is the real-glibc runtime, not a musl-only claim. |
| **Alpine Linux** | Other 3.x | **Compatible (customer validation)** | 6.18 (`6.18.9-hs`) | extlinux | Same OpenRC / extlinux behaviour; staging validation required. |
| **openSUSE** | Tumbleweed | **Experimental** | 6.18 (`6.18.9-hs`) | GRUB | Rolling release. GRUB `saved_entry` and SELinux `bin_t` labeling are load-bearing. Development and CI only — not a regulated production baseline. |
| **SUSE Linux Enterprise (SLES)** | Any | **Compatible (customer validation)** | 6.18 (`6.18.9-hs`) | GRUB | SP level and partner images vary. Email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) before committing a SLES gold image. |
| **Other Linux** | — | **Not supported** | — | — | Contact [support@heartsecsuite.com](mailto:support@heartsecsuite.com) for roadmap or HJFS alternatives. |
| **Non-x86** | ARM, RISC-V, etc. | **Not supported** | — | — | x86_64 only. |

**Architecture:** x86_64 (64-bit) only. No ARM or other ISA builds are offered for the Root Lock kernel.

**Secure Boot (all distributions):** Root Lock kernel UEFI Secure Boot support is incomplete.

Deployments that require Secure Boot for the Root Lock entry may need MOK enrollment during install. Alternatively, boot the Root Lock kernel with Secure Boot disabled while retaining the signed maintenance kernel. Details: [Enterprise Adoption Guide → Secure Boot](enterprise-adoption-guide/#secure-boot-firmware-compatibility-and-roadmap).

---

## Tier definitions

### Supported

The distribution is in the current k6 `release-core` set. HeartSuite runs install, first boot, and initial setup against it in the live matrix. As of 2026-08-18, Lockdown M2 on that set is **not** a published green sign-off. Your staging Lockdown run is the last gate before fleet rollout.

### In lab

The distribution is in the current catalog with a documented caveat (btrfs preflight, not certified, last green date older than the current bundle). Commercial support still applies when install and Lockdown succeed on the customer image.

### Experimental

Catalog `experimental`, or rolling / not certified. Expect extra reboots, boot-loader edge cases, or a missing release sign-off.

### Legacy (5.19 only)

Debian 11 and Ubuntu 20.04 use the k5 installer and the 5.19 Root Lock kernel. They must never consume the current k6 / 6.18 bundle.

### Compatible (customer validation)

Same packaging family as a tested row. HeartSuite has not published results for your exact vendor branding, minor, or gold image.

Rocky 9 lab coverage does **not** certify every Rocky 9.x or AlmaLinux 9.x minor. RHEL 8/9 require validation on the customer's subscribed minor.

### Not supported

Outside current product scope. Use a supported distribution, the maintenance kernel on a separate host for incompatible workloads, or [HJFS](../../hjfs/) on a standard kernel where custom kernels are prohibited.

---

## RPM / RHEL family

Lead with **Rocky 9 (in lab)** for RHEL-compatible userspace. Re-run install and Lockdown on the current k6 bundle; do not treat a 2026-07 BLS path as a standing certificate.

| Distribution | Guidance |
|--------------|----------|
| **Rocky Linux 9** | In lab — default RPM choice to *start* validation. Re-validate on your minor. |
| **Fedora 42** | In lab — engineering and pre-production. btrfs-root cloud images can fail install preflight. Shorter support window than Rocky or RHEL. |
| **CentOS Stream 9** | Experimental — Stream tracks RHEL development; retest after `dnf` upgrades that change the boot stack or OpenSSH layout. |
| **RHEL 8 / RHEL 9** | Compatible — customer validation on the subscribed minor. |
| **AlmaLinux 8 / 9** | Compatible — expect similar installer behaviour to Rocky on the same major; validate on your minor. |

**SELinux on RHEL-family systems:** On RHEL and Fedora, SELinux is Enforcing by default. Root Lock VFS hooks are designed to run before the LSM chain, so SELinux can add restrictions after Root Lock allows an operation and cannot lift a Root Lock denial. A targeted SELinux policy module may still be needed for product paths. If AVC denials appear, use `ausearch` and `audit2allow`. Hook-order detail: [LSM Comparison → Co-existence](lsm-comparison/#co-existence). That LSM page is still written against the **5.19.6** measured pack — do not treat it as the 6.18.9-hs LSM list.

---

## Debian and Ubuntu family

Debian 12/13 and Ubuntu 22.04/24.04 are the current k6 `release-core` set and the majority of documentation examples.

| Distribution | Guidance |
|--------------|----------|
| **Debian 12 / 13** | Supported (lab). Preferred for new Debian-based gold images. |
| **Debian 11** | Legacy — 5.19 / k5 only. |
| **Ubuntu 24.04 LTS** | Supported (lab). UEFI/pflash on cloud images. |
| **Ubuntu 22.04 LTS** | Supported (lab). |
| **Ubuntu 26.04 LTS** | In lab — not certified. |
| **Ubuntu 20.04 LTS** | Legacy — 5.19 / k5 only. |
| **Other Ubuntu-derived** | Compatible — `.deb` + GRUB. Validate Snap/LXD on the **running** kernel; the current 6.18 pin compiles AppArmor in. |

On Debian/Ubuntu the installer sets the Root Lock kernel as the GRUB default and reboots when GRUB automation succeeds. The original distribution kernel remains in GRUB as Maintenance and vanilla entries for recovery.

---

## Alpine Linux

| Topic | Detail |
|-------|--------|
| **Current tester pin** | Alpine 3.21.6 (`experimental` catalog set). |
| **Init system** | **OpenRC** — OpenRC service unit variants ship alongside systemd oneshots. |
| **Boot loader** | Many images use **extlinux**. When automation cannot update the default entry, the installer prints **console instructions**. |
| **Other 3.x** | Compatible — same packaging model; validate before production. |

---

## SUSE family

| Distribution | Guidance |
|--------------|----------|
| **openSUSE Tumbleweed** | **Experimental** — development and CI only. Rolling updates make it unsuitable as a fixed procurement baseline. |
| **SUSE Linux Enterprise (SLES)** | **Compatible — contact support.** SP level, BCI vs full SLES, and partner images affect the boot stack. Email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) before standardizing a SLES gold image. |

---

## Cloud platforms (AWS EC2 Nitro and KVM guests)

Root Lock runs as a **guest** on AWS EC2 (including Nitro), KVM, VMware, and other cloud hypervisors. Use a distribution from this matrix and the same installer as on local hardware.

Before you install on a cloud instance:

- Keep the provider serial console enabled. SSH can drop during the first Root Lock reboot; the console is how you recover if the instance does not come back.
- Run the install once on your target instance type in staging before fleet rollout.
- If the installer stops before reboot, read `/var/log/heartsuite/install.log` and email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) with the log attached.

Root Lock as a **hypervisor host** (running VMs from this kernel) is **not a supported product role**. That is a support-scope statement. The fielded 6.18 pin compiles `CONFIG_KVM=m`; do not read “not supported” as “KVM is compiled out.” See [Workload fit](#workload-fit-not-distro-specific).

---

## Workload fit (not distro-specific)

Distribution compatibility answers whether Root Lock **installs and boots** on your base OS. Whether a **workload** belongs on that host is a separate decision.

The two kernel lines are **not** the same configuration.

| Interface | 5.19 legacy (Debian 11 / Ubuntu 20.04) | Fielded 6.18 pin (`6.18.9-hs`, packaging `6.18.9-HeartSuite-3`, build `#37`) |
|-----------|----------------------------------------|-------------------------------------------------------------------------------|
| `CONFIG_BPF_SYSCALL` | not set | `=y` |
| `CONFIG_FUSE_FS` | not set | `=y` |
| `CONFIG_OVERLAY_FS` | not set | `=m` |
| `CONFIG_USER_NS` | not set | `=y` |
| `CONFIG_SECURITY_APPARMOR` | not set | `=y` |
| `CONFIG_KVM` | not set | `=m` |

On the **current 6.18 pin**, “this tool cannot run” is **not** an `ENOSYS` / compiled-out claim for eBPF, FUSE, OverlayFS, user namespaces, AppArmor, or KVM. A program can still fail because it is not on the allowlist, because Lockdown refuses a new mount or a new module load, or because the role is unsupported.

| Requirement | On the current 6.18 pin | On 5.19 legacy |
|-------------|-------------------------|----------------|
| Local eBPF tooling (Falco, bpftrace, bcc, …) | Syscall is compiled in. Lockdown still refuses unallowlisted loaders. | Syscall not compiled. |
| FUSE mounts (sshfs, s3fs, AppImage, …) | FUSE is compiled in. New mounts after Lockdown follow product mount rules. | FUSE not compiled. |
| Overlay / typical container storage | `overlay` is available as a module. Dynamic Kubernetes after Lockdown is still a poor fit (allowlist and mount seal), not because OverlayFS is absent. | Overlay not compiled. |
| KVM **hypervisor host** | **Not a supported product role** (module may be present). | Not compiled. |
| Rootless / unprivileged user-namespace containers | User namespaces are compiled in. Still validate under Lockdown; do not assume rootless “just works.” | User namespaces not compiled. |
| Root Lock as a **guest** inside KVM, VMware, or cloud hypervisors | Yes | Yes |
| Fixed appliance, regulated server, closed workload set | Yes | Yes |

Full exclusion table: [System Requirements](../../introduction/system-requirements/). Mixed-environment decision tree: [Enterprise Adoption Guide → Compatibility](enterprise-adoption-guide/#compatibility-and-certification).

---

## HJFS alternative

Organizations with a strict **no custom or modified kernel** policy — certification rules, cloud provider-managed kernels, or vendor OS support contracts that forbid replacing the distribution kernel — should not force the Root Lock kernel onto those images.

**HeartSuite Joint File System (HJFS)** provides per-program, per-version file isolation and automatic backup on a **standard kernel**. No kernel replacement is required.

| Scenario | Path |
|----------|------|
| File isolation without custom kernel | [HJFS documentation](../../hjfs/) |
| Program install, update, and version UI without a custom kernel | [HeartSuite Exec](../../exec-lock/) — filesystem UI next to HJFS |
| Full three-layer coverage when the Root Lock kernel is acceptable | Root Lock kernel + HJFS on the same host |

HJFS limits and comparison: [HJFS how-it-compares](../../hjfs/how-it-compares/) and [HJFS limits](../../hjfs/introduction/limits/). Procurement mapping: [Enterprise Adoption Guide → Honest limitations](enterprise-adoption-guide/#honest-limitations).

---

## Reporting issues

If install or Root Lock kernel boot fails on a Supported, In lab, Experimental, Legacy, or Compatible distribution, email support with enough context to reproduce:

**Email:** [support@heartsecsuite.com](mailto:support@heartsecsuite.com)

**Include:**

1. **`/var/log/heartsuite/install.log`** — installer steps and outcome (see [Appendices](../../appendices/)).
2. **Kernel identity:** output of `uname -r`.
   - Current 6.18 stream: expect **`6.18.9-hs`**. The packaging label is `6.18.9-HeartSuite-3` (build `#37`). Absence of the word `HeartSuite` does **not** mean you are on the maintenance kernel.
   - 5.19 legacy: expect a string such as `5.19.6-HeartSuite-2.0`.
   - Maintenance kernel: a distribution version string with no Root Lock packaging (for example a stock `debian` or `el` uname).
3. **OS identity:** contents of `/etc/os-release`.
4. **Root Lock version** and whether the failure occurs during install, first Root Lock boot, initial setup, or Lockdown.
5. **Boot loader** (GRUB vs extlinux) and whether UEFI Secure Boot is enabled.

For non-blocking bugs on supported platforms, open a GitHub issue using the Bug Report template on the public repository. **Do not** use public issues for security vulnerabilities — email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) for responsible disclosure.

Kernel update recovery if a new Root Lock kernel fails to boot: [Updating Root Lock](../../maintenance/updating-heartsuite/).

---

## Related reading

- [Kernel Support Policy](kernel-support-policy/) — LTS strategy, patch targets, version-string semantics, and notification
- [System Requirements](../../introduction/system-requirements/) — Architecture, kernel lines, and software notes
- [Enterprise Adoption Guide](enterprise-adoption-guide/) — Secure Boot status, fleet operations, procurement decision tree
- [LSM Comparison](lsm-comparison/) — SELinux co-existence (5.19.6 measured pack)
- [Procurement Brief](procurement-brief/) — Hardening posture comparison (5.19.6 measured pack)
- [CVE Hygiene for Scanners](cve-hygiene-for-scanners/) — Scanner workflow; do not infer 6.18 compile-out from 5.19 greps
- [How Root Lock Compares](../../introduction/how-it-compares/) — What belongs on a separate host
- [Deployment Scenarios](../../introduction/deployment-scenarios/) — Where Root Lock fits
- [HJFS documentation](../../hjfs/) — Standard-kernel alternative
- [Before You Begin](../../getting-started/before-you-begin/) — Prerequisites and cloud vs local install paths

---

*Last updated: 2026-08-18. Rows follow `distro_catalog.yaml`. Workload Kconfig values are from the fielded 6.18.9-hs `#37` config and the published 5.19.6-HeartSuite-1.0 pack. No complete Lockdown M2 release-core gate exists for this date.*
