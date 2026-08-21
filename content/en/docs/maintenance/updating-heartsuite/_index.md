---
title: "Apply an update without dropping Lockdown blindly"
linkTitle: "Updating Root Lock"
weight: 6
description: "Unseal if Lockdown is applied, then run the bundle from a terminal in Setup Mode. Type YES to take one stock boot. The default stays Root Lock. You land in Setup Mode on the new kernel."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "kernel", "installer"]
type: docs
toc: true
---

**Overview**: A Root Lock by HeartSuite update is delivered as a single self-extracting bundle (`heartsuite-install.sh`) that replaces the kernel and its userspace tools in one operation.

## What an update changes

- The Root Lock kernel
- HeartSuite userspace tools (`activate_HS`, `lockdown_HS`, Secure Script Launchers, setup scripts)
- The Dashboard files under `/opt/heartsuite/`
- GRUB configuration, so the new kernel becomes the default boot target

It does not wipe user data, existing allowlist entries, or backup files. A complete overwrite still re-runs first-run setup (extra reboots) before the Dashboard returns. After the new kernel is up, new programs appear in the review queues for you to approve.

## Why the update needs a stock boot

The installer will not overwrite Root Lock while that kernel is booted. It checks `uname -r`. Setup Mode is still the Root Lock kernel. You can copy the bundle there, and you can install packages and edit configuration there.

You can also **start** `bash heartsuite-install.sh` there from a terminal. The installer asks you to type `YES` (case-sensitive). That sets the **next boot only** to the original distro kernel (stock) or Maintenance, keeps Root Lock as the default, and continues the update after that boot. You do not pick a menu entry, and you do not run the installer a second time.

If the session is not a terminal — for example `curl … | sudo sh` — the installer prints a one-shot command such as `grub-reboot '…' && reboot` for **this** machine instead of asking `YES`. Copy that command; do not invent a number. After that boot, run `bash heartsuite-install.sh` again. If the installer cannot name an entry, it tells you to open the console and choose stock or Maintenance at the boot menu.

The first-install command `curl -fsSL https://get.heartsecsuite.com/get-heartsuite.sh | sudo sh` is for a host that does not yet have Root Lock. On a host already running the Root Lock kernel it downloads the bundle and then follows the non-terminal path above.

If Lockdown is applied (the strip says **Lockdown applied**), unseal first. The installer cannot set the next boot while `/boot` is sealed.

- **Already in Setup Mode on the Root Lock kernel.** Skip Unseal. Place the bundle, verify the checksum, and run `bash heartsuite-install.sh` from a terminal. Type `YES`.
- **Already on the original distro kernel or the maintenance kernel, and the strip does not say Lockdown applied.** Skip Unseal and skip `YES`. Run the installer.
- **On the maintenance kernel but the strip still says Lockdown applied.** The immutable flags are still on the files. Unseal first.

On the stock or maintenance boot, Root Lock is not loaded: it does not block programs, does not log, and does not take backups. Choose a time when that gap is acceptable.

## Before you begin

- **Unseal first if Lockdown is applied.** From the Dashboard, open Maintenance (`[m]`) and follow the sealed path in [Protecting During Maintenance](../protecting-during-maintenance/). You must land in Setup Mode before the installer can set the next boot.
- **Verify the bundle.** Compare the SHA-256 of `heartsuite-install.sh` against the published checksum before running it.
- **Physical or serial-console access** if the installer cannot name a boot entry, and for recovery if the new kernel does not boot. You do not need the console only because you are in Setup Mode.

## Update procedure

1. Place `heartsuite-install.sh` and `heartsuite-install.sh.sha256` on the system, typically by `scp` into `/root/`. In Setup Mode that copy is allowed. Under Lockdown it may be denied — unseal first.
2. If Lockdown is applied, open Maintenance (`[m]`) and complete the unseal path. You should be in Setup Mode on the Root Lock kernel before the next step.
3. Verify integrity:

   ```bash
   sha256sum -c heartsuite-install.sh.sha256
   ```

   Expected output: `heartsuite-install.sh: OK`
4. Log in as root over SSH or the serial console (AWS EC2 Serial Console, Linode LISH, Hetzner, and others). On failure, inspect `/var/log/heartsuite/install.log` on the serial console.
5. Run the installer from that terminal:

   ```bash
   bash heartsuite-install.sh
   ```

6. If `uname -r` still names a Root Lock release, type `YES` when asked. The machine takes one stock or Maintenance boot and the installer continues from disk. The default stays Root Lock. If you are already off the Root Lock kernel, there is no `YES` step.
7. The installer applies the update and, by default, reboots into the new Root Lock kernel. You land in Setup Mode.
8. If new programs appear, they show in the review queues. Approve them through the Dashboard, then re-engage Lockdown (`[l]`) if it was active before the update.

## Many hosts

The in-place bundle is per host. After Lockdown, each sealed host still unseals from the console before the installer can set the next boot — `/boot` is sealed.

For many locked hosts, reprovision from an updated pre-configured image instead of running the bundle on each live machine. That path is equivalent for support when the image contains a published bundle. See [Kernel Support Policy](../../kernel-hardening/kernel-support-policy/#pre-configured-image-alternative) and [Enterprise Adoption Guide](../../kernel-hardening/enterprise-adoption-guide/#operational-model-for-fleets).

## If the update fails

If the new Root Lock kernel does not boot, select the previous kernel from the GRUB menu. Physical or serial-console access is required for this step.

Both the previous Root Lock kernel and the maintenance kernel remain available as recovery entries. Contact HeartSuite support at [support@heartsecsuite.com](mailto:support@heartsecsuite.com) and include the contents of `/var/log/heartsuite/install.log` in your message — we're happy to help you recover.
