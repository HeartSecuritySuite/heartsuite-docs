---
title: "Installing HeartSuite Core Secure – Part 2"
weight: 4
description: "Completing the System Setup to allowlist startup and shutdown programs."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "allowlisting", "script"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "installation-part2"
---

**Overview**: After rebooting into the HeartSuite Core Secure kernel, build the initial allowlist of startup and shutdown programs. This completes Phase 1 (System Verification) on the Local Path. The Dashboard then appears and guides you into Phase 2 (Program Allowlisting).

> [!NOTE]
> Cloud users skip this step. On a pre-configured cloud instance, the Dashboard confirms Phase 1 is complete on first boot.

## Building the Initial Allowlist

After booting into the HeartSuite Core Secure kernel, the Dashboard appears automatically — on the serial console (`/dev/ttyS0`, reached via `virsh console`, AWS/Azure/GCP serial console, or IPMI SOL) and equally in any SSH session you reconnect with while post-reboot work is pending. The **System Setup** opens on first boot.

Each cycle follows the same pattern:

1. Press `[a]` to run the setup step — HeartSuite Core Secure scans startup and shutdown logs and adds the programs it finds to the allowlist.
2. When the step completes, the system reboots automatically (5-second countdown — press any key to cancel if needed).
3. The system boots back into the HeartSuite Core Secure kernel automatically. The Dashboard appears and the Suggested Next Step shows `[s] System Setup`. Press `[s]` to continue to the next step.

Repeat until System Setup shows **Setup Complete** in green — no manual commands are needed between cycles.

After three to five cycles (depending on the distribution), System Setup confirms that all startup and shutdown programs have been allowlisted.

> [!SCREENSHOT]
> **Screenshot needed**: System Setup — show the screen mid-cycle with the current step description and `[a]` action visible, then a second frame showing the **Setup Complete** confirmation in green. Both frames should show the step counter. Capture from the HeartSuite Core Secure kernel console.

## Returning to the Dashboard

When System Setup shows the completion message, press `[q]` to return to the Dashboard. The Dashboard displays your current progress and the Suggested Next Step guides you into Phase 2 (Program Allowlisting).

## If the Dashboard Does Not Appear After Boot

If the Dashboard does not appear after booting into the HeartSuite Core Secure kernel:

1. Open the serial console (`virsh console <vm>` for KVM, AWS/Azure/GCP serial console, IPMI SOL, or a null-modem cable). The Dashboard auto-launches when a console client attaches. The graphical TTY1 (virt-manager, VNC, SPICE) shows a regular getty, not the Dashboard — the Dashboard is on the serial console by design.
2. Confirm the autologin is active on the serial console:
   ```bash
   systemctl status serial-getty@ttyS0.service
   ```
3. Verify the HeartSuite Core Secure kernel is loaded:
   ```bash
   uname -r
   ```
   Expected output ends in `.heartsuite` (for example, `6.18.23-HeartSuite-1.0`).
4. If the wrong kernel booted, reboot and select the HeartSuite kernel from the GRUB menu manually.

## If the Setup Screen Does Not Progress

If after several cycles System Setup does not show the completion message:

1. Check the Dashboard's Programs review queue (`[p]`) for any pending items and approve missing programs.
2. Verify the HeartSuite Core Secure kernel is loaded (the status line at the bottom of the Dashboard shows "Kernel: HS").

> [!WARNING]
> Completing these reboot-and-review cycles is essential before switching to Secure Mode. If the initial allowlist is incomplete, the system may hang on boot or shutdown after the mode switch.
