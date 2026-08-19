---
title: "What this kernel needs — and what differs by stream"
linkTitle: "System Requirements"
weight: 3
description: "Architecture, current lab distributions, and how 5.19 vs the fielded 6.18 pin treat eBPF, FUSE, OverlayFS, and KVM. Confirm these before you install."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "x86"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---

**Overview**: Confirm the host is x86 Linux on a distribution from the current lab matrix before you install. Root Lock by HeartSuite ships a **6.18** kernel for new images (`uname -r` is `6.18.9-hs` on the fielded pin) and a **5.19** kernel only for old-glibc hosts (Debian 11, Ubuntu 20.04). The two lines are not the same configuration.

See the [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/) for tiers, versions, and kernel line per row. That page is the source for which bases are Supported, In lab, Experimental, or Legacy.

## Supported platforms

| Component | Supported |
|-----------|-----------|
| Architecture | x86 (64-bit) |
| Distributions | Current k6 lab set: Debian 12/13, Ubuntu 22.04/24.04 (**Supported**). Ubuntu 26.04, Rocky 9, Fedora 42 (**In lab**). Alpine 3.21, CentOS Stream 9, openSUSE Tumbleweed (**Experimental**). Debian 11 and Ubuntu 20.04 (**Legacy, 5.19 only**). RHEL, AlmaLinux, SLES, and other Ubuntu-derived images: customer validation. Full notes: [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/). |
| Kernels | 6.18 for new installs (`6.18.9-hs`). 5.19 only on Debian 11 / Ubuntu 20.04. |

Do not use the April 2026 v1.6.4 list (Fedora 41, Rocky 9.7, Alpine 3.21 as “validated,” Ubuntu 22.04 omitted). That table is retired.

## Kernel

New Debian 12/13 and Ubuntu 22.04/24.04 installs boot the 6.18 Root Lock kernel. Debian 11 and Ubuntu 20.04 take the k5 installer and 5.19 only — they must not consume the 6.18 bundle. The Dashboard verifies kernel activation after initial setup and provides orientation on every boot.

## Software compatibility notes

The **5.19** legacy kernel compiled out eBPF, FUSE, OverlayFS, user namespaces, AppArmor, and KVM. The **fielded 6.18 pin** (`6.18.9-hs`, packaging `6.18.9-HeartSuite-3`, build `#37`) compiles those interfaces in (`CONFIG_BPF_SYSCALL=y`, `CONFIG_FUSE_FS=y`, `CONFIG_OVERLAY_FS=m`, `CONFIG_USER_NS=y`, `CONFIG_SECURITY_APPARMOR=y`, `CONFIG_KVM=m`). Do not treat “not a fit” on 6.18 as `ENOSYS`.

The Root Lock kernel is installed alongside your existing kernel via GRUB — it does not replace it. Setup Mode reveals programs that would fail in Lockdown in the Dashboard review queues. Software not listed below is not automatically denied; Lockdown still requires an allowlist entry for each program.

| Workload | 5.19 legacy | Fielded 6.18 (`6.18.9-hs`) |
|-----------|-------------|------------------------------|
| eBPF tooling (Falco, bpftrace, bcc, Cilium, Tetragon, …) | Syscall not compiled | Syscall compiled in. Lockdown still refuses unallowlisted loaders. |
| FUSE (sshfs, s3fs, rclone, AppImage, gocryptfs, …) | Not compiled | Compiled in. New mounts after Lockdown follow product mount rules. |
| Overlay / typical container storage | Not compiled | Module (`=m`). Dynamic Kubernetes after Lockdown remains a poor fit because of allowlist and mount seal, not because OverlayFS is absent. |
| AppArmor userspace (Snap, Ubuntu profiles, LXD) | Not compiled | Compiled in. Validate on the running kernel. |
| Unprivileged user namespaces / rootless containers | Not compiled | Compiled in. Still validate under Lockdown. |
| KVM hypervisor **host** | Not compiled | Module (`=m`). **Not a supported product role.** Root Lock as a **guest** on KVM/VMware/cloud is supported. |

The host must be bare metal or a full virtual machine (KVM, cloud hypervisors, VMware etc.) that gives Root Lock its own kernel to boot. Shared-kernel containers (OpenVZ, LXC, Docker/Podman as a guest sharing the provider kernel, systemd-nspawn) are not a fit by design. See [Reduced Kernel Footprint](../heartsuite-overview/#reduced-kernel-footprint) and [Deployment Scenarios](../deployment-scenarios/).

When the host matches these requirements, continue to [Getting Started](../../getting-started/).
