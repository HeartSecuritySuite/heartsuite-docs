---
title: "Installing HeartSuite – Part 1"
weight: 3
description: "Extract the HeartSuite tar file, run the installer, and reboot to load the modified kernel."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "installer", "reboot"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part1"
---



This section covers extracting the HeartSuite distribution, running the installer script, and rebooting to load the modified kernel (Phase 1, with dashboard verification).

Untar the distribution tar file:

```bash
# tar xvf 5.19.6-HeartSuite-1.0.tar -m
```

Run the **HeartSuite_install.sh** script as **root**:

```bash
# sudo ./HeartSuite_install.sh
```

--OR--

```bash
# su # if you’re not logged in as root
# ./HeartSuite_install.sh
```

> [!TIP]
> This extracts and installs HeartSuite's kernel and tools. Reboot now to load the modified kernel.

After performing this part of the installation, the script will display the following message:

AT THIS POINT IN THE INSTALLATION PHASE, YOU MUST REBOOT IN ORDER FOR THE HEARTSUITE-MODIFIED KERNEL TO BE LOADED!

Use the systemctl command to reboot:

### If the Reboot Fails
If the system does not reboot or hangs, try these steps:
- Verify the tar file extracted correctly and the installer completed without errors.
- Check GRUB configuration for VMs (uncomment GRUB_DISABLE_LINUX_UUID if needed and run update-grub).
- Boot into recovery mode and run `fsck` to check file systems.
- Review logs with `journalctl -xe` or `dmesg` for kernel errors related to HeartSuite.