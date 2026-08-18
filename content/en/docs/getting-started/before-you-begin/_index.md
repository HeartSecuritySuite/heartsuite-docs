---
title: "Before You Begin"
weight: 1
description: "System requirements and prerequisites for installing Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "prerequisites", "requirements", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky"]
toc: true
type: docs
---

**Overview**: Confirm the requirements below match your system, then follow Cloud Path or Local Path.

## System requirements

- **Operating System**: x86 (64-bit) Linux — Debian 11–13, Ubuntu-derived, Alpine, or RPM-based (Rocky 9.7 validated; Fedora 41, CentOS Stream 9 validated; RHEL/AlmaLinux/SLES: customer validation). See [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/).
- **Execution environment**: bare metal or a full virtual machine (KVM, cloud hypervisors, etc.). Shared-kernel container guests (OpenVZ, LXC, Docker/Podman guests sharing the provider kernel) are not a fit by design: the kernel omits overlay filesystems, user namespaces, and the BPF syscall because those are the features attackers use to hide, shadow directories, and reach root. See [Deployment Scenarios](../../introduction/deployment-scenarios/).
- **Access Level**: Root access (sudo privileges).
- **Skills**: Basic familiarity with the Linux command line.

If your setup differs, check the [Introduction](../../introduction/) for compatibility details.

## Choosing your setup path

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Launch a pre-installed Root Lock by HeartSuite cloud instance (AWS AMI, GCP image). No download or kernel installation required — you boot directly into Setup Mode and the Dashboard appears on first login.

**Ready?** Launch your instance, then continue to [Verifying Installation](../../verification/).
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Download the installation package from [heartsecsuite.com](https://heartsecsuite.com), extract, install the Root Lock kernel, and complete the Installation setup through multiple reboot cycles before reaching the Dashboard.

**Ready?** Continue to [Obtaining Root Lock](../../installation/obtaining-heartsuite/).
{{< /choice-card >}}
{{< /choice-pane >}}

Both paths merge at the Dashboard after initial setup is complete. Cloud users continue to [Verifying Installation](../../verification/). Local users continue to [Obtaining Root Lock](../../installation/obtaining-heartsuite/).
