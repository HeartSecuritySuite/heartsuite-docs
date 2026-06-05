---
title: "Adjusting the Cache Size"
weight: 3
description: "How HeartSuite Root Lock auto-tunes its allowlist cache, and when manual intervention is needed."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "cache", "performance", "tuning"]
type: docs
toc: true
author: Ron Hessing
---

**Overview**: HeartSuite Root Lock caches allowlist entries in kernel memory for performance — each cache slot holds one program. The Dashboard automatically expands the cache to match your allowlist size, so for most systems no tuning is needed. Manual adjustment is only relevant when the allowlist exceeds the kernel cache maximum of 255 entries.

## Automatic cache expansion

On startup and every state refresh, the Dashboard compares the size of your allowlist against the current kernel cache size. If the allowlist is larger, the Dashboard silently expands the cache to fit — up to the kernel maximum of 255 entries. The minimum cache size is 10 entries.

This runs in the background on the Dashboard's normal 60-second refresh cycle. You do not need to invoke any CLI tool, change any settings, or even know the current cache size — the Dashboard handles it whenever it loads or refreshes.

## When the allowlist exceeds 255 entries

If your allowlist grows beyond 255 entries — unusual for most workloads, but possible on servers running many distinct programs — auto-expansion stops at the kernel maximum. The Dashboard logs a warning:

```text
Allowlist has 312 entries but kernel cache max is 255; consider removing unused entries.
```

The Allowed (`[a]`) is the place to review and remove entries you no longer need. After pruning, the Dashboard's next refresh fits the cache to your trimmed allowlist automatically.

## CLI access for scripting and automation

For scripting and automation workflows that run without the Dashboard, `hs-cache-size` sets the cache to a specific size between 10 and 255:

```bash
# hs-cache-size 128
```

The Dashboard is the supported path for normal use.
