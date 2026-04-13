---
title: "Allowlisting Programs"
weight: 40
description: "Adding programs to the allowlist for secure execution."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "security", "programs"]
toc: true
type: docs
---

**Overview**: Allowlisting tells HeartSuite which programs are safe to run and what they can access—without this, nothing works.

```mermaid
graph LR;
    A[Attempt to run program in Setup Mode] --> B[Check HeartSuite log or kernel log for errors];
    B --> C{What type of permission error?};
    C -->|Program not allowlisted| D["Review via dashboard or hs-review-programs (tiered queues with metadata)"];
    C -->|File/Directory access denied| E["Review via hs-review-files (read/write split, metadata prompts)"];
    C -->|Network access denied| F[Review via hs-review-network];
    D --> G[Test program again, repeat for all errors];
    E --> G;
    F --> G;
    G --> H[Allowlist complete for this program];
```

# Allowlisting Overview

HeartSuite requires allowlisting programs to allow them execution and access permissions. Start with the basics, then dive into using logs for fine-tuning, and explore batch tools for efficiency.

## Key Guides
- [Allowlisting Basics](allowlisting-basics/) - Introduction to adding programs and permissions.
- [Using the HeartSuite Log](using-heart-suite-log/) - Monitor and resolve access errors via the HeartSuite activity log (cross-ref to tiered hs-review tools).
- [Using the Kernel Log](using-kernel-log/) - Alternative log access for permission errors.
- [Batch Allowlisting Tools](batch-allowlisting-tools/) - Scripts and utilities for bulk allowlisting.
