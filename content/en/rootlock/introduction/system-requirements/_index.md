---
title: "What this kernel needs — and what differs by stream"
linkTitle: "System Requirements"
weight: 3
description: "Architecture, supported distributions, kernel features and workloads the Root Lock kernel does not support, and which hosts the installer runs on. Confirm these before you install."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "x86"]
type: docs
aliases:
  - /docs/introduction/system-requirements/
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---

**Overview**: Confirm the host is x86 Linux on a distribution from the current lab matrix before you install. The Local Path command is the same on bare metal and on a full virtual machine. Root Lock by HeartSuite ships a **6.18** kernel for new images (`uname -r` is `6.18.9-hs` on the current release) and a **5.19** kernel only for old-glibc hosts (Debian 11, Ubuntu 20.04). Each line has its own configuration.

See the [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/) for tiers, versions, and kernel line per row. That page is the source for which bases are Supported, In lab, Experimental, or Legacy.

## Supported platforms

| Component | Supported |
|-----------|-----------|
| Architecture | x86 (64-bit) |
| Distributions | Current 6.18 lab set: Debian 12/13, Ubuntu 24.04/26.04 (**Supported**). Fedora 42 (**In lab**). Rocky Linux 10, CentOS Stream 10, Alpine 3.21, openSUSE Tumbleweed (**Experimental**). Debian 11 and Ubuntu 20.04 (**Legacy, 5.19 only**). Ubuntu 22.04, Rocky Linux 9, RHEL 9, AlmaLinux 9, and CentOS Stream 9 miss the Python 3.11 floor. RHEL 8 and AlmaLinux 8 miss the glibc 2.34 floor. SLES: contact support; the same floors apply. Full notes: [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/). |
| Kernels | 6.18 for new installs (`6.18.9-hs`). 5.19 only on Debian 11 / Ubuntu 20.04. |

Do not use the April 2026 v1.6.4 list (Fedora 41, Rocky 9.7, Alpine 3.21 as “validated,” Ubuntu 22.04 omitted). That table is retired.

## Kernel

New Debian 12/13 and Ubuntu 24.04/26.04 installs boot the 6.18 Root Lock kernel. Debian 11 and Ubuntu 20.04 take the 5.19 installer and kernel only; the 6.18 bundle must not be installed on them. Ubuntu 22.04 is not offered on this installer (Python 3.10). The Dashboard verifies kernel activation after initial setup and provides orientation on every boot.

## Software compatibility notes

The BPF syscall is off on the 6.18.9-hs kernel, so eBPF tools cannot attach. Workloads that need FUSE, OverlayFS, user namespaces, AppArmor, or a KVM host are not a supported configuration on a Root Lock host. Tools that need those interfaces run on another host or on the maintenance kernel.

The Root Lock kernel is installed alongside your existing kernel via GRUB — it does not replace it. In Setup Mode, programs that would be blocked under Lockdown appear in the Dashboard review queues, so you see them before you lock down. Software not listed below runs on the Root Lock kernel like any other program: under Lockdown it needs an allowlist entry.

| Workload | On the Root Lock kernel |
|-----------|-------------------------|
| eBPF tooling (Falco, bpftrace, bcc, Cilium, Tetragon, …) | Syscall omitted |
| FUSE (sshfs, s3fs, rclone, AppImage, gocryptfs, …) | Not a supported workload |
| Overlay / typical container storage | Docker, containerd, Kubernetes, CRI-O, and Podman on a Root Lock host are not a supported workload. OCI images are built and run off this host, or Root Lock is the guest kernel in a VM the customer provides. |
| AppArmor userspace (Snap, Ubuntu profiles, LXD) | Not a supported workload |
| Unprivileged user namespaces / rootless containers | Not a supported workload |
| KVM hypervisor **host** | Not a supported product role. Root Lock as a **guest** on KVM/VMware/cloud is supported. |

## Bare metal, virtual machines, and nested VMs

The Local Path install command is the same on a physical machine and on a full virtual machine. Cloud Path is a pre-built image of that same install.

What differs is the machine you run it on: firmware and real devices on metal; virtio and a hypervisor serial console on a VM.

| Environment | Supported for install | What differs |
|-------------|----------------------|--------------|
| **Bare metal** | Yes | Keyboard and monitor for the boot path. Firmware, physical disks, and physical NICs are in play. |
| **Full VM with hardware virtualization** (KVM, VMware, AWS/GCP/Azure and other cloud hypervisors) | Yes | The hypervisor serial console is the boot path (`virsh console`, AWS EC2 Serial Console, Linode LISH, Hetzner console, and similar). Devices are virtio or the cloud equivalent. |
| **A VM nested inside another VM without hardware virtualization** | No | The installer stops at the start. Install on the outer machine, or use a host that exposes `/dev/kvm`. |

Root Lock must boot its own kernel, so it runs on bare metal or a full VM. Shared-kernel container guests (OpenVZ, LXC, Docker/Podman sharing the provider kernel, systemd-nspawn) belong on a separate host. A nested guest needs `/dev/kvm` on the outer machine; if `/dev/kvm` is missing, install Root Lock on the outer machine itself.

See [Where Root Lock is not a fit](../deployment-scenarios/#where-root-lock-is-not-a-fit) and [Reduced Kernel Footprint](../heartsuite-overview/#reduced-kernel-footprint).

When the host matches these requirements, continue to [Getting Started](../../getting-started/).
