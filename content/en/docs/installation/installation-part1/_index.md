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

## Install

```bash
tar xvf *HeartSuite*.tar -m && sudo bash heartsuite-install-bundle.sh
```

The installer sets up the HeartSuite Core Secure kernel, tools, and Dashboard.

## Reboot into the HeartSuite Core Secure Kernel

Reboot the system:

```bash
reboot
```

When the GRUB menu appears, select the HeartSuite Core Secure kernel:

Select the entry containing **HeartSuite** in the kernel name. On some distributions this appears under **Advanced options**.

> [!TIP]
> If the GRUB menu does not appear automatically, hold **Shift** (BIOS) or press **Esc** immediately after the system starts.

After boot, the Dashboard appears on the console. Continue with [Installation Part 2](../installation-part2/).

## If the Reboot Fails

If the system does not reboot or hangs:

1. Verify the installer completed without errors before rebooting.
2. Check GRUB configuration for VMs (uncomment `GRUB_DISABLE_LINUX_UUID` if needed and run `update-grub`).

If neither step resolves the issue, contact HeartSuite support.
