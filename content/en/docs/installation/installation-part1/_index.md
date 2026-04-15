---
title: "Installing HeartSuite Core Secure – Part 1"
weight: 3
description: "Extract the HeartSuite Core Secure tar file, run the installer, and reboot to load the HeartSuite Core Secure kernel."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "installer", "reboot"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part1"
---

**Overview**: Run the installer bundle and reboot to load the HeartSuite Core Secure kernel. This is the first step of Phase 1 (System Verification) on the Local Path.

> [!NOTE]
> Cloud users skip this step entirely. The HeartSuite Core Secure kernel is pre-installed and Phase 1 auto-completes on first boot. Proceed directly to the Dashboard.

## Extract the Distribution

Untar the distribution tar file:

```bash
tar xvf 6.18-HeartSuite-1.6.4.tar -m
```

## Run the Installer

Run the installer from the extracted directory (as root):

```bash
sudo bash heartsuite-install-bundle.sh
```

The installer sets up the HeartSuite Core Secure kernel, tools, and management UI. When it finishes, it displays `=== Bundle Installation Complete ===`.

## Reboot into the HeartSuite Core Secure Kernel

Reboot the system:

```bash
reboot
```

When the GRUB menu appears, select the HeartSuite Core Secure kernel:

1. Select **Advanced options for Debian GNU/Linux**
2. Select **Debian GNU/Linux, with Linux 5.19.6-HeartSuite-1.0**

> [!TIP]
> If the GRUB menu does not appear automatically, hold **Shift** (BIOS) or press **Esc** immediately after the system starts.

After boot, the HeartSuite Core Secure management UI appears on the console. The Setup Wizard starts automatically — proceed to [Installation Part 2](../installation-part2/).

## If the Reboot Fails

If the system does not reboot or hangs, try these steps:

1. Verify the installer completed without errors before rebooting.
2. Check GRUB configuration for VMs (uncomment `GRUB_DISABLE_LINUX_UUID` if needed and run `update-grub`).
3. Boot into recovery mode and run `fsck` to check file systems.
4. After a successful boot, the Dashboard confirms the HeartSuite Core Secure kernel is loaded. The Safety Banner shows the current mode and the System Info Strip shows "Kernel: HS".
