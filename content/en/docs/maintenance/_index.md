---
title: "Advanced Configuration and Maintenance"
weight: 90
description: "How to perform maintenance safely on a HeartSuite Core Secure system, from Setup Mode transitions to Lockdown recovery."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "security", "advanced"]
toc: true
---

**Overview**: Every maintenance window is an attack window — in Setup Mode the kernel logs but stops blocking, or on the Non-HS kernel HeartSuite Core Secure is not loaded at all, while changes are made. These guides cover how to perform maintenance safely without leaving gaps an attacker can exploit. The Dashboard displays the current protection state — including Lockdown status — and provides the Suggested Next Step throughout maintenance.

Maintenance is a time period during which you temporarily step out of Lockdown to make changes. It is not a separate mode. HeartSuite Core Secure has two modes: Setup Mode and Lockdown. During maintenance, you either switch to Setup Mode (the kernel logs but stops blocking) or boot the Non-HS kernel (HeartSuite Core Secure is not loaded at all) depending on whether the immutable seal is active — the Dashboard's Maintenance (`[t]`) detects this automatically and guides you through the correct path.

The Maintenance appears only when the system is in Lockdown, Lockdown+sealed, or on the Non-HS kernel. It is not shown in Setup Mode — because in Setup Mode, you are already in the maintenance-ready state and the Dashboard's review queues and Suggested Next Step are the workflow.

## In this section

- [Protecting During Maintenance](protecting-during-maintenance/) — Step-by-step guidance for maintenance windows, from the safety checklist through Lockdown recovery across two reboots.
- [File Backup and Versioning](file-backup-versioning/) — Automatic versioned backups that even root cannot reach under Lockdown — restore any earlier version of a file when needed.
- [Cache Adjustment](cache-adjustment/) — Tuning the allowlist cache for servers with large numbers of concurrent programs.
- [Restricting Kernel Module Loading](kmod-hardening/) — Limiting kmod's access to specific modules for deployments where kmod is allowlisted.
