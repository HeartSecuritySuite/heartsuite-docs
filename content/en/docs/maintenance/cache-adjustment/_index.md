---
title: "When 255 allowlist slots is not enough"
linkTitle: "Adjusting the Cache Size"
weight: 4
description: "The Dashboard expands the kernel allowlist cache up to 255. Larger allowlists stay valid; the cache keeps the most recently used entries."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "cache", "performance", "tuning"]
type: docs
toc: true
author: Ron Hessing
---

**Overview**: Root Lock by HeartSuite caches allowlist entries in kernel memory for lookup speed. The cache is an LRU window, not a limit on how many programs you may approve. The Dashboard expands that window toward your allowlist size, up to 255 entries. Allowlists larger than 255 stay valid; the kernel evicts the least recently used cache slots.

Manual sizing is optional. You do not have to prune the allowlist when it grows past 255.

## Automatic cache expansion

On startup and every state refresh, the Dashboard compares the size of your allowlist against the current kernel cache size. If the allowlist is larger, the Dashboard silently expands the cache — up to 255 entries. The minimum cache size is 10.

This runs in the background on the Dashboard's normal 60-second refresh cycle. You do not need to invoke a CLI tool or change a setting.

## When the allowlist is larger than 255

Auto-expansion stops at 255. The extra allowlist entries remain in force; they are not refused. The kernel keeps the most recently used 255 in the cache.

Pruning unused programs in Allowed (`[a]`) is hygiene, not a hard stop. After you remove entries, the next Dashboard refresh can shrink the working set the cache has to hold.

There is no Dashboard warning of the form "Allowlist has 312 entries but kernel cache max is 255."

## CLI access for scripting and automation

For scripting and automation that runs without the Dashboard, set the cache to a size between 10 and 255 with the on-disk tool:

```bash
# /.hs/sys/hs-APO-cache-size 128
```

Docs and older notes may say `hs-cache-size`. That is the glossary name; the binary on disk is `hs-APO-cache-size`.

The Dashboard is the supported path for normal use.
