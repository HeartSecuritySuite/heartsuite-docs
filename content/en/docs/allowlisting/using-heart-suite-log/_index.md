---
title: "Using HeartSuite Core Secure Log"
weight: 2
description: "Monitoring permission errors and adding program access via the HeartSuite Core Secure activity log."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "log", "security"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "using-heart-suite-log"
---

**Overview**: The Dashboard and its review queues are the primary way to review and resolve permission events. The HeartSuite Core Secure activity log (`/.hs/sys/hs-activity-log.txt`) is available for advanced troubleshooting and for understanding what the review queues process behind the scenes.

## Dashboard Review Tools (Primary)

The Dashboard shows pending event counts for each queue and provides a Suggested Next Step. Select a queue to begin reviewing.

The three review queues — Programs (`[p]`), File Access (`[f]`), and Internet Access (`[i]`) — parse log data automatically, enrich it with package metadata, and present events through the tiered review model. You do not need to read raw log files to complete allowlisting.

For details on the review process, single-key actions, and the tiered model, see [Allowlisting Basics](../allowlisting-basics/).

## The HeartSuite Core Secure Activity Log (Advanced)

The activity log at `/.hs/sys/hs-activity-log.txt` records all permission events in text format. It is useful for:

- Confirming that a specific program or file access was logged
- Troubleshooting when the Dashboard shows zero pending events but a program still fails
- Scripting and automation workflows that need raw event data

### Log Message Formats

**Program execution events:**

```text
[Setup Notice - Add program to Allowlist?] Not Whitelisted: /usr/bin/nano
```

**File access events:**

```text
[Setup Notice - Add to Allowlist?] File Access Attempt Logged: Program: /usr/bin/nano; File: /etc/ld.so.cache
```

**Network connection events:**

```text
[Setup Notice - Add to Network Allowlist?] Network Connection Attempt Logged by /usr/bin/wget; IP: 45.60.22.168
```

### Viewing the Log

The log requires root access to read:

```bash
# cat /.hs/sys/hs-activity-log.txt
```

To filter for specific programs:

```bash
# grep nano /.hs/sys/hs-activity-log.txt
```

> [!TIP]
> The review queues process these same log entries automatically with metadata enrichment and tiered grouping. Use the raw log only when you need to verify specific entries or troubleshoot unexpected behavior.

## When to Use the Raw Log

| Scenario | Recommended approach |
|----------|---------------------|
| Routine allowlisting | Dashboard and review queues |
| Checking whether a specific event was captured | Raw log with `grep` |
| Understanding why a program fails after allowlisting | Raw log to identify missing file or network permissions |
| Bulk scripting or automation | Raw log as input to `batch_record_add.py` (see [Batch Allowlisting Tools](../batch-allowlisting-tools/)) |
