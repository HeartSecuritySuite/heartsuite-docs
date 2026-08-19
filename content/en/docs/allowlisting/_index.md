---
title: "Approve what each program may do"
linkTitle: "Allowlisting Programs"
weight: 40
description: "Linux lets any program run, read any file, and connect anywhere. Root Lock requires an allowlist entry for all three — per program, not per user."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "security", "programs"]
toc: true
type: docs
menu:
  main:
    identifier: "allowlisting"
    weight: 25
---

**Overview**: By default, any program on a Linux server can execute, access any file, and connect to any destination. Root Lock by HeartSuite controls all three per program — not per user.

Two different programs running under the same user get separate allowlist entries with separate permissions. The Dashboard guides you through each approval and tracks your progress.

The Dashboard Lockdown Checklist shows three review queues, then Secure Script Launchers as a separate row (not a queue):

1. **Program Allowlisting** (`[p]`): Approve which programs are permitted to execute.
2. **File Access Allowlisting** (`[f]`): Approve which files and directories each program can read or write.
3. **Internet Access Allowlisting** (`[i]`): Approve which outbound internet destinations each program can reach.
4. **Secure Script Launchers** (`[s]`): Give each Python, Perl, or PHP script its own allowlist entry. See [Script Launchers](../script-launchers/).

Start from the Dashboard — it shows how many items are waiting in each queue and the Suggested Next Step directs you to whichever needs attention. The review queues manage volume through intelligent grouping, not blind bulk approval.

## In this section

- [Allowlisting Basics](allowlisting-basics/) — Core procedures for reviewing and approving programs, file access, and network connections.
- [Batch Allowlisting Tools](batch-allowlisting-tools/) — Activity log format and CLI tools for scripted allowlisting workflows.
