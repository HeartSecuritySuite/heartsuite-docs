---
title: "Installing HeartSuite Core Secure – Part 2"
weight: 4
description: "Auto-allowlisting essential startup programs with hs-os-boot-setup."
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

After booting into the HeartSuite Core Secure kernel, the Dashboard appears on the console automatically. The **System Setup** screen opens on first boot.

Each cycle follows the same pattern:

1. Press `[a]` to run the setup step — HeartSuite Core Secure scans startup and shutdown logs and adds the programs it finds to the allowlist.
2. When the step completes, the system reboots automatically (5-second countdown — press any key to cancel if needed).
3. At the GRUB menu, select the HeartSuite Core Secure kernel again.
4. The Dashboard appears and the Suggested Next Step shows `[s] System Setup`. Press `[s]` to continue to the next step.

Repeat until the setup screen shows **Setup Complete** in green — no manual commands are needed between cycles.

After three to five cycles (depending on the distribution), the setup screen confirms that all startup and shutdown programs have been allowlisted.

> [!SCREENSHOT]
> **Screenshot needed**: System Setup screen — show the screen mid-cycle with the current step description and `[a]` action visible, then a second frame showing the **Setup Complete** confirmation in green. Both frames should show the step counter. Capture from the HeartSuite Core Secure kernel console.

## Returning to the Dashboard

When the setup screen shows the completion message, press `[q]` to return to the Dashboard. The Dashboard displays your current progress and the Suggested Next Step guides you into Phase 2 (Program Allowlisting).

## If the Dashboard Does Not Appear After Boot

If the Dashboard does not appear on the console after booting into the HeartSuite Core Secure kernel:

1. Switch to TTY2 (`Ctrl+Alt+F2`), log in as root, and check the service:
   ```bash
   systemctl status heartsuite-ui.service
   ```
2. Verify the HeartSuite Core Secure kernel is loaded:
   ```bash
   uname -r
   ```
   Expected output: `5.19.6-HeartSuite-1.0`
3. If the wrong kernel booted, reboot and select the correct entry from the GRUB menu.

## If the Setup Screen Does Not Progress

If after several cycles the setup screen does not show the completion message:

1. Check the Dashboard's Programs review queue (`[p]`) for any pending items and approve missing programs.
2. Verify the HeartSuite Core Secure kernel is loaded (the status line at the bottom of the Dashboard shows "Kernel: HS").

> [!WARNING]
> Completing these reboot-and-review cycles is essential before switching to Secure Mode. If the initial allowlist is incomplete, the system may hang on boot or shutdown after the mode switch.
