---
title: "System Requirements"
weight: 3
description: "Hardware and software prerequisites for HeartSuite compatibility."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "x86"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---

**Overview**: HeartSuite requires an x86 Linux system running a supported distribution — Debian/Ubuntu-derived, Alpine, or RPM-based (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE). It ships with two HeartSuite kernels (5.19 and 6.18) and a set of tools that enforce allowlist-based security at the kernel level.

## Supported Platforms

| Component | Supported |
|-----------|-----------|
| Architecture | x86 (64-bit) |
| Distributions | Debian 11, 12, 13; Ubuntu-derived; Alpine Linux; RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE |
| Kernels | HeartSuite kernel 5.19, HeartSuite kernel 6.18 |

HeartSuite supports Debian/Ubuntu-derived, Alpine, and RPM-based distributions (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE) on x86.

## Kernel

HeartSuite is distributed with two HeartSuite kernels based on mainline Linux: 5.19 and 6.18. One of these kernels must be booted for HeartSuite to function. The Dashboard verifies kernel activation as part of Phase 1 (System Verification) and provides orientation on every boot.
