---
title: "Allowlisting Programs"
weight: 40
description: "Adding programs to the allowlist for secure execution."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "security", "programs"]
toc: true
type: docs
---

**Overview**: Allowlisting defines which programs can run, which files they can access, and which network destinations they can reach. The Dashboard guides you through each allowlisting phase and tracks your progress.

```mermaid
graph TD
    A[Dashboard] --> B[Phase 2: Programs queue]
    A --> C[Phase 4: File Access queue]
    A --> D[Phase 5: Internet Access queue]
    B --> E[Approve or skip each event]
    C --> E
    D --> E
    E --> F[Dashboard updates pending counts]
```

Allowlisting spans three phases of the HeartSuite Core Secure setup process:

- **Phase 2 -- Program Allowlisting** (`[p]`): Approve which programs are permitted to execute.
- **Phase 4 -- File Access Allowlisting** (`[f]`): Approve which files and directories each program can read or write.
- **Phase 5 -- Internet Access Allowlisting** (`[i]`): Approve which outbound internet destinations each program can reach.

The Dashboard is the entry point for all three phases. It shows pending event counts for each queue and provides a Suggested Next Step that directs you to the queue that needs attention. Each review queue is a screen within the Dashboard that uses a tiered model: individual events with full metadata (Tier 1), grouped events with samples (Tier 2), and informational summaries (Tier 3).

## Key Guides

- [Allowlisting Basics](allowlisting-basics/) -- Core procedures for reviewing and approving programs, file access, and network connections.
- [Using the HeartSuite Core Secure Log](using-heart-suite-log/) -- Advanced troubleshooting with the HeartSuite Core Secure activity log.
- [Using the Kernel Log](using-kernel-log/) -- Fallback log access for events not captured in the HeartSuite Core Secure log.
- [Batch Allowlisting Tools](batch-allowlisting-tools/) -- Legacy scripts and advanced utilities for bulk allowlisting.
