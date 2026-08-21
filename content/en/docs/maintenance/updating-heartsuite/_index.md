---
title: "Apply an update without dropping Lockdown blindly"
linkTitle: "Updating Root Lock"
weight: 6
description: "The installer will not run on the Root Lock kernel, including Setup Mode. Unseal if Lockdown is applied, stay on the original distro or maintenance kernel to run the bundle, then return to the new Root Lock kernel."
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

The installer will not run while the Root Lock kernel is booted. It checks `uname -r`, stops, and tells you to reboot onto a kernel that is not Root Lock — the original distro kernel (stock), or the Maintenance entry.

Setup Mode is still the Root Lock kernel. You can copy the bundle there, and you can install packages and edit configuration there. The installer will not run there.

Follow the printed instructions. On many hosts that is a one-shot command such as `grub-reboot '…' && reboot` for **this** machine — copy it; do not invent a number. If the installer cannot pick an entry, it tells you to open the console and choose stock or Maintenance at the boot menu. After that boot, `uname -r` must not be a Root Lock release. Then run the installer again.

The first-install command `curl -fsSL https://get.heartsecsuite.com/get-heartsuite.sh | sudo sh` is for a host that does not yet have Root Lock. On a host already running the Root Lock kernel it downloads the bundle and then stops at the same refuse.

If Lockdown is applied (the strip says **Lockdown applied**), you need two different boots. Do not run the installer on the first one.

1. **Unseal.** From Maintenance (`[m]`), reboot at the console and select **Maintenance: unseal and return to Root Lock**. The seal lifts and the machine comes back by itself to the Root Lock kernel in Setup Mode. That trip across the maintenance kernel is short on purpose — you will not stay there, and the installer is not for that boot.
2. **Install.** When the Dashboard is in Setup Mode, reboot again and select Maintenance (or the original distro kernel the installer named). This time the machine stays off Root Lock. Log in and run `heartsuite-install.sh` there.

If you are already in Setup Mode, skip Unseal and take the Install boot. If `uname -r` is already the original distro kernel or the maintenance kernel, and the strip does not say **Lockdown applied**, skip both extra boots and run the installer. If you are on the maintenance kernel but the strip still says **Lockdown applied**, the immutable flags are still on the files — unseal first.

On the Install boot, Root Lock is not loaded: it does not block programs, does not log, and does not take backups. Choose a time when that gap is acceptable.

## Before you begin

- **Unseal first if Lockdown is applied.** From the Dashboard, open Maintenance (`[m]`) and follow the sealed path in [Protecting During Maintenance](../protecting-during-maintenance/). You must land in Setup Mode before a later maintenance-kernel boot will stay up.
- **Verify the bundle.** Compare the SHA-256 of `heartsuite-install.sh` against the published checksum before running it.
- **Physical or serial-console access** if the installer cannot name a boot entry, and for recovery if the new kernel does not boot.

## Update procedure

1. Place `heartsuite-install.sh` and `heartsuite-install.sh.sha256` on the system, typically by `scp` into `/root/`. In Setup Mode that copy is allowed. Under Lockdown it may be denied — unseal first.
2. If Lockdown is applied, open Maintenance (`[m]`) and complete the unseal path. You should be in Setup Mode on the Root Lock kernel before the next step.
3. If `uname -r` still names a Root Lock release, run `bash heartsuite-install.sh` once. It stops and prints the next boot. Follow that printout, or reboot and select the maintenance kernel (or the stock target the installer named) so the machine **stays** off the Root Lock kernel. After that boot, `uname -r` must not be a Root Lock release.
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

7. The installer applies the update and, by default, reboots into the new Root Lock kernel. You land in Setup Mode.
8. If new programs appear, they show in the review queues. Approve them through the Dashboard, then re-engage Lockdown (`[l]`) if it was active before the update.

## If the update fails

If the new Root Lock kernel does not boot, select the previous kernel from the GRUB menu. Physical or serial-console access is required for this step.

Both the previous Root Lock kernel and the maintenance kernel remain available as recovery entries. Contact HeartSuite support at [support@heartsecsuite.com](mailto:support@heartsecsuite.com) and include the contents of `/var/log/heartsuite/install.log` in your message — we're happy to help you recover.
