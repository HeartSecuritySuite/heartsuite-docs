---
title: "System Requirements"
weight: 3
description: "Hardware and software prerequisites for HeartSuite Core Secure compatibility."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "x86"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---

**Overview**: HeartSuite Core Secure requires an x86 Linux system running a supported distribution — Debian/Ubuntu-derived, Alpine, or RPM-based (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE). It ships with two HeartSuite Core Secure kernels (5.19 and 6.18) and a set of tools that enforce allowlist-based security at the kernel level.

## Supported Platforms

| Component | Supported |
|-----------|-----------|
| Architecture | x86 (64-bit) |
| Distributions | Debian 11, 12, 13; Ubuntu-derived; Alpine Linux; RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE |
| Kernels | HeartSuite Core Secure kernel 5.19, HeartSuite Core Secure kernel 6.18 |

HeartSuite Core Secure supports Debian/Ubuntu-derived, Alpine, and RPM-based distributions (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE) on x86.

## Kernel

HeartSuite Core Secure is distributed with two HeartSuite Core Secure kernels based on mainline Linux: 5.19 and 6.18. One of these kernels must be booted for HeartSuite Core Secure to function. The Dashboard verifies kernel activation as part of Phase 1 (System Verification) and provides orientation on every boot.

## Software Compatibility Notes

The HeartSuite Core Secure kernel is compiled without several features that introduce privilege-escalation or confinement-bypass primitives inconsistent with kernel-level allowlisting. Software that relies on those features will not run on the HeartSuite Core Secure kernel — use the Non-HS kernel or a separate system for those workloads.

| Not available on HS kernel | Affects |
|-----------|---------|
| eBPF program loading (`CONFIG_BPF_SYSCALL`) | Cilium, Falco, Tetragon, Pixie, bpftrace, bcc, Tracee, and other eBPF-based observability and runtime-detection tools |
| FUSE (`CONFIG_FUSE_FS`) | sshfs, s3fs, rclone mounts, NTFS-3G, AppImage, gocryptfs |
| Overlay filesystem (`CONFIG_OVERLAY_FS`) | Docker default storage driver, containerd, Podman, CRI-O (alternative storage drivers may still work) |
| AppArmor, SMACK, Landlock (userspace LSM frameworks) | Snap confinement, Ubuntu default profiles, LXD |
| Unprivileged user namespaces (`CONFIG_USER_NS`) | Rootless containers |
| KVM (`CONFIG_KVM`) | Running HeartSuite Core Secure as a hypervisor host for virtual machines |

The HeartSuite Core Secure kernel itself can run as a guest inside KVM, VMware, or other hypervisors — only running virtual machines from within the HeartSuite Core Secure kernel is unavailable.

These are intentional design decisions. HeartSuite Core Secure's kernel-level allowlisting replaces the runtime observability and confinement layers these tools provide — see [HeartSuite Core Secure Overview → Reduced Kernel Attack Surface](../heartsuite-overview/#reduced-kernel-attack-surface) for the rationale, and [Deployment Scenarios](../deployment-scenarios/) for environments where HeartSuite Core Secure fits well versus workloads that are better left on the Non-HS kernel.
