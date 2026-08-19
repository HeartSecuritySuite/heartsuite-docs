---
title: "Every maintenance window is an attack window"
linkTitle: "Maintenance"
weight: 90
description: "Setup Mode logs but stops blocking; the maintenance kernel unloads Root Lock. How to make changes without leaving a hole."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "security", "advanced"]
toc: true
---

**Overview**: Every maintenance window is an attack window. In Setup Mode the kernel logs but stops blocking. On the maintenance kernel, Root Lock by HeartSuite is not loaded at all.

These guides cover how to make changes without leaving a hole an attacker can use. The Dashboard shows the current protection state — including Lockdown status — and the Suggested Next Step throughout maintenance.

Maintenance is a time period during which you temporarily step out of Lockdown to make changes. It is not a separate mode. Root Lock has two modes: Setup Mode and Lockdown.

The Dashboard's Maintenance (`[m]`) detects whether the immutable seal is active and opens the matching path.

- **Seal not applied.** Type `YES` and reboot once. You stay on the Root Lock kernel in Setup Mode. No GRUB pick.
- **Seal applied (the usual path after the first Lockdown).** Physical or serial console is required. Reboot and select **Maintenance: unseal and return to Root Lock**. The seal lifts automatically and the machine returns to Setup Mode on the Root Lock kernel. That is two reboots before you can install software or edit sealed files.

The Maintenance grid button is shown in Lockdown. Keyboard `[m]` also works in Setup Mode after you have unsealed.

## In this section

- [Protecting During Maintenance](protecting-during-maintenance/) — Console unseal after Lockdown, then install software or edit files in Setup Mode and lock down again.
- [File Backup and Versioning](file-backup-versioning/) — Automatic versioned backups on the Root Lock kernel. Under Lockdown the kernel is intended to keep other programs off those versions. Restore any earlier version from Backup.
- [Cache Adjustment](cache-adjustment/) — The allowlist cache is an LRU window the Dashboard expands for you. Manual sizing is optional.
- [Restricting Kernel Module Loading](kmod-hardening/) — Narrow kmod's file access before Lockdown. Seal prep can auto-narrow directory grants under `/lib/modules`.
- [Updating Root Lock](updating-heartsuite/) — Unseal first, stay on the maintenance kernel to run the bundle, then return to the new Root Lock kernel.
