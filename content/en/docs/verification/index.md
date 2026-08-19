---
title: "Confirm the Root Lock kernel is actually running"
linkTitle: "Verification"
weight: 30
description: "Initial setup checks that you booted the Root Lock kernel and the Dashboard is ready. What complete looks like on cloud and on local."
categories: ["Installation"]
tags: ["heartsuite", "linux", "verification", "testing", "setup"]
toc: true
type: docs
---

**Overview**: Initial setup confirms that Root Lock by HeartSuite is active and the machine is ready for allowlisting. Installer and initial setup logs are in `/var/log/heartsuite/` and accessible via provider serial console (AWS, Linode, Hetzner, and others).

## What complete looks like

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
When you launch a pre-installed Root Lock cloud instance, the Dashboard confirms initial setup is complete on first boot and suggests the next step. Use the serial console to `cat /var/log/heartsuite/install.log` if you need the installer or initial setup logs from the image build.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
After completing the local installation process (download, GRUB preparation, kernel install, and unattended initial setup), the Dashboard appears. From here, both paths proceed identically.
{{< /choice-card >}}
{{< /choice-pane >}}

## What the Dashboard shows

When initial setup is complete, the Dashboard confirms:

- **Protection state** (indicator at the top): Shows **SETUP MODE**: Root Lock is active, logging only, nothing blocked
- **Checklist**: Starts at Program Allowlisting (initial setup is already done; it is not a Dashboard row)
- **Status line at the bottom**: Shows the kernel indicator ("Root Lock" or "maintenance kernel"), current mode, time in mode, and lockdown status
- **Suggested Next Step**: Directs you to begin program allowlisting

## Protection state

The protection state indicator appears as a full-width, high-contrast bar at the top of the Dashboard. Its content depends on the current system state:

| State | Indicator |
|-------|-----------|
| Setup Mode | SETUP MODE: logging only, nothing is blocked |
| Lockdown (no immutable seal) | LOCKDOWN: immutable seal not applied |
| Lockdown + sealed | Lockdown applied |
| maintenance kernel | maintenance kernel: Root Lock not active. No blocking. No logging. No backups. |

## Status line at the bottom

Below the protection state indicator, a status line shows:

```text
Root Lock    Setup Mode active for 3d 7h: logging only, nothing is blocked
```

- **Kernel indicator**: "Root Lock" (when the Root Lock kernel is active) or "maintenance kernel" (when booted to the recovery kernel with no Root Lock loaded)
- **Mode**: Setup Mode or Lockdown, with time in current mode
- **Lockdown**: `—` (Setup Mode), `Not applied` (Lockdown without immutable seal), or `Applied` (Lockdown with immutable seal)

## What to do if verification fails

If initial setup does not complete, or the indicator at the top shows a state you did not expect (for example, "maintenance kernel" when you intended to boot Root Lock):

1. Check the status line at the bottom of the Dashboard. It shows the kernel indicator ("Root Lock" or "maintenance kernel"). If it shows the maintenance kernel, reboot and select the Root Lock kernel from the GRUB menu.
2. Check that the Root Lock systemd service is running:

   ```bash
   systemctl status heartsuite
   ```

3. For local installations, the Dashboard appears only after unattended initial setup finishes. If it has not appeared, check `/var/log/heartsuite/install.log` on the serial console. There is no System Setup screen.
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

With initial setup confirmed, follow the Dashboard's Suggested Next Step to begin [program allowlisting](../allowlisting/).
