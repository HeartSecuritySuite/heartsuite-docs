---
title: "Apply an update without dropping Lockdown blindly"
linkTitle: "Updating Root Lock"
weight: 6
description: "Unseal first, stay on the maintenance kernel to run the bundle, then confirm you are back on the new Root Lock kernel."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "kernel", "installer"]
type: docs
toc: true
---

**Overview**: A Root Lock by HeartSuite update is delivered as a single self-extracting bundle (`heartsuite-install.sh`) that replaces the kernel and its userspace tools in one operation.

## What an update changes

- The Root Lock kernel (`vmlinuz-<version>-HeartSuite-<patch>`)
- HeartSuite userspace tools (`activate_HS`, `lockdown_HS`, Secure Script Launchers, setup scripts)
- The Dashboard files under `/opt/heartsuite/`
- GRUB configuration, so the new kernel becomes the default boot target

It does not modify user data, the existing allowlist entries, or backup files. After the new kernel boots, new programs appear in the review queues for you to approve.

## Why you cannot install on the Root Lock kernel

The running Root Lock kernel cannot replace itself. The installer aborts if it detects that kernel, and prints a host-specific `grub-reboot` line for the stock or maintenance target.

If Lockdown is still sealed, the first **Maintenance: unseal and return to Root Lock** boot is not a place to run the installer. Express return lifts the seal and bounces you back to Setup Mode on the Root Lock kernel. Stay-up on the maintenance kernel happens only after posture is already open.

Schedule updates during a planned maintenance window. Root Lock is not loaded while the maintenance kernel is running.

## Before you begin

- **Unseal first if Lockdown is active.** From the Dashboard, open Maintenance (`[m]`) and follow the sealed path in [Protecting During Maintenance](../protecting-during-maintenance/). You must land in Setup Mode before a later maintenance-kernel boot will stay up.
- **Verify the bundle.** Compare the SHA-256 of `heartsuite-install.sh` against the published checksum before running it.
- **Physical or serial-console access** for the GRUB picks and for recovery if the new kernel does not boot.

## Update procedure

1. Place `heartsuite-install.sh` and `heartsuite-install.sh.sha256` on the system, typically by `scp` into `/root/`.
2. If Lockdown is sealed, open Maintenance (`[m]`) and complete the unseal path. You should be in Setup Mode on the Root Lock kernel before the next step.
3. Reboot and select the maintenance kernel (or the stock target the installer printed) at the GRUB menu so the machine **stays** off the Root Lock kernel.
4. Verify integrity:

   ```bash
   sha256sum -c heartsuite-install.sh.sha256
   ```

   Expected output: `heartsuite-install.sh: OK`
5. Log in as root over SSH or the serial console (AWS EC2 Serial Console, Linode LISH, Hetzner, and others). On failure, inspect `/var/log/heartsuite/install.log` on the serial console.
6. Run the installer:

   ```bash
   bash heartsuite-install.sh
   ```

7. The installer applies the update and, by default, reboots into the new Root Lock kernel.
8. If new programs appear, they show in the review queues. Approve them through the Dashboard, then re-engage Lockdown (`[l]`) if it was active before the update.

## If the update fails

If the new Root Lock kernel does not boot, select the previous kernel from the GRUB menu. Physical or serial-console access is required for this step.

Both the previous Root Lock kernel and the maintenance kernel remain available as recovery entries. Contact HeartSuite support at [support@heartsecsuite.com](mailto:support@heartsecsuite.com) and include the contents of `/var/log/heartsuite/install.log` in your message — we're happy to help you recover.
