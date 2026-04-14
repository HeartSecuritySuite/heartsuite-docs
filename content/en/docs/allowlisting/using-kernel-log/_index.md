---
title: "Using the Kernel Log"
weight: 3
description: "Accessing permission errors in the kernel log with dmesg."
categories: ["Guides"]
tags: ["heartsuite", "linux", "logs", "kernel", "dmesg", "permissions"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "using-kernel-log"
---

**Overview**: The Dashboard and its review queues automatically process kernel log events alongside HeartSuite log events. The kernel log (`dmesg`) serves as a fallback for advanced troubleshooting when events do not appear in the HeartSuite activity log.

## Dashboard Handles Kernel Events Automatically

The Dashboard's review queues (Programs `[p]`, File Access `[f]`, Internet Access `[i]`) collect events from both the HeartSuite activity log and the kernel log. There is no need to read `dmesg` output manually during routine allowlisting — all events appear in the appropriate review queue with full metadata.

For details on the review process, see [Allowlisting Basics](../allowlisting-basics/).

## When to Use the Kernel Log Directly

Depending on the distribution, some permission events may appear only in the kernel log rather than in `/.hs/sys/hs-activity-log.txt`. The kernel log is useful as a fallback when:

- A program fails but no corresponding event appears in the HeartSuite activity log
- The HeartSuite activity log has been cleared or rotated
- Troubleshooting requires correlating HeartSuite events with other kernel messages

## Reading HeartSuite Messages from dmesg

To extract only HeartSuite-related messages from the kernel log:

```bash
# dmesg | grep HEARTSUITE
```

The output format matches the HeartSuite activity log entries. For example:

```text
[Setup Notice - Add program to Allowlist?] Not Whitelisted: /usr/bin/nano
[Setup Notice - Add to Allowlist?] File Access Attempt Logged: Program: /usr/bin/nano; File: /etc/ld.so.cache
[Setup Notice - Add to Network Allowlist?] Network Connection Attempt Logged by /usr/bin/wget; IP: 45.60.22.168
```

> [!NOTE]
> The kernel log is cleared on reboot. If events need to persist, the HeartSuite activity log at `/.hs/sys/hs-activity-log.txt` retains entries across reboots.

## Recommended Approach

| Scenario | Recommended approach |
|----------|---------------------|
| Routine allowlisting | Dashboard and review queues |
| Event missing from HeartSuite log | Check `dmesg` for kernel-level entries |
| Correlating with other kernel messages | `dmesg` with broader filtering |
| Post-reboot investigation | HeartSuite activity log (persists across reboots) |

Allow several days to a week of observation in Setup Mode. Systemd timers, cron jobs, and infrequent services may not generate events until they run. The review queues accumulate these events automatically as they occur.
