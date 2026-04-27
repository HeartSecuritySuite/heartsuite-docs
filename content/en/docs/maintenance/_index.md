---
title: "Advanced Configuration and Maintenance"
weight: 90
description: "How to perform maintenance safely on a HeartSuite Core Secure system, from Setup Mode switches to Lockdown recovery."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "security", "advanced"]
toc: true
---

**Overview**: Every maintenance window is an attack window — in Setup Mode the kernel logs but stops blocking, or on the Non-HS kernel HeartSuite Core Secure is not loaded at all, while changes are made. These guides cover how to perform maintenance safely without leaving gaps an attacker can exploit. The Dashboard displays the current system state — including Lockdown status — and provides the Suggested Next Step throughout maintenance.

Maintenance is a time period during which you temporarily step out of Secure Mode to make changes. It is not a separate mode. HeartSuite Core Secure has two modes: Setup Mode and Secure Mode. During maintenance, you either switch to Setup Mode (the kernel logs but stops blocking) or boot the Non-HS kernel (HeartSuite Core Secure is not loaded at all) depending on whether Lockdown is active — the Dashboard's Maintenance screen (`[t]`) detects this automatically and guides you through the correct path.

The Maintenance screen appears only when the system is in Secure Mode, Secure Mode + Lockdown, or on the Non-HS kernel. It is not shown in Setup Mode — because in Setup Mode, you are already in the maintenance-ready state and the Dashboard's review queues and Suggested Next Step are the workflow.

## In This Section

- [Avoiding Configuration Gaps](avoiding-configuration-gaps/) — How to restrict maintenance tools like `rm` during Lockdown so a compromised approved program cannot use them to do damage in high-security environments.
- [Protecting During Maintenance](protecting-during-maintenance/) — Step-by-step guidance for maintenance windows, from the safety checklist through Lockdown recovery across two reboots.
- [File Backup and Versioning](file-backup-versioning/) — Automatic versioned backups that even root cannot reach under Lockdown — restore any earlier version of a file when needed.
- [Cache Adjustment](cache-adjustment/) — Tuning the allowlist cache for servers with large numbers of concurrent programs.
