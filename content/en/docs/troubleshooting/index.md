---
title: "Troubleshooting and Logs"
weight: 100
description: "Log management, dmesg analysis, and common issues."
categories: ["Support"]
tags: ["heartsuite", "linux", "logs", "issues", "help", "debugging"]
toc: true
type: docs
---

**Overview**: If issues arise, use the Dashboard for system status, alerts, and suggested next steps, or check logs for errors. Clear logs periodically to avoid clutter.

```mermaid
graph TD;
    A[System issue occurs] --> B{System fails to boot?};
    B -->|Yes| C[Boot into recovery mode or alternate kernel];
    C --> D["Check kernel log: dmesg | grep HEARTSUITE"];
    D --> E{Switched to Secure mode without full allowlist?};
    E -->|Yes| F["Switch back to Setup mode: hs-mode-switch setup"];
    E -->|No| G[Add missing permissions based on logs];
    B -->|No| H["Check HeartSuite log: `/.hs/sys/hs-activity-log.txt`"];
    H --> I{Permission errors present?};
    I -->|Yes| J[Allowlist missing programs/files/networks];
    I -->|No| K[Other issues: Clear logs periodically, check dmesg for activation status];
    F --> L[Test boot again];
    G --> L;
    J --> M[Test operation];
    K --> M;
```

## Log Management

While running, HeartSuite always attempts to capture permission errors to the HeartSuite log, `/.hs/sys/hs-activity-log.txt`. Initially, it will report programs that are executed and that are not allowlisted. The Dashboard surfaces these as structured alerts with suggested next steps.

Because error messages can quickly accumulate in the HeartSuite log, a simple utility permits you to easily clear the log. Run the following command as root to clear the log:

```bash
# /.hs/sys/empty_HS_log.sh
```

Further, by leaving your server running continuously, the HeartSuite and kernel logs will eventually capture information about the programs executed in conjunction with systemd timers and cron jobs.

## Kernel Log Analysis

Depending on your distro, some permission error messages may not appear in the HeartSuite log; instead, they are placed in the kernel log. You can easily obtain the kernel log with the following command, which may require root privilege:

```bash
# dmesg
```

In order to readily extract only the HeartSuite messages, use grep:

```bash
# dmesg | grep HEARTSUITE
```
