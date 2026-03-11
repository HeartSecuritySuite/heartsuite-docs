---
title: "Whitelisting Programs"
weight: 40
description: "Adding programs to the whitelist for secure execution."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "whitelist", "security", "programs"]
toc: true
type: docs
---

**Overview**: Whitelisting tells HeartSuite which programs are safe to run and what they can access—without this, nothing works.

```mermaid
graph LR;
    A[Attempt to run program in Setup Mode] --> B[Check HeartSuite log or kernel log for errors];
    B --> C{What type of permission error?};
    C -->|Program not whitelisted| D["Add program: hs-whitelist-manager add -x /path/to/program"];
    C -->|File/Directory access denied| E["Add file/dir permissions: add -f /file or -d /dir (use W for write)"];
    C -->|Network access denied| F[Add IP address: add -n IP];
    D --> G[Test program again, repeat for all errors];
    E --> G;
    F --> G;
    G --> H[Whitelist complete for this program];
```

# Whitelisting Overview

HeartSuite requires whitelisting programs to allow them execution and access permissions. Start with the basics, then dive into using logs for fine-tuning, and explore batch tools for efficiency.

## Key Guides
- [Whitelisting Basics](whitelisting-basics/) - Introduction to adding programs and permissions.
- [Using the HeartSuite Log](using-heart-suite-log/) - Monitor and resolve access errors via the HeartSuite activity log.
- [Using the Kernel Log](using-kernel-log/) - Alternative log access for permission errors.
- [Batch Whitelisting Tools](batch-whitelisting-tools/) - Scripts and utilities for bulk whitelisting.
