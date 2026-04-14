---
title: "Before You Begin"
weight: 1
description: "System requirements and prerequisites for installing HeartSuite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "prerequisites", "requirements", "beginner", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky"]
toc: true
type: docs
---

**Overview**: Review system requirements and prerequisites before installing HeartSuite, whether using a Cloud Path or Local Path.

## System Requirements

- **Operating System**: Debian 11, 12, or 13; Ubuntu-derived; Alpine Linux; or RPM-based (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE) — on x86 architecture.
- **Access Level**: Root access (sudo privileges).
- **Skills**: Basic familiarity with the Linux command line.

If your setup differs, check the [Introduction](../introduction/) for compatibility details.

## Cloud Path vs Local Path

- **Cloud Path**: Launch a pre-installed HeartSuite cloud instance (AWS AMI, GCP image). No download or kernel installation required — you boot directly into Setup Mode and the Dashboard appears on first login.
- **Local Path**: Download the installation package from [heartsecsuite.com](https://heartsecsuite.com), extract, install the HeartSuite kernel, and complete the Installation screen setup through multiple reboot cycles before reaching the Dashboard.

Both paths merge at the Dashboard after Phase 1 (System Verification) is complete.
