---
title: "Obtaining and Installing Root Lock by HeartSuite"
weight: 20
description: "Download and installation steps for Root Lock by HeartSuite."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "download"]
toc: true
type: docs
menu:
  main:
    identifier: "installation"
    weight: 20
---

**Overview**: Root Lock by HeartSuite installation follows one of two paths depending on your deployment method. Both paths end at the Dashboard after initial setup confirms that the machine is ready for allowlisting.

## Choose your path

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Launch a pre-configured cloud instance (AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers). The Dashboard confirms initial setup is complete on first boot — skip ahead to the allowlisting queues.

Installer and initial setup logs from the image build are in `/var/log/heartsuite/`. Use the provider serial console if you need them.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Run a single install command, then reboot multiple times to build the initial allowlist of startup and shutdown programs.

1. [Obtaining Root Lock](obtaining-heartsuite/) — Run the install command.
2. [Installation Part 1](installation-part1/) — Run the installer and reboot to load the kernel.
3. [Installation Part 2](installation-part2/) — Complete the initial setup steps to allowlist startup and shutdown programs.

After the final reboot cycle, the Dashboard appears and displays the Suggested Next Step to guide you into allowlisting. On failure or for forensics, use the serial console to `cat /var/log/heartsuite/install.log`.
{{< /choice-card >}}
{{< /choice-pane >}}
