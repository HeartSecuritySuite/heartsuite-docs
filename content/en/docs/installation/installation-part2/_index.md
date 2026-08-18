---
title: "Installing Root Lock by HeartSuite – Part 2"
weight: 4
description: "Root Lock by HeartSuite builds the initial allowlist automatically after the first boot. The Dashboard appears when setup is complete."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "allowlisting", "script"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part2"
---

**Overview**: No commands are needed after the first boot into the Root Lock by HeartSuite kernel. Root Lock reads the startup and shutdown logs and adds the programs it finds to the allowlist — the Dashboard appears when this is complete and directs you into allowlisting.

> [!NOTE]
> Cloud users often skip live initial setup. On a pre-configured cloud instance, the Dashboard confirms initial setup completed during image build. Logs from that build-time process are in /var/log/heartsuite/ and accessible via the provider's serial console.

## What happens after the first boot

Root Lock reads the startup and shutdown logs, adds the programs it finds to the allowlist, and reboots. This repeats until no new programs are found — typically three to five passes, depending on the distribution.

**While initial setup is running, you will see:**

- **Over SSH**: each time you reconnect, the login shows a brief status line and drops you at a regular shell — no action needed:

  ```
  HeartSuite initial setup is running — step N.
  The system reboots automatically. Reconnect in a few minutes.
  ```

- **On the serial console** (virsh console, AWS EC2 Serial Console or Get system log, Linode LISH, Azure Serial Console, GCP serial, Hetzner console, etc.): attach and press Enter — the console autologs in as root and shows the current step or banner. No action needed. To inspect logs: `cat /var/log/heartsuite/install.log` (bundle phase) or `cat /var/log/heartsuite/initial-setup-latest.log`.

The first time you connect and the Dashboard appears, initial setup is complete. The Dashboard shows the reboot history.

## If the Dashboard does not appear

If initial setup is still running, SSH reconnects show the status line above instead of the Dashboard. Wait a few minutes and reconnect.

If repeated reconnects still show the status line rather than the Dashboard:

1. Open the serial console (virsh console, AWS EC2 Serial Console / Get system log, Linode LISH, etc.) and press Enter. Run these to inspect:

   ```bash
   journalctl -t heartsuite
   cat /var/log/heartsuite/install.log          # bundle installer phase
   cat /var/log/heartsuite/initial-setup-latest.log   # or ls /var/log/heartsuite/ for step logs
   ```

2. Verify the Root Lock kernel is loaded:

   ```bash
   uname -r
   ```

   Expected output ends in `HeartSuite`.
3. If the wrong kernel booted, reboot and select the Root Lock kernel from the GRUB menu manually (requires serial console access on cloud).

## If setup stops with an error

If something goes wrong during setup, the next login (SSH or serial console) shows an error with the reason and log location.

Two options are available:

- **`[r]` Retry** — restarts the setup from where it stopped.
- **`[q]` Open shell** — drops you to a shell to investigate before retrying. On cloud provider dashboards, view/download logs directly (e.g., AWS CloudWatch after agent setup via SSM, or Get system log; see Appendices for step-by-step without SSH/console).

> [!WARNING]
> Setup must complete before you activate Lockdown. If the initial allowlist is incomplete, the system may hang on boot or shutdown after activating Lockdown.

When the Dashboard appears and initial setup is complete, continue to [Verifying Installation](../../verification/).
