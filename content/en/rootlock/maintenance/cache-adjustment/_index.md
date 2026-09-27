---
title: "When 255 allowlist slots is not enough"
linkTitle: "Adjusting the Cache Size"
weight: 4
description: "The Dashboard expands the kernel allowlist cache up to 255. Larger allowlists stay valid; the cache keeps the most recently used entries."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "cache", "performance", "tuning"]
type: docs
aliases:
  - /docs/maintenance/cache-adjustment/
toc: true
---

**Overview**: Root Lock by HeartSuite caches allowlist entries in kernel memory for lookup speed. The cache is an LRU window: its size sets how many entries stay in fast kernel memory, while the number of programs you may approve is unaffected. The Dashboard expands that window toward your allowlist size, up to 255 entries. Allowlists larger than 255 stay valid, and the kernel evicts the least recently used cache slots.

Because the Dashboard sizes the cache for you, manual sizing is optional, and you can let the allowlist grow past 255 without pruning it.

## Automatic cache expansion

On startup and every state refresh, the Dashboard compares the size of your allowlist against the current kernel cache size. If the allowlist is larger, the Dashboard silently expands the cache — up to 255 entries. The minimum cache size is 10.

This runs in the background on the Dashboard's normal 60-second refresh cycle. You do not need to invoke a CLI tool or change a setting.

## When the allowlist is larger than 255

Auto-expansion stops at 255. Entries beyond that remain in force, and the kernel keeps the 255 most recently used in the cache.

Pruning unused programs in Allowed (`[a]`) is good hygiene rather than a requirement: after you remove entries, the next Dashboard refresh can shrink the working set the cache has to hold.

The Dashboard shows no warning when the allowlist grows past the 255-entry cache.

## CLI access for scripting and automation

For scripting and automation that runs without the Dashboard, set the cache to a size between 10 and 255 with the on-disk tool:

```bash
# /.hs/sys/hs-APO-cache-size 128
```

Some docs and older notes call this tool `hs-cache-size`, its glossary name; the binary on disk is `hs-APO-cache-size`.

For normal use, let the Dashboard size the cache, because it re-checks the allowlist size on every refresh.
