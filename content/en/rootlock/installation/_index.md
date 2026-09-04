---
title: "Obtaining and Installing Root Lock by HeartSuite"
weight: 20
description: "Download and installation steps for Root Lock by HeartSuite."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "download"]
toc: true
type: docs
aliases:
  - /docs/installation/
menu:
  main:
    identifier: "installation"
    weight: 20
---

**Overview**: On a single host, Root Lock by HeartSuite installation follows Cloud Path or Local Path. Both end at the Dashboard after initial setup confirms that the machine is ready for allowlisting. On Local Path, finish the OS and the services this host will run before you install.

## Finish the OS first

On Local Path, complete distribution updates and install the packages and services this host will actually run. Then run the installer. During initial setup, Root Lock records startup and shutdown programs from those boots. Package-install helpers, compilers, and one-shot probes that execute in that window become allowlist entries even if they never execute again.

On Cloud Path, Root Lock already finished initial setup during image preparation. First-boot leftovers can still appear in the queues — dismiss them if they are not runtime. Details are in [Installation Part 2](installation-part2/).

## Choose your path

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Launch a pre-configured cloud instance (AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers). The Dashboard confirms initial setup is complete on first boot — skip ahead to the allowlisting queues. First-boot leftovers (cloud-init, provisioning helpers) can still appear there; do not approve them if they are not runtime.

Installer and initial setup logs from the image build are in `/var/log/heartsuite/`. Use the provider serial console if you need them.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Finish distribution updates and install the packages and services this host will actually run, then run a single install command on bare metal or a full virtual machine with hardware virtualization. Reboot multiple times to build the initial allowlist of startup and shutdown programs. Nesting a second guest without `/dev/kvm` causes the installer to stop at the start. See [Bare metal, virtual machines, and nested VMs](../introduction/system-requirements/#bare-metal-virtual-machines-and-nested-vms).

1. [Obtaining Root Lock](obtaining-heartsuite/) — Run the install command.
2. [Installation Part 1](installation-part1/) — Run the installer and reboot to load the kernel.
3. [Installation Part 2](installation-part2/) — Complete the initial setup steps to allowlist startup and shutdown programs.

After the final reboot cycle, the Dashboard appears and displays the Suggested Next Step to guide you into allowlisting. On failure or for forensics, use the serial console to `cat /var/log/heartsuite/install.log`.
{{< /choice-card >}}
{{< /choice-pane >}}

Many hosts still install through Cloud Path or Local Path on each machine. Ansible installs by running the Local Path installer or launching a Cloud Path image, then applying policy — see [Central Policy](../alerts/central-policy-management/).

When initial setup is complete, continue to [Verifying Installation](../verification/).
