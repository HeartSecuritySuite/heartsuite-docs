---
title: "Batch Allowlisting Tools"
weight: 4
description: "Tools for bulk allowlisting programs and managing logs."
categories: ["Guides"]
tags: ["heartsuite", "linux", "batch", "allowlist", "tools", "logs"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "batch-allowlisting-tools"
---

**Overview**: The Dashboard review queues handle high-volume allowlisting through Tier 2 grouped review, which is the modern equivalent of batch processing. Legacy batch scripts remain available for advanced users and automation workflows.

## Tier 2 Grouped Review (Primary)

The review queues group related events automatically. For example, when a program generates hundreds of file read events from the same directory tree, Tier 2 presents them as a single group with a sample of the individual entries. This allows directory-level approval without reviewing each file individually -- and without blind bulk approval, because a sample is always shown.

To start a grouped review session, select the queue with pending events from the Dashboard. The `[v]` View all action is always available within a grouped review for users who want complete visibility before approving.

For details on the tiered model and single-key actions, see [Allowlisting Basics](../allowlisting-basics/).

## batch_record_add.py (Advanced / Legacy)

For automation workflows or environments where scripted allowlisting is preferred, the `batch_record_add.py` utility creates allowlist entries from the HeartSuite activity log in bulk. This tool is located in `/.hs/sys/`.

```bash
# /.hs/sys/batch_record_add.py
```

> [!WARNING]
> `batch_record_add.py` processes raw log entries without the metadata enrichment and tiered grouping provided by the Dashboard review queues. Use it only when you have independently verified the events in the log and understand what you are approving.

## hs-manage-allowlist (Advanced)

The `hs-manage-allowlist` command provides a browser and editor for existing allowlist entries. It is not a review tool -- it operates on entries that have already been created. Use it to inspect, modify, or remove existing entries:

```bash
# hs-manage-allowlist --help
```

## Root Access Considerations

The `/.hs/sys` directory is owned by root. When working with batch tools or direct allowlist management, start a root shell to avoid permission issues:

```bash
# sudo -s
```

Exit the root shell by pressing Ctrl-D when finished.

## Choosing the Right Approach

| Approach | Best for |
|----------|----------|
| Dashboard review queues (Tier 2 grouped) | High-volume allowlisting with metadata and samples |
| Dashboard review queues (Tier 1 individual) | Careful, per-event review with full context |
| `batch_record_add.py` | Scripted automation, reproducible deployments |
| `hs-manage-allowlist` | Inspecting or modifying existing allowlist entries |
