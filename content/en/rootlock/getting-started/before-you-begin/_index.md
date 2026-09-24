---
title: "Before You Begin"
weight: 1
description: "System requirements and prerequisites for installing Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "prerequisites", "requirements", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky"]
toc: true
type: docs
aliases:
  - /docs/getting-started/before-you-begin/
---

**Overview**: Confirm the requirements below match your system, then follow Cloud Path or Local Path on that host. On Local Path, finish distribution updates and the packages this host will run before you install.

## System requirements

- **Operating System**: x86 (64-bit) Linux. The current installer needs glibc 2.34 or newer and Python 3.11 or newer. The 6.18 lab set is Debian 12, Debian 13, Ubuntu 24.04, and Ubuntu 26.04. Debian 11 and Ubuntu 20.04 use the 5.19 kernel only. Ubuntu 22.04, Rocky Linux 9, and the rest of the EL9 family are not offered (Python below 3.11). RHEL 8 and older extended-support releases are below the glibc floor. See [Distro Compatibility Matrix](../../kernel-hardening/distro-compatibility-matrix/).
- **Execution environment**: bare metal or a full virtual machine with hardware virtualization (KVM, cloud hypervisors, VMware). The Local Path command is the same on both. Shared-kernel container guests (OpenVZ, LXC, Docker/Podman guests sharing the provider kernel) are not a fit by design. If a VPS or cloud guest has no `/dev/kvm`, install there; nesting a second guest causes the installer to stop at the start. See [Bare metal, virtual machines, and nested VMs](../../introduction/system-requirements/#bare-metal-virtual-machines-and-nested-vms) and [Deployment Scenarios](../../introduction/deployment-scenarios/).
- **Access Level**: Root access (sudo privileges).
- **Skills**: Basic familiarity with the Linux command line.

If your setup differs, check the [Introduction](../../introduction/) for compatibility details.

## Finish the OS first

On Local Path, complete distribution updates and install the packages and services this host will actually run. Then install Root Lock. During initial setup, Root Lock records startup and shutdown programs from those boots. Package-install helpers, compilers, and one-shot probes that execute in that window become allowlist entries even if they never execute again.

After the Dashboard appears, run the workload you will keep — not compilers, probes, or other one-shot tools. After Lockdown, add software through [Protecting During Maintenance](../../maintenance/protecting-during-maintenance/).

## Choosing your setup path

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Launch a pre-installed Root Lock by HeartSuite instance on AWS, Google Cloud, Azure, DigitalOcean, Linode, or another provider. No download or kernel installation required — you boot directly into Setup Mode and the Dashboard appears on first login.

**Ready?** Launch your instance, then continue to [Verifying Installation](../../verification/).
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Finish distribution updates and the packages this host will actually run, then download the installation package from [heartsecsuite.com](https://heartsecsuite.com), extract, install the Root Lock kernel, and complete the Installation setup through multiple reboot cycles before reaching the Dashboard.

**Ready?** Continue to [Obtaining Root Lock](../../installation/obtaining-heartsuite/).
{{< /choice-card >}}
{{< /choice-pane >}}

Cloud Path and Local Path merge at the Dashboard after initial setup is complete. Cloud users continue to [Verifying Installation](../../verification/). Local users continue to [Obtaining Root Lock](../../installation/obtaining-heartsuite/).

Many hosts still install through Cloud Path or Local Path on each machine. Ansible, Terraform, and GitOps apply allowlist policy after that install — see [Central Policy](../../alerts/central-policy-management/).
