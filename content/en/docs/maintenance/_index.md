---
title: "Advanced Configuration and Maintenance"
weight: 90
description: "Cache adjustments, file system modifications, and maintenance procedures."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "updates", "security", "advanced"]
toc: true
---

**Overview**: Use these procedures to configure advanced settings and perform maintenance safely, avoiding security gaps and protecting against attacks. The Dashboard displays the current system state — including lockdown status — and provides the Suggested Next Step throughout maintenance.

Maintenance is a time period during which you temporarily reduce HeartSuite's protection to make changes. It is not a separate mode. HeartSuite has two modes: Setup Mode and Secure Mode. During maintenance, you either switch to Setup Mode or boot the Non-HS kernel depending on whether Lockdown is active — the Dashboard's Maintenance screen (`[t]`) detects this automatically and guides you through the correct path.

The Maintenance screen appears only when the system is in Secure Mode, Secure Mode + Lockdown, or on the Non-HS kernel. It is not shown in Setup Mode — because in Setup Mode, you are already in the maintenance-ready state and the Dashboard's review queues and Suggested Next Step are the workflow.

## Key Maintenance Areas
Explore detailed guides for specific tasks:
- [Avoiding Configuration Gaps](avoiding-configuration-gaps/) - Handling maintenance tools and broad permissions.
- [Protecting During Maintenance](protecting-during-maintenance/) - Secure practices for updates, backups, and access control.
- [File Backup and Versioning](file-backup-versioning/) - Automatic backups for designated directories and version restoration to protect against malware.
- [Cache Adjustment](cache-adjustment/) - Tuning the allowlist cache for performance.
