---
title: "Adjusting the Cache Size"
weight: 3
description: "Tuning HeartSuite Core Secure's allowlist cache for optimal performance."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "cache", "performance", "tuning"]
type: docs
toc: true
---

**Overview**: HeartSuite Core Secure caches allowlist entries in kernel memory for performance. Each cache slot holds one unique program or script. The default size works for most systems; adjust it only if you have an unusually large number of concurrent programs. This is a CLI-only setting — no Dashboard equivalent exists.

The cache size accepts values from 10 to 255 entries. Increase it on servers with highly varied workloads; leave it at the default on most systems.

```bash
# hs-cache-size --help
# hs-cache-size --set 128
```