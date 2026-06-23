---
title: "Verifying Installation and Basic Setup"
weight: 30
description: "Checking Root Lock by HeartSuite activation and initial configuration."
categories: ["Installation"]
tags: ["heartsuite", "linux", "verification", "testing", "setup"]
toc: true
type: docs
---

**Overview**: Phase 1 (System Verification) confirms that Root Lock by HeartSuite is active and the machine is ready for allowlisting. On the Cloud Path, the Dashboard confirms Phase 1 is complete on first boot. On the Local Path, the Dashboard confirms Phase 1 is complete once the installation process is done.

## Cloud Path and Local Path

### Cloud Path

When you launch a pre-installed Root Lock by HeartSuite cloud instance, the Dashboard confirms Phase 1 is complete on first boot and suggests the next step.

### Local Path

After completing the local installation process (download, GRUB preparation, kernel install, and the System Setup's multiple steps), the Dashboard appears once Phase 1 is complete. From here, both paths proceed identically.

## What the Dashboard shows

When Phase 1 is complete, the Dashboard confirms:

- **Protection state** (indicator at the top): Shows **SETUP MODE**: Root Lock by HeartSuite is active, logging only, nothing blocked
- **Phase Progress**: Shows Phase 1 as **Complete**
- **Status line at the bottom**: Shows the kernel indicator ("Root Lock" or "maintenance kernel"), current mode, time in mode, and lockdown status
- **Suggested Next Step**: Directs you to begin Phase 2: Program Allowlisting

No user action is required and no manual verification command is needed. The Dashboard confirms this automatically.

## Protection state

The protection state indicator appears as a full-width, high-contrast bar at the top of the Dashboard. Its content depends on the current system state:

| State | Indicator |
|-------|-----------|
| Setup Mode | SETUP MODE: logging only, nothing is blocked |
| Lockdown (no immutable seal) | LOCKDOWN: immutable seal not applied |
| Lockdown + sealed | No indicator (silence means safety) |
| maintenance kernel | maintenance kernel: Root Lock not active. No blocking. No logging. No backups. |

## Status line at the bottom

Below the protection state indicator, a status line shows:

```text
Root Lock    Setup Mode active for 3d 7h: logging only, nothing is blocked
```

- **Kernel indicator**: "Root Lock" (when the Root Lock by HeartSuite kernel is active) or "maintenance kernel" (when booted to the recovery kernel with no Root Lock by HeartSuite loaded)
- **Mode**: Setup Mode or Lockdown, with time in current mode
- **Lockdown**: `—` (Setup Mode), `Not applied` (Lockdown without immutable seal), or `Applied` (Lockdown with immutable seal)

## What to do if verification fails

If Phase 1 does not complete, or the indicator at the top shows a state you did not expect (for example, "maintenance kernel" when you intended to boot Root Lock by HeartSuite):

1. Check the status line at the bottom of the Dashboard. It shows the kernel indicator ("Root Lock" or "maintenance kernel"). If it shows the maintenance kernel, reboot and select the Root Lock by HeartSuite kernel from the GRUB menu.
2. Check that the Root Lock by HeartSuite systemd service is running:

   ```bash
   systemctl status heartsuite
   ```

3. For local installations, verify that the System Setup completed — it shows **Setup Complete** in green when all startup and shutdown programs have been allowlisted. If not, return to the System Setup and press `[a]` to run another step.
4. If the Dashboard shows "UNKNOWN STATE: protection status cannot be determined", follow the Suggested Next Step displayed on the Dashboard.
5. If the issue persists, contact support at support@heartsecsuite.com.

> [!NOTE]
> For advanced troubleshooting, you can verify kernel-level activation directly:
>
> ```bash
> dmesg | grep HEARTSUITE
> ```
>
> The Dashboard provides this same information in the protection state indicator and the status line at the bottom.

With Phase 1 confirmed, follow the Dashboard's Suggested Next Step to begin [Phase 2: Program Allowlisting](../allowlisting/).
