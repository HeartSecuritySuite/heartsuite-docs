---
title: "Installing HeartSuite – Part 1"
weight: 3
description: "Extract the HeartSuite tar file, run the installer, and reboot to load the HeartSuite kernel."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "installer", "reboot"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part1"
---

**Overview**: Extract the HeartSuite distribution, run the installer script, and reboot to load the HeartSuite kernel. This is the first step of Phase 1 (System Verification) on the Local Path.

> [!NOTE]
> Cloud users skip this step entirely. The HeartSuite kernel is pre-installed and Phase 1 auto-completes on first boot. Proceed directly to the Dashboard.

## Extract the Distribution

Untar the distribution tar file:

```bash
# tar xvf 6.18-HeartSuite-1.6.4.tar -m
```

## Run the Installer

Run the **HeartSuite_install.sh** script:

```bash
sudo ./HeartSuite_install.sh
```

> [!TIP]
> This extracts and installs the HeartSuite kernel and tools. Reboot after the installer completes to load the HeartSuite kernel.

After the installer finishes, it displays a message indicating that a reboot is required to load the HeartSuite kernel. Use `systemctl reboot` to restart the system.

## If the Reboot Fails

If the system does not reboot or hangs, try these steps:

1. Verify the tar file extracted correctly and the installer completed without errors.
2. Check GRUB configuration for VMs (uncomment `GRUB_DISABLE_LINUX_UUID` if needed and run `update-grub`).
3. Boot into recovery mode and run `fsck` to check file systems.
4. After a successful boot, the Dashboard confirms the HeartSuite kernel is loaded. The Safety Banner shows the current mode and the System Info Strip shows "Kernel: HS".
