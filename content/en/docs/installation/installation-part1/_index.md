---
title: "Installing HeartSuite Core Secure – Part 1"
weight: 3
description: "Install the HeartSuite Core Secure kernel and boot into it for the first time."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "installer", "reboot"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part1"
---

**Overview**: Run the installer bundle and reboot to load the HeartSuite Core Secure kernel.

> [!NOTE]
> Cloud users skip this step entirely. The HeartSuite Core Secure kernel is pre-installed and on first boot the Dashboard confirms Phase 1 is complete. The Dashboard appears automatically on first boot.

## Verify the Download

```bash
sha256sum -c heartsuite-install.sh.sha256
```

Expected output: `heartsuite-install.sh: OK`

## Install

```bash
sudo bash heartsuite-install.sh
```

The installer sets up the HeartSuite Core Secure kernel, tools, and Dashboard.

## Reboot into the HeartSuite Core Secure Kernel

The installer sets the HeartSuite kernel as the default boot target and reboots automatically. A 5-second countdown appears — press **Ctrl+C** to cancel if you need to inspect logs before rebooting.

After reboot, the Dashboard appears automatically wherever you log in. Continue with [Installation Part 2](../installation-part2/).

> [!NOTE]
> **If you are connected over SSH**, your session drops when the reboot fires — this is expected. Reconnect over SSH after the system comes back: the Dashboard launches in your SSH session automatically when setup work remains. Once setup is complete, normal SSH logins drop you at a regular shell. The serial console (`virsh console`, AWS/Azure/GCP serial console, IPMI SOL) works the same way — it also reaches the Dashboard.

> [!NOTE]
> **If an amber warning appears instead of the countdown**, the installer could not set the GRUB default automatically. This occurs on Alpine Linux or when the GRUB configuration is missing. The warning includes instructions for opening a console session on your cloud provider (AWS, Azure, GCP, or DigitalOcean) or local VM before rebooting — then select the HeartSuite kernel from the GRUB menu manually.

## If the System Does Not Boot into HeartSuite

If the system boots to the wrong kernel or hangs:

1. Verify the installer completed without errors before the reboot fired.
2. For VMs: if UUID detection causes a boot failure, uncomment `GRUB_DISABLE_LINUX_UUID` in `/etc/default/grub` and run `update-grub`, then reboot.

If neither step resolves the issue, contact HeartSuite support.
