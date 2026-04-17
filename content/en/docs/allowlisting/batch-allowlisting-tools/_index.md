---
title: "Batch Allowlisting Tools"
weight: 4
description: "Activity log format and CLI tools for scripted allowlisting workflows."
categories: ["Guides"]
tags: ["heartsuite", "linux", "batch", "allowlist", "tools", "logs"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "batch-allowlisting-tools"
---

**Overview**: The Dashboard review queues handle high-volume allowlisting for routine setup — grouped review, metadata enrichment, and intelligent grouping replace the need for batch scripts in most workflows. The tools below are for automation workflows and scripted deployments where direct log access and CLI management are required.

## Activity Log Format

The HeartSuite Core Secure activity log at `/.hs/sys/hs-activity-log.txt` is the input source for `batch_record_add.py`. It records every program execution, file access, and network connection in text format.

**Program executions:**

```text
[Setup Notice - Add program to Allowlist?] Not Whitelisted: /usr/bin/nano
```

**File accesses:**

```text
[Setup Notice - Add to Allowlist?] File Access Attempt Logged: Program: /usr/bin/nano; File: /etc/ld.so.cache
```

**Network connections:**

```text
[Setup Notice - Add to Network Allowlist?] Network Connection Attempt Logged by /usr/bin/wget; IP: 45.60.22.168
```

The log requires root access to read:

```bash
# cat /.hs/sys/hs-activity-log.txt
```

To filter for specific programs:

```bash
# grep nano /.hs/sys/hs-activity-log.txt
```

> [!NOTE]
> The Dashboard's review queues process these same log entries automatically with metadata enrichment and intelligent grouping. Use the raw log only when you need to verify specific entries or feed them to an automation script.

## batch_record_add.py (Advanced / Legacy)

For automation workflows or environments where scripted allowlisting is preferred, the `batch_record_add.py` utility creates allowlist entries from the HeartSuite Core Secure activity log in bulk. This tool is located in `/.hs/sys/`.

```bash
# /.hs/sys/batch_record_add.py
```

> [!WARNING]
> `batch_record_add.py` processes raw log entries without the metadata enrichment and intelligent grouping provided by the Dashboard review queues. Use it only when you have independently verified the entries in the log and understand what you are approving.

## hs-manage-allowlist (Advanced)

The `hs-manage-allowlist` command provides a browser and editor for existing allowlist entries. It is not a review tool — it operates on entries that have already been created. Use it to inspect, modify, or remove existing entries:

```bash
# hs-manage-allowlist --help
```

## Root Access

The `/.hs/sys` directory is owned by root. When working with batch tools or direct allowlist management, start a root shell to avoid permission issues:

```bash
# sudo -s
```

Exit the root shell by pressing Ctrl-D when finished.

## When to Use Each Tool

| Tool | Best for |
|------|----------|
| Dashboard review queues (grouped) | High-volume allowlisting with metadata and samples |
| Dashboard review queues (individual) | Careful, item-by-item review with full context |
| `batch_record_add.py` | Scripted automation, reproducible deployments |
| `hs-manage-allowlist` | Inspecting or modifying existing allowlist entries |
