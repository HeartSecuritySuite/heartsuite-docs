---
title: "Verifying Installation and Basic Setup"
weight: 30
description: "Checking HeartSuite activation and initial configuration."
categories: ["Installation"]
tags: ["heartsuite", "linux", "verification", "testing", "setup"]
toc: true
type: docs
---

**Overview**: Phase 1 (System Verification) confirms that HeartSuite is active and the system is ready for allowlisting. On most paths, this phase completes automatically.

## What Phase 1 Checks

System Verification validates the following conditions:

- The HeartSuite kernel is loaded and active
- The system is in Setup Mode (logging only, nothing blocked)
- Core HeartSuite services are running
- The allowlist database is accessible

These checks confirm that the system is ready. No user action is required — Phase 1 completes automatically when all conditions are met.

## Cloud vs Local Verification

**Cloud Path**: When you launch a pre-installed HeartSuite cloud instance, Phase 1 completes automatically on first boot. The Dashboard appears with a welcome message confirming HeartSuite is active and suggesting the next step.

**Local Path**: After completing the local installation process (download, GRUB preparation, kernel install, `hs-os-boot-setup` with its multiple reboots), the Dashboard appears once Phase 1 conditions are met. Both paths merge at the Dashboard after Phase 1.

## Verifying via the Dashboard

The Dashboard provides immediate verification of activation, current mode, and phase status. It shows:

- **Safety Banner**: Displays current system state at the top of the screen
- **Phase Progress**: Shows Phase 1 as Complete, In Progress, or Not Started
- **System Info Strip**: Displays kernel type, current mode, time in mode, and lockdown status
- **Suggested Next Step**: Directs you to begin allowlisting once verification is complete

No manual verification command is required. The Dashboard surfaces HeartSuite state automatically.

## Safety Banner States

The Safety Banner appears as a full-width, high-contrast bar at the top of the Dashboard. Its content depends on the current system state:

| State | Banner |
|-------|--------|
| Setup Mode | SETUP MODE -- logging only, nothing is blocked |
| Secure Mode (no Lockdown) | SECURE MODE -- Lockdown not applied |
| Secure Mode + Lockdown | No banner (silence means safety) |
| Non-HS kernel | NON-HS KERNEL -- HeartSuite is not active. No enforcement. No logging. No backups. |

## System Info Strip

Below the Safety Banner, the System Info Strip provides orientation at a glance:

```text
Kernel: HS    Mode: Setup — active for 3d 7h    Lockdown: —
```

- **Kernel**: `HS` (HeartSuite kernel) or `Non-HS` (standard kernel)
- **Mode**: Setup or Secure, with time in current mode
- **Lockdown**: `—` (Setup Mode), `Not applied` (Secure Mode without Lockdown), or `Applied` (Secure Mode with Lockdown)

## What to Do if Verification Fails

If Phase 1 does not complete, or the Safety Banner shows a state you did not expect (for example, "NON-HS KERNEL" when you intended to boot HeartSuite):

1. Check the Dashboard's System Info Strip — it shows the kernel type (`HS` or `Non-HS`). If it shows `Non-HS`, reboot and select the HeartSuite kernel from the GRUB menu.
2. Check that the HeartSuite systemd service is running:

   ```bash
   systemctl status heartsuite
   ```

3. For local installations, verify that all `hs-os-boot-setup` steps completed. `hs-os-boot-setup` uses a step counter across reboots — run it again and check the output.
4. If the Dashboard shows "UNKNOWN STATE — protection status cannot be determined", follow the Suggested Next Step displayed on the Dashboard.
5. If the issue persists, we're happy to help — contact support at support@heartsecsuite.com.

> [!NOTE]
> For advanced troubleshooting, you can verify kernel-level activation directly:
>
> ```bash
> dmesg | grep HEARTSUITE
> ```
>
> The Dashboard provides this same information in the Safety Banner and System Info Strip.
