---
title: Getting Started
description: Choose your setup path and begin installation.
categories: ["Essentials"]
tags: ["heartsuite", "linux", "installation", "quickstart"]
weight: 15
toc: true
type: docs
aliases:
  - /docs/getting-started/
menu:
  main:
    identifier: "getting-started"
    weight: 18
---

**Overview**: On a single host, Root Lock by HeartSuite uses Cloud Path (pre-installed instance, Dashboard appears on first login) or Local Path (manual installation with multiple reboots). Cloud Path and Local Path both arrive at the Dashboard after initial setup.

## Before you begin

Check [Before You Begin](before-you-begin/) for system requirements and prerequisites, then follow Cloud Path or Local Path below.

## Order of work

On Local Path, finish distribution updates and install the packages and services this host will actually run. Then run the installer. After the first reboot into the Root Lock kernel, leave the host quiet until the Dashboard appears.

On Cloud Path, Root Lock already finished initial setup during image preparation. First-boot leftovers can still appear in the queues — do not approve them if they are not runtime.

When the Dashboard appears, Root Lock has already added the programs that executed at boot and shutdown. In Setup Mode, Root Lock logs the rest of the workload. [Allowlisting Basics](../allowlisting/allowlisting-basics/) covers **approve** and **skip**. After Lockdown, add software through [Protecting During Maintenance](../maintenance/protecting-during-maintenance/).

## Choose your path

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Launch a pre-installed Root Lock instance. No download or kernel installation required. First-boot leftovers can still appear in the queues — dismiss them if they are not runtime.

1. **Launch the instance** — start a pre-installed image on AWS, Google Cloud, Azure, DigitalOcean, Linode, or another provider.
2. **Open the Dashboard** — you boot into Setup Mode and the Dashboard appears on first login. Initial setup is already complete.
3. **[Verifying Installation](../verification/)** — confirm the Dashboard is ready, then follow the Suggested Next Step to begin allowlisting.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Install Root Lock on bare metal or a full virtual machine with hardware virtualization. Finish distribution updates and the packages this host will actually run, then:

<!-- markdownlint-disable MD029 -->
1. **[Obtaining Root Lock](../installation/obtaining-heartsuite/)** — download the installer from heartsecsuite.com.
2. **[Installation Part 1](../installation/installation-part1/)** — verify the download, run the installer, and reboot into the Root Lock kernel.
3. **[Installation Part 2](../installation/installation-part2/)** — complete initial setup through multiple reboot cycles until the Dashboard confirms it is complete.
4. **[Verifying Installation](../verification/)** — confirm initial setup is complete in the Dashboard.
<!-- markdownlint-enable MD029 -->
{{< /choice-card >}}
{{< /choice-pane >}}

Many hosts still install through Cloud Path or Local Path on each machine. Ansible, Terraform, and GitOps apply allowlist policy after that install — see [Central Policy](../alerts/central-policy-management/).

Once initial setup is complete, Cloud Path and Local Path merge — the Dashboard shows the setup checklist and the Suggested Next Step directs you to begin [allowlisting](../allowlisting/).
