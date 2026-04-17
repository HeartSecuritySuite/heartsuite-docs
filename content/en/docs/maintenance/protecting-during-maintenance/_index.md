---
title: "Protecting During Maintenance"
weight: 2
description: "Securing your server during maintenance windows to prevent attacks."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "protection"]
type: docs
toc: true
---

**Overview**: Every maintenance window is an attack window — enforcement is temporarily absent, and anything an attacker can reach during that period is unprotected. Maintenance — such as installing packages, editing files, or applying updates — is the period during which you temporarily reduce HeartSuite Core Secure's protection to make changes. The Dashboard's Maintenance screen (`[t]`) guides you through the entire process, from safety preparation to returning to Secure Mode. The Maintenance screen appears only when the system is in Secure Mode, Secure Mode + Lockdown, or on the Non-HS kernel — it is not shown in Setup Mode, because in Setup Mode you are already in the maintenance-ready state.

## Starting Maintenance

From the Dashboard in Secure Mode, select the Maintenance screen (`[t]`). The Dashboard automatically detects whether Lockdown is active and presents the correct path — you do not need to determine this yourself.

### Safety Checklist

Before any mode change, the Maintenance screen presents a safety checklist. The Dashboard auto-detects system state where possible and shows the status of each item:

- **Network isolation** — disable network interfaces or restrict firewall rules to prevent remote access during maintenance
- **Server processes** — shut down daemons (e.g., web servers) to close attack vectors
- **SSH access** — no root login, key-based auth only, source IP restriction

The Dashboard shows green checkmarks for items that pass and amber warnings for items that need attention. Press `[c]` Confirmed to proceed or `[s]` Skip to continue without completing the checklist. If you skip, the Dashboard displays a persistent reminder throughout the maintenance period — it does not disappear until you return to Secure Mode.

> [!SCREENSHOT]
> **Screenshot needed**: Maintenance screen (`[t]`) safety checklist — show the checklist with a mix of green checkmarks and at least one amber warning so both states are visible. The `[c]` Confirmed and `[s]` Skip options must be visible at the bottom.

> [!NOTE]
> The safety checklist is more critical for the Lockdown path (Option 2), where HeartSuite Core Secure will be completely absent. For the standard path (Option 1), HeartSuite Core Secure continues logging and running backups.

## Option 1: Switch to Setup Mode (No Lockdown)

This is the standard maintenance path. The HeartSuite Core Secure kernel stays active. Logging and backups remain fully operational.

After completing the safety checklist, the Maintenance screen explains what will change:

- Enforcement changes from blocking to logging only
- The HeartSuite Core Secure kernel remains active
- Backups continue running
- The existing allowlist is preserved
- New activity is logged, not blocked — it will appear in the review queues when you return to Secure Mode

Type `YES` (case-sensitive) to confirm the switch. The Dashboard reboots to apply the mode change.

After rebooting, the Dashboard shows Setup Mode is active with a Suggested Next Step. If the safety checklist was skipped, a persistent reminder appears. Make your changes — install packages, edit configuration, update software. HeartSuite Core Secure logs all new activity silently.

When finished, return to Secure Mode from the Dashboard. New activity from the maintenance period appears in the review queues. Review and approve them through the standard allowlisting flow before enforcement resumes.

## Option 2: Boot the Non-HS Kernel (Lockdown Active)

When Lockdown is active, the Maintenance screen does not offer the Setup Mode switch. Instead, it explains the situation and guides you through a 3-step process. This is the most complex journey in the product — it involves two reboots, a kernel selection at GRUB where the Dashboard cannot guide you, and a period where HeartSuite Core Secure is completely absent.

### Step 1 of 3: Boot Non-HS Kernel and Remove Immutable Flags

After the safety checklist and typing `YES` to confirm, the Dashboard prepares you for the GRUB boot menu — the one moment where it cannot provide guidance. It shows the exact Non-HS kernel name to select and warns you not to select the HeartSuite Core Secure kernel. Press `[r]` to reboot.

The Dashboard saves your maintenance session state before rebooting. This state persists across reboots and kernel changes — the step counter ("Step X of 3") follows you throughout the process.

After selecting the Non-HS kernel from GRUB, the Dashboard resumes automatically on login. It detects the absence of the HeartSuite Core Secure kernel module and adjusts its interface — actions that require the HeartSuite Core Secure kernel are hidden entirely, not greyed out. The Dashboard shows:

- "Non-HS kernel active. HeartSuite Core Secure is not loaded."
- "No enforcement. No logging. No backups."
- "Maintenance step 1 of 3: Remove immutable flags."

Press `[u]` to remove the immutable flags set by Lockdown. After the flags are removed, the Dashboard presents the automatic Lockdown re-engagement choice:

- `[d]` **Disable automatic Lockdown re-engagement** — the startup script will no longer apply Lockdown on boot. You can re-enable this later. This simplifies future maintenance.
- `[k]` **Keep automatic re-engagement** — Lockdown will re-apply on every HeartSuite Core Secure kernel boot. Future maintenance will require this same process.

Both options carry equal weight — neither is recommended over the other. The choice depends on your operational needs.

> [!NOTE]
> If you accidentally select the wrong kernel at GRUB (the HeartSuite Core Secure kernel instead of the Non-HS kernel), the Dashboard detects this and guides you to reboot and select the correct kernel.

### Step 2 of 3: Make Your Changes

The Dashboard transitions to the maintenance workspace:

- "Maintenance step 2 of 3: Make your changes."
- "You are on the Non-HS kernel. HeartSuite Core Secure is not active. Changes made now will not be logged."

Make your changes — install software, update packages, modify configuration files. When finished, press `[f]` to prepare the return to the HeartSuite Core Secure kernel. The Dashboard pre-configures Setup Mode for the next boot.

### Step 3 of 3: Boot HeartSuite Core Secure Kernel and Review

Select the HeartSuite Core Secure kernel from GRUB. The Dashboard appears automatically, showing Setup Mode is active and displaying the maintenance step counter. Software installed during maintenance may generate new entries — these appear in the review queues. Review and approve them, then return to Secure Mode from the Dashboard. If Lockdown was previously active and you kept automatic re-engagement, Lockdown will re-apply on the next reboot.

> [!WARNING]
> The Non-HS kernel provides no HeartSuite Core Secure protection whatsoever. The safety checklist is critical for this path.

> [!NOTE]
> You must have physical or serial port access to select the Non-HS kernel at the GRUB menu. This is intentional — it prevents an attacker from remotely booting to bypass HeartSuite Core Secure.

## Manual Recovery Outside the Maintenance Screen

When Lockdown makes files immutable using `chattr +i`, those flags are stored at the filesystem level and persist across reboots — including reboots to the Non-HS kernel. If you attempt to modify a file that was made immutable during a previous Lockdown session, you will encounter an error such as "could not open <filename> file; errno:1." The Maintenance screen's `[u]` Remove immutable flags handles this automatically during Step 1 of the Lockdown path. For manual recovery outside the maintenance wizard, run `hs-unlock`.
