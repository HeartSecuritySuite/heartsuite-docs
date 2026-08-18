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

During maintenance you either switch to Setup Mode (the kernel logs but stops blocking) or boot the maintenance kernel (Root Lock is not loaded). The Dashboard's Maintenance (`[m]`) detects whether the immutable seal is active and guides you through the correct path.

For most maintenance — installing packages, applying patches, editing configuration — the correct path is switching to Setup Mode. That requires one reboot, stays on the Root Lock kernel, and needs no GRUB interaction. Booting the maintenance kernel is only required when Lockdown+sealed is active.

Maintenance appears only in Lockdown, Lockdown+sealed, or on the maintenance kernel. It is not shown in Setup Mode — you are already in the maintenance-ready state, and the Dashboard's review queues and Suggested Next Step are the workflow.

## In this section

- [Protecting During Maintenance](protecting-during-maintenance/) — Step-by-step guidance for maintenance windows, from the safety checklist through Lockdown recovery across two reboots.
- [File Backup and Versioning](file-backup-versioning/). Automatic versioned backups. Under Lockdown, root cannot reach them. Restore any earlier version from the Dashboard.
- [Cache Adjustment](cache-adjustment/) — Tuning the allowlist cache for servers with large numbers of concurrent programs.
- [Restricting Kernel Module Loading](kmod-hardening/) — Limiting kmod's access to specific modules for deployments where kmod is allowlisted.
- [Updating Root Lock](updating-heartsuite/) — Apply a Root Lock update bundle, including the two-reboot sequence and Lockdown considerations.
