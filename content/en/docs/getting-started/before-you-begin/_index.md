---
title: "Before You Begin"
weight: 1
description: "System requirements and prerequisites for installing Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "prerequisites", "requirements", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky"]
toc: true
type: docs
---

**Overview**: Two setup paths: Cloud (boot a pre-installed instance) or Local (install the kernel yourself). Confirm the requirements below match your system, then follow your path.

## System requirements

- **Operating System**: x86 (64-bit) Linux — Debian 11–13, Ubuntu-derived, Alpine, or RPM-based (Rocky 9.7 validated; Fedora 41, CentOS Stream 9 validated; RHEL/AlmaLinux/SLES: customer validation). See [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/).
- **Access Level**: Root access (sudo privileges).
- **Skills**: Basic familiarity with the Linux command line.

If your setup differs, check the [Introduction](../../introduction/) for compatibility details.

## Choosing your setup path

- **Cloud Path**: Launch a pre-installed Root Lock by HeartSuite cloud instance (AWS AMI, GCP image). No download or kernel installation required — you boot directly into Setup Mode and the Dashboard appears on first login.
- **Local Path**: Download the installation package from [heartsecsuite.com](https://heartsecsuite.com), extract, install the Root Lock by HeartSuite kernel, and complete the Installation setup through multiple reboot cycles before reaching the Dashboard.

Both paths merge at the Dashboard after Phase 1 (System Verification) is complete.

**Ready to install?**

- **Local Path**: proceed to [Obtaining Root Lock by HeartSuite](../../installation/obtaining-heartsuite/).
- **Cloud Path**: launch your instance — the Dashboard appears on first login and confirms Phase 1 is complete.
