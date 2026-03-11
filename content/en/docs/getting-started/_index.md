---
title: Getting Started
description: Quick guide to install and start using HeartSuite.
categories: ["Essentials"]
tags: ["heartsuite", "linux", "installation", "quickstart", "beginners"]
weight: 2
toc: true
---

{{% pageinfo color="primary" %}}
New to HeartSuite? This Quick Start guide walks you through the essentials to get up and running in minutes.
{{% /pageinfo %}}

HeartSuite is a security suite that proactively blocks malware by whitelisting safe programs and actions. This guide covers the "what you'll do and why" for beginners—skip to detailed docs for advanced setup.



## Quick Installation

**Why?** Install HeartSuite's modified kernel and tools to enable security features without disrupting your server.

1. Download the tar file from [heartsecsuite.com](https://heartsecsuite.com).

2. Untar and run the installer (as root):

   ```bash
   # **tar** xvf 5.19.6-HeartSuite-1.0.tar -m
   # **sudo ./HeartSuite_install.sh**
   ```

3. Reboot to load the kernel:

   ```bash
   # **systemctl reboot**
   ```

   **If reboot fails**: Check GRUB settings for VMs (see [Installation](../installation/) details).

4. Run the setup script multiple times (as root):

   ```bash
   # **sudo python3 /.hs/sys/hs-os-boot-setup.py**
   ```

   Reboot and repeat until it says "Great! Your OS... whitelisted" (usually 3-5 times).

   **Why?** Builds a whitelist for startup programs to prevent boot hangs.

## Basic Setup and Testing

**Why?** Switch to Secure mode for protection, then test with a program.

1. Verify activation:

   ```bash
   # **dmesg | grep HEARTSUITE**
   ```

   Look for "Setup" mode messages.

2. Whitelist a test program (e.g., nano):

   ```bash
   # **sudo /.hs/sys/hs-whitelist-manager add -x /usr/bin/nano**
   # Run **nano** to generate logs, check them, add permissions as needed.
   ```

   **Why?** HeartSuite blocks everything by default—whitelisting allows safe actions.

3. Switch to Secure mode:

   ```bash
   # **sudo /.hs/sys/hs-mode-switch off**
   # **systemctl reboot**
   ```

   **If it hangs**: Switch back to Setup mode with **hs-mode-switch setup**.

3. Switch to Secure mode:

   ```bash
   # **sudo /.hs/sys/hs-mode-switch off**
   # **systemctl reboot**
   ```

   **If it hangs**: Switch back to Setup mode with **hs-mode-switch setup**.

## Next Steps

- For full whitelisting: Head to [Whitelisting](../whitelisting/).
- For production: Enable [Lockdown](../mode-switching/#lockdown-securing-your-system-in-secure-mode).
- Stuck? Check [Troubleshooting](../troubleshooting/).

This gets you a basic secure setup. Explore advanced features as needed!
