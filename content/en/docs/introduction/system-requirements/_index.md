---
title: "System Requirements"
weight: 3
description: "Hardware and software prerequisites for HeartSuite Root Lock compatibility."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "x86"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---

**Overview**: HeartSuite Root Lock requires an x86 Linux system running a supported distribution — Debian/Ubuntu-derived or Alpine. RPM-based distributions (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE) are coming soon. It ships with two HeartSuite Root Lock kernels (5.19 and 6.18) and a set of tools that enforce allowlist-based security at the kernel level.

## Supported platforms

| Component | Supported |
|-----------|-----------|
| Architecture | x86 (64-bit) |
| Distributions | Debian 11, 12, 13; Ubuntu-derived; Alpine Linux; RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE *(coming soon)* |
| Kernels | HeartSuite Root Lock kernel 5.19, HeartSuite Root Lock kernel 6.18 |

HeartSuite Root Lock supports Debian/Ubuntu-derived and Alpine distributions on x86. RPM-based distributions (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE) are coming soon.

## Kernel

HeartSuite Root Lock is distributed with two HeartSuite Root Lock kernels based on mainline Linux: 5.19 and 6.18. One of these kernels must be booted for HeartSuite Root Lock to function. The Dashboard verifies kernel activation as part of Phase 1 (System Verification) and provides orientation on every boot.

## Software compatibility notes

The HeartSuite Root Lock kernel is compiled without several features that attackers use to gain elevated access or escape security restrictions — keeping them in would undermine kernel-level allowlisting. Software that relies on those features will not run on the HeartSuite Root Lock kernel — use the Non-HS kernel or a separate system for those workloads.

The HS kernel is installed alongside your existing kernel via GRUB — it does not replace it. Setup Mode reveals any compatibility issue before Lockdown enforces: programs that would fail in Lockdown appear in the Dashboard review queues during the observation period. Software not in the table below will run without modification.

| Not available on HS kernel | Affects |
|-----------|---------|
| eBPF program loading (`CONFIG_BPF_SYSCALL`) | Cilium, Falco, Tetragon, Pixie, bpftrace, bcc, Tracee, and other eBPF-based observability and runtime-detection tools |
| FUSE (`CONFIG_FUSE_FS`) | sshfs, s3fs, rclone mounts, NTFS-3G, AppImage, gocryptfs |
| Overlay filesystem (`CONFIG_OVERLAY_FS`) | Standard-host installs: not enabled — overlay filesystems give attackers a path to shadow protected directories. Container-host installs: enabled (`CONFIG_OVERLAY_FS=m`) — Docker, containerd, Podman, and CRI-O use the `overlay2` storage driver. See [Deployment Scenarios → Container Hosts](../deployment-scenarios/#container-hosts). |
| AppArmor, SMACK, Landlock (userspace LSM frameworks) | Snap confinement, Ubuntu default profiles, LXD |
| Unprivileged user namespaces (`CONFIG_USER_NS`) | Rootless containers |
| KVM (`CONFIG_KVM`) | Running HeartSuite Root Lock as a hypervisor host for virtual machines |

The HeartSuite Root Lock kernel itself can run as a guest inside KVM, VMware, or other hypervisors — only running virtual machines from within the HeartSuite Root Lock kernel is unavailable.

These are intentional design decisions. HeartSuite Root Lock's kernel-level allowlisting replaces the runtime observability and confinement layers these tools provide — see [HeartSuite Root Lock Overview → Reduced Kernel Footprint](../heartsuite-overview/#reduced-kernel-footprint) for the rationale, and [Deployment Scenarios](../deployment-scenarios/) for environments where HeartSuite Root Lock fits well versus workloads that are better left on the Non-HS kernel.
