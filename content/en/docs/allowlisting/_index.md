---
title: "Allowlisting Programs"
weight: 40
description: "Adding programs to the allowlist for secure execution."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "security", "programs"]
toc: true
type: docs
---

**Overview**: By default, any program on a Linux server can execute, access any file, and connect to any destination. HeartSuite Core Secure controls all three per program — not per user, per program. Two different programs running under the same user get separate allowlist entries with separate permissions. The Dashboard guides you through each approval phase and tracks your progress.

Allowlisting spans three phases of the HeartSuite Core Secure setup process:

- **Phase 2 — Program Allowlisting** (`[p]`): Approve which programs are permitted to execute.
- **Phase 4 — File Access Allowlisting** (`[f]`): Approve which files and directories each program can read or write.
- **Phase 5 — Internet Access Allowlisting** (`[i]`): Approve which outbound internet destinations each program can reach.

Start from the Dashboard — it shows how many items are waiting in each queue and the Suggested Next Step directs you to whichever needs attention. The review queues manage volume through intelligent grouping, not blind bulk approval.

## In This Section

- [Allowlisting Basics](allowlisting-basics/) — Core procedures for reviewing and approving programs, file access, and network connections.
- [Batch Allowlisting Tools](batch-allowlisting-tools/) — Activity log format and CLI tools for scripted allowlisting workflows.
