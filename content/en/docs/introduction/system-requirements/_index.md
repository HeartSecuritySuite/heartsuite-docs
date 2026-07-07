---
title: "System Requirements"
weight: 3
description: "Hardware and software prerequisites for Root Lock by HeartSuite compatibility."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "x86"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---

**Overview**: Root Lock by HeartSuite requires an x86 Linux system running a supported distribution. Debian, Ubuntu-derived, Alpine, and several RPM-based distributions are supported or validated; see the [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/) for tiers and versions. It ships with two Root Lock by HeartSuite kernels (5.19 legacy and 6.18 primary) and a set of tools that enforce allowlist-based security at the kernel level.

## Supported platforms

| Component | Supported |
|-----------|-----------|
| Architecture | x86 (64-bit) |
| Distributions | See [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/) — validated: Debian 12/13, Ubuntu 24.04, Rocky 9.7, Fedora 41, CentOS Stream 9, Alpine 3.21; supported: Debian 11, Ubuntu-derived, Alpine 3.x; RPM enterprise (RHEL, AlmaLinux, SLES): customer validation |
| Kernels | Root Lock by HeartSuite kernel 5.19 (legacy), Root Lock by HeartSuite kernel 6.18 (primary) |

Root Lock by HeartSuite supports Debian/Ubuntu-derived and Alpine distributions on x86, plus RPM-based distributions validated in the v1.6.4 release gate (Rocky 9.7, Fedora 41, CentOS Stream 9). Branded RHEL and AlmaLinux are RHEL-compatible — validate on your gold image before fleet Lockdown. Full tiers and notes: [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/).

## Kernel

Root Lock by HeartSuite is distributed with two Root Lock by HeartSuite kernels based on mainline Linux: 5.19 and 6.18. One of these kernels must be booted for Root Lock by HeartSuite to function. The Dashboard verifies kernel activation as part of Phase 1 (System Verification) and provides orientation on every boot.

## Software compatibility notes

The HeartSuite kernel is deliberately built without several features attackers use for privilege escalation or to bypass controls (eBPF, FUSE, overlay, user namespaces, etc.). These are the attack surface the design removes. Software that needs them runs on the maintenance kernel or a separate system.

The HeartSuite kernel is installed alongside your existing kernel via GRUB — it does not replace it. Setup Mode reveals any compatibility issue before Lockdown enforces: programs that would fail in Lockdown appear in the Dashboard review queues during the observation period. Software not in the table below will run without modification.

| Not available on the HeartSuite kernel | Affects |
|-----------|---------|
| eBPF program loading (`CONFIG_BPF_SYSCALL`) | Cilium, Falco, Tetragon, Pixie, bpftrace, bcc, Tracee, and other eBPF-based observability and runtime-detection tools |
| FUSE (`CONFIG_FUSE_FS`) | sshfs, s3fs, rclone mounts, NTFS-3G, AppImage, gocryptfs |
| Overlay filesystem (`CONFIG_OVERLAY_FS`) | Standard-host installs: not enabled — overlay filesystems give attackers a path to shadow protected directories. Container-host installs: enabled (`CONFIG_OVERLAY_FS=m`) — Docker, containerd, Podman, and CRI-O use the `overlay2` storage driver. See [Deployment Scenarios → Container Hosts](../deployment-scenarios/#container-hosts). |
| AppArmor, SMACK, Landlock (userspace LSM frameworks) | Snap confinement, Ubuntu default profiles, LXD |
| Unprivileged user namespaces (`CONFIG_USER_NS`) | Rootless containers |
| KVM (`CONFIG_KVM`) | Running Root Lock by HeartSuite as a hypervisor host for virtual machines |

The Root Lock by HeartSuite kernel itself can run as a guest inside KVM, VMware, or other hypervisors — only running virtual machines from within the Root Lock by HeartSuite kernel is unavailable.

Execution environment requirement: the host must be bare metal or a full virtual machine (KVM, cloud hypervisors, VMware etc.) that gives HeartSuite its own kernel to boot. Shared-kernel containers (OpenVZ, LXC, Docker/Podman as a guest sharing the provider kernel, systemd-nspawn) are refused by design. See the guard in the proposed installer and the framing in [Reduced Kernel Footprint](../heartsuite-overview/#reduced-kernel-footprint).

These omissions are deliberate. Root Lock by HeartSuite replaces the runtime tools these primitives enable. See [Reduced Kernel Footprint](../heartsuite-overview/#reduced-kernel-footprint) and [Deployment Scenarios](../deployment-scenarios/).
