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

## Cloud Path and Local Path

### Cloud Path

When you launch a pre-installed HeartSuite Core Secure cloud instance, Phase 1 completes automatically on first boot. The Dashboard appears confirming HeartSuite Core Secure is active and suggesting the next step.

### Local Path

After completing the local installation process (download, GRUB preparation, kernel install, `hs-os-boot-setup` with its multiple reboots), the Dashboard appears once Phase 1 is complete. From here, both paths proceed identically.

## What the Dashboard Shows

When Phase 1 is complete, the Dashboard confirms:

- **Protection state** (indicator at the top): Shows **SETUP MODE** — HeartSuite Core Secure is active, logging only, nothing blocked
- **Phase Progress**: Shows Phase 1 as **Complete**
- **Status line at the bottom**: Shows kernel type (`HS`), current mode, time in mode, and lockdown status
- **Suggested Next Step**: Directs you to begin Phase 2: Program Allowlisting

No user action is required and no manual verification command is needed. The Dashboard confirms this automatically.

> [!SCREENSHOT]
> **Screenshot needed**: Dashboard in Setup Mode with Phase 1 complete — show the full terminal screen. Must include: SETUP MODE indicator at the top in high-contrast text, Phase 1 marked Complete in the phase progress, status line at the bottom showing `Kernel: HS`, and the Suggested Next Step pointing to Phase 2 Program Allowlisting.

## Protection State

The protection state indicator appears as a full-width, high-contrast bar at the top of the Dashboard. Its content depends on the current system state:

| State | Indicator |
|-------|-----------|
| Setup Mode | SETUP MODE — logging only, nothing is blocked |
| Secure Mode (no Lockdown) | SECURE MODE — Lockdown not applied |
| Secure Mode + Lockdown | No indicator (silence means safety) |
| Non-HS kernel | NON-HS KERNEL — HeartSuite Core Secure is not active. No enforcement. No logging. No backups. |

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
5. If the issue persists, contact support at support@heartsecsuite.com.

> [!NOTE]
> For advanced troubleshooting, you can verify kernel-level activation directly:
>
> ```bash
> dmesg | grep HEARTSUITE
> ```
>
> The Dashboard provides this same information in the protection state indicator and the status line at the bottom.
