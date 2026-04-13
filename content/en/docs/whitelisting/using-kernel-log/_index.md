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

## Introduction to using the kernel log

Depending on your distro, some permission error messages may not appear in the HeartSuite log; instead, they are placed in the kernel log. The hs-review-* tools process kernel events automatically with tiered queues and metadata (per UX §§8.1,11).

In order to readily extract only the HeartSuite messages, use grep:

```bash
# dmesg | grep HEARTSUITE
```

Use the dashboard or hs-review-* tiered queues (per UX §§8.1,8.2,11).

Please note that the tiered review queues with metadata prompts avoid raw logs and blind bulk (per UX §§8.1-8.2,8.9,11,13.5,14). Therefore, it is strongly recommended that you use the review queues from the dashboard. Specifically, we recommend that you begin with hs-review-programs, hs-review-files and hs-review-network. We have found that it can take several days, possibly a week, to capture all of the relevant events involving processes run by systemd timers and cron jobs. Once this essential information is captured, we strongly recommend that you switch to other means. Primarily, we strongly recommend that you use the tiered queues so that you can tailor access permissions to a “need-to-access” basis only. If you have several programs that require similar permissions, the grouped tier-2 reviews handle this safely with samples and metadata. Finally, you can use the review tools to review the access permissions of all programs and restrict them on the basis of need-to-access.
