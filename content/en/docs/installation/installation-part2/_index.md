---
title: "Installing HeartSuite – Part 2"
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

**Overview**: After rebooting into the HeartSuite kernel, build the initial allowlist of startup and shutdown programs. This completes Phase 1 (System Verification) on the Local Path. The Dashboard then appears and guides you into Phase 2 (Program Allowlisting).

> [!NOTE]
> Cloud users skip this step. Phase 1 auto-completes on a pre-configured cloud instance, and the Dashboard is ready immediately.

## Building the Initial Allowlist

Launch the Dashboard:

```bash
sudo python3 main.py
```

The Installation screen appears. Press `[a]` to begin — the Installation screen runs the setup process, scans system logs for permission errors, and builds allowlist entries for essential startup and shutdown programs.

Reboot after each cycle, then re-launch the Dashboard (`sudo python3 main.py`) and press `[a]` again. New permission errors are generated on each boot as additional programs execute. The Installation screen directs you to reboot after each run.

After three to five cycles (depending on the distribution), the Installation screen reports that all OS startup and shutdown programs are allowlisted.

## After Phase 1 Completes

Once the Installation screen confirms completion, the Dashboard displays your current progress. The Suggested Next Step guides you into Phase 2 (Program Allowlisting), where you review and approve the programs your system needs to run.

## If the Installation Screen Does Not Progress

If after several cycles the Installation screen does not show the success message or you encounter errors:

1. Check the Dashboard for system status and pending items.
2. Check the Dashboard's Programs review queue (`[p]`) for any pending events and approve missing programs.
3. Verify that the HeartSuite kernel is loaded (the Dashboard System Info Strip shows "Kernel: HS").

> [!WARNING]
> Completing these reboot-and-review cycles is essential before switching to Secure Mode. If the initial allowlist is incomplete, the system may hang on boot or shutdown after the mode switch.
