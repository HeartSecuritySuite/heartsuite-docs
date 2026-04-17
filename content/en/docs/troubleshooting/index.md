---
title: "Troubleshooting and Logs"
weight: 100
description: "Log management, dmesg analysis, and common issues."
categories: ["Support"]
tags: ["heartsuite", "linux", "logs", "issues", "help", "debugging"]
toc: true
type: docs
---

**Overview**: When something stops working on a locked-down system, the cause is usually one of three things: a missing allowlist entry, a mode mismatch, or a kernel issue. The Dashboard disambiguates all three — the indicator at the top shows the current protection state, and the Suggested Next Step tells you what to do. The kernel log is available for advanced diagnostics when needed.

## Where to Start

The Dashboard is the primary diagnostic tool. Before checking log files, review:

- **Protection state** (indicator at the top): Confirms the current protection level. If it shows "SETUP MODE", "SECURE MODE — Lockdown not applied", or "NON-HS KERNEL", you immediately know what protection level is active. No indicator means Secure Mode with Lockdown — full protection.
- **Status line at the bottom**: Shows kernel type (`HS` or `Non-HS`), current mode with uptime, and lockdown status.
- **Pending/Denied counts**: In Setup Mode, these are pending items awaiting approval. In Secure Mode, these are denied actions that may need allowlisting.
- **Suggested Next Step**: Provides a single, actionable recommendation based on the current system state.

> [!TIP]
> If you suspect a program is being blocked, check the Dashboard first. Denied items appear as counts on the Dashboard, grouped by category (Programs, File reads, File writes, Network). For example, if `nano` is blocked from executing, the Dashboard shows `Programs: 1 denied` and the Programs queue (`[p]`) presents it with full metadata for approval.

## Log Management

HeartSuite Core Secure captures all activity and presents it through the Dashboard's three review queues: Programs (`[p]`), File Access (`[f]`), and Internet Access (`[i]`). The Dashboard shows pending counts for each queue and groups items by category, so you always know what needs attention. The Maintenance screen (`[t]`) provides guided workflows for common maintenance tasks.

The review queues are how you see and resolve what needs attention. The underlying activity log is a temporary buffer — once all three review queues are empty, the Dashboard automatically clears the log on its next refresh. No manual action is required.

> [!NOTE]
> If the Dashboard shows zero pending items but a program is still failing, confirm whether the attempt was captured: `grep /path/to/program /.hs/sys/hs-activity-log.txt`. If the entry is missing there too, check `dmesg | grep HEARTSUITE` — some entries appear only in the kernel log depending on the distribution.

Allow several days to a week of observation in Setup Mode. Systemd timers, cron jobs, and infrequent services appear in the review queues only when they run — the review queues accumulate these automatically.

## Kernel Log (Advanced)

The Dashboard's review queues automatically collect entries from both the HeartSuite Core Secure activity log and the kernel log. During normal operation, you do not need to read `dmesg` directly.

The kernel log is useful for advanced troubleshooting in three situations: a program fails but the Dashboard shows zero pending or denied items for it; the HeartSuite Core Secure activity log has been cleared or rotated; or you need to correlate HeartSuite Core Secure entries with other kernel messages:

```bash
dmesg | grep HEARTSUITE
```

The Dashboard presents the same information with metadata enrichment and grouping. The Dashboard is accessible on both the HeartSuite Core Secure kernel and the Non-HS kernel — on the Non-HS kernel, the indicator at the top shows "NON-HS KERNEL" and enforcement is inactive.

## Reporting Issues

If you encounter a bug, open an issue on GitHub using the [Bug Report template](https://github.com/HeartSecuritySuite/heartsuite-core-secure/issues/new?template=bug-report.md). Include your HeartSuite Core Secure version, kernel version, the protection state shown at the top of your Dashboard, and steps to reproduce. For security vulnerabilities, email support@heartsecsuite.com.
