---
title: "Installing Root Lock by HeartSuite – Part 2"
weight: 4
description: "Root Lock by HeartSuite builds the initial allowlist automatically after the first boot. The Dashboard appears when setup is complete."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "allowlisting", "script"]
type: docs
aliases:
  - /docs/installation/installation-part2/
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part2"
---

**Overview**: No commands are needed after the first boot into the Root Lock by HeartSuite kernel. Root Lock reads the startup and shutdown logs and adds the programs it finds to the allowlist — the Dashboard appears when this is complete and directs you into allowlisting.

> [!NOTE]
> Cloud users skip live initial setup. On a pre-configured cloud instance, the Dashboard confirms initial setup completed during image build. Installer and initial setup logs from the image build are in `/var/log/heartsuite/` and accessible via the provider's serial console.

## What happens after the first boot

Root Lock reads the startup and shutdown logs, adds the programs it finds to the allowlist, and reboots. This repeats until no new programs are found — typically three to five passes, depending on the distribution.

**While initial setup is running, you will see:**

- **Over SSH**: each time you reconnect, the login shows a brief status line and drops you at a regular shell — no action needed:

  ```
  HeartSuite initial setup is running — step N.
  The system reboots automatically. Reconnect in a few minutes.
  ```

- **On the serial console** (virsh console, AWS EC2 Serial Console or Get system log, Linode LISH, Azure Serial Console, GCP serial, Hetzner console, etc.): attach and press Enter — the console autologs in as root and shows the current step or banner. No action needed. To inspect logs: `cat /var/log/heartsuite/install.log` (installer) or `cat /var/log/heartsuite/initial-setup-latest.log`.

The first time you connect and the Dashboard appears, initial setup is complete. The Dashboard shows the reboot history.

## Leave the host quiet

After the first reboot into the Root Lock kernel, leave the machine alone until the Dashboard appears. Each SSH reconnect shows a status line and a shell. Root Lock is still adding startup and shutdown programs from those boots.

## What already landed on the allowlist

When the Dashboard appears, Root Lock has already added the programs that executed at boot and shutdown. The Dashboard checklist starts at Program Allowlisting. In Setup Mode, Root Lock then logs the rest of the workload.

Package-install helpers, compilers, and one-shot probes that executed during those unattended boots are already allowlist entries even if they never execute again.

## Run the services you will keep

Start the services this host will keep. Do not run throwaway tests, compilers, or extra shells. In the review queues, approve programs that belong on this host. Dismiss the one-shots as approving them grants them under Lockdown. [Allowlisting Basics](../../allowlisting/allowlisting-basics/) covers **approve** and **skip**.

Setup Mode after the Dashboard is for that kept workload. After Lockdown, add software through [Protecting During Maintenance](../../maintenance/protecting-during-maintenance/).

## Cloud leftovers

On Cloud Path, Root Lock already finished initial setup during image preparation. First-boot leftovers (cloud-init, provisioning helpers) may still appear in the queues. Do not approve them if they are not runtime.

Cloud images often ship a first-boot SSH policy that allows password login so you can reach the guest. After first boot, running sshd is typically key-only. Check the live sshd configuration, for leftover cloud-init snippets.

## If the Dashboard does not appear

If initial setup is still running, SSH reconnects show the status line above instead of the Dashboard. Wait a few minutes and reconnect.

If repeated reconnects still show the status line rather than the Dashboard:

1. Open the serial console (virsh console, AWS EC2 Serial Console / Get system log, Linode LISH, etc.) and press Enter. Run these to inspect:

   ```bash
   journalctl -t heartsuite
   cat /var/log/heartsuite/install.log          # installer log
   cat /var/log/heartsuite/initial-setup-latest.log   # or ls /var/log/heartsuite/ for step logs
   ```

2. Verify the Root Lock kernel is loaded:

   ```bash
   uname -r
   ```

   Expected output ends in `HeartSuite`.
3. If the wrong kernel booted, reboot and select the Root Lock kernel from the GRUB menu manually (requires serial console access on cloud).

If the issue persists, contact HeartSuite support at [support@heartsecsuite.com](mailto:support@heartsecsuite.com) and include `/var/log/heartsuite/install.log` and `/var/log/heartsuite/initial-setup-latest.log` — we're happy to help.

## If setup stops with an error

If something goes wrong during setup, the next login (SSH or serial console) shows an error with the reason and log location.

Two options are available:

- **`[r]` Retry** — restarts the setup from where it stopped.
- **`[q]` Open shell** — drops you to a shell to investigate before retrying. On the serial console, `cat /var/log/heartsuite/install.log` or `cat /var/log/heartsuite/initial-setup-latest.log`. AWS **Get system log** is a serial buffer, not CloudWatch. CloudWatch needs the platform agent plus IAM; Root Lock does not install it.

> [!WARNING]
> Setup must complete before you activate Lockdown. If the initial allowlist is incomplete, the system may hang on boot or shutdown after activating Lockdown.

If retry does not clear the error, contact HeartSuite support at [support@heartsecsuite.com](mailto:support@heartsecsuite.com) and include the log path shown on the error screen — we're happy to help.

When the Dashboard appears and initial setup is complete, continue to [Verifying Installation](../../verification/).
