---
title: "Verifying Installation and Basic Setup"
weight: 30
description: "Checking HeartSuite Core Secure activation and initial configuration."
categories: ["Installation"]
tags: ["heartsuite", "linux", "verification", "testing", "setup"]
toc: true
type: docs
---

**Overview**: Phase 1 (System Verification) confirms that HeartSuite Core Secure is active and the system is ready for allowlisting. On the Cloud Path, this phase completes automatically on first boot. On the Local Path, it completes automatically once the installation process is done.

## What the Dashboard Shows

When Phase 1 is complete, the Dashboard confirms:

- The protection state indicator at the top shows **SETUP MODE** — HeartSuite Core Secure is active, logging only, nothing blocked
- Phase 1 shows as **Complete** in the phase progress
- The status line at the bottom shows **Kernel: HS**
- The Suggested Next Step directs you to begin Phase 2: Program Allowlisting

No user action is required. The Dashboard confirms this automatically.

## How Phase 1 Completes

### Cloud Path

When you launch a pre-installed HeartSuite Core Secure cloud instance, Phase 1 completes automatically on first boot. The Dashboard appears with a welcome message confirming HeartSuite Core Secure is active and suggesting the next step.

### Local Path

After completing the local installation process (download, GRUB preparation, kernel install, `hs-os-boot-setup` with its multiple reboots), the Dashboard appears once Phase 1 is complete. From here, both paths proceed identically.

## Verifying via the Dashboard

The Dashboard provides immediate verification of activation, current mode, and phase status. It shows:

- **Protection state** (indicator at the top): Displays the current protection level
- **Phase Progress**: Shows Phase 1 as Complete, In Progress, or Not Started
- **Status line at the bottom**: Shows kernel type, current mode, time in mode, and lockdown status
- **Suggested Next Step**: Directs you to begin allowlisting once verification is complete

No manual verification command is required. The Dashboard surfaces HeartSuite Core Secure state automatically.

## Protection State

The protection state indicator appears as a full-width, high-contrast bar at the top of the Dashboard. Its content depends on the current system state:

| State | Banner |
|-------|--------|
| Setup Mode | SETUP MODE -- logging only, nothing is blocked |
| Secure Mode (no Lockdown) | SECURE MODE -- Lockdown not applied |
| Secure Mode + Lockdown | No banner (silence means safety) |
| Non-HS kernel | NON-HS KERNEL -- HeartSuite Core Secure is not active. No enforcement. No logging. No backups. |

## Status Line at the Bottom

Below the protection state indicator, a status line shows:

```text
Kernel: HS    Mode: Setup — active for 3d 7h    Lockdown: —
```

- **Kernel**: `HS` (HeartSuite Core Secure kernel) or `Non-HS` (standard kernel)
- **Mode**: Setup or Secure, with time in current mode
- **Lockdown**: `—` (Setup Mode), `Not applied` (Secure Mode without Lockdown), or `Applied` (Secure Mode with Lockdown)

## What to Do if Verification Fails

If Phase 1 does not complete, or the indicator at the top shows a state you did not expect (for example, "NON-HS KERNEL" when you intended to boot HeartSuite Core Secure):

1. Check the status line at the bottom of the Dashboard — it shows the kernel type (`HS` or `Non-HS`). If it shows `Non-HS`, reboot and select the HeartSuite Core Secure kernel from the GRUB menu.
2. Check that the HeartSuite Core Secure systemd service is running:

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
> The Dashboard provides this same information in the protection state indicator and the status line at the bottom.
