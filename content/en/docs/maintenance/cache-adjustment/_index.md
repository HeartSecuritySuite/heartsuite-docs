---
title: "Adjusting the Cache Size"
weight: 3
description: "Tuning HeartSuite Core Secure's allowlist cache for optimal performance."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "cache", "performance", "tuning"]
type: docs
toc: true
---

**Overview**: HeartSuite Core Secure caches allowlist entries in kernel memory for performance. Each cache slot holds one unique program or script. The default size works for most systems; adjust it only if you have an unusually large number of concurrent programs.

This is an advanced CLI tool — no Dashboard equivalent exists.

```bash
# hs-cache-size --help
```

- Range: 10-255 entries.
- Tune based on your server's needs (more entries for varied workloads).