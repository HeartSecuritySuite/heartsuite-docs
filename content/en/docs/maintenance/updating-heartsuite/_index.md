---
title: "Updating HeartSuite"
weight: 5
description: "How to apply a HeartSuite update bundle, including the two-reboot sequence and Lockdown considerations."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "kernel", "installer"]
type: docs
toc: true
---

**Overview**: A HeartSuite update is delivered as a single self-extracting bundle (`heartsuite-install.sh`) that replaces the HeartSuite Root Lock kernel and its userspace tools in one operation.

## What an update changes

- The HeartSuite Root Lock kernel (`vmlinuz-<version>-HeartSuite-<patch>`)
- HeartSuite userspace tools (`activate_HS`, `lockdown_HS`, Secure Script Launchers, setup scripts)
- The Dashboard files under `/opt/heartsuite/`
- GRUB configuration, so the new kernel becomes the default boot target

It does not modify user data, the existing allowlist entries, or backup files. HeartSuite Root Lock may add new allowlist entries if the new kernel encounters programs that were not running under the previous kernel.

## Why two reboots are required

The running HeartSuite Root Lock kernel cannot replace itself. The installer verifies this and aborts if it detects it is running on the HeartSuite Root Lock kernel. An update therefore requires:

1. A reboot from the HeartSuite Root Lock kernel to the Non-HS kernel.
2. Running the installer on the Non-HS kernel.
3. A reboot back into the new HeartSuite Root Lock kernel.

HeartSuite Root Lock is not active while the Non-HS kernel is running. Schedule updates during a planned maintenance window.

## Before you begin

- **Disengage Lockdown if it is active.** Lockdown uses `chattr +i` filesystem immutability on HeartSuite configuration files; the installer cannot replace them while Lockdown is engaged. From the Dashboard, open Maintenance (`[t]`) and follow the guided path to disengage.
- **Verify the bundle.** Compare the SHA-256 of `heartsuite-install.sh` against the published checksum before running it.

## Update procedure

1. Place `heartsuite-install.sh` and `heartsuite-install.sh.sha256` on the system, typically by `scp` into `/root/`.
2. Verify integrity:

   ```bash
   sha256sum -c heartsuite-install.sh.sha256
   ```

   Expected output: `heartsuite-install.sh: OK`
3. Reboot and select the Non-HS kernel at the GRUB menu.
4. Log in as root over SSH or the serial console.
5. Run the installer:

   ```bash
   bash heartsuite-install.sh
   ```

6. The installer applies the update and reboots automatically into the new HeartSuite Root Lock kernel.
7. If new programs are encountered, HeartSuite Root Lock reads the startup logs, adds the programs it finds to the allowlist, and reboots as needed (Phase 1). The Dashboard appears when this is complete.
8. Re-engage Lockdown from the Dashboard if it was active before the update.

## If the update fails

If the new HeartSuite Root Lock kernel does not boot, select the previous kernel from the GRUB menu. Physical or serial-console access is required for this step. Both the previous HeartSuite Root Lock kernel and the Non-HS kernel remain available as recovery entries. Contact HeartSuite support and include the contents of `/var/log/heartsuite/install.log` in your message — we're happy to help you recover.
