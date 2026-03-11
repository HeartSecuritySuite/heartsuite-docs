---
title: "Adjusting the Cache Size"
weight: 3
description: "Tuning HeartSuite's whitelist cache for optimal performance."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "cache", "performance", "tuning"]
type: docs
toc: true
---


## Overview

HeartSuite caches whitelist entries for performance (each slot for a unique program/script).
- Use `hs-cache-size` to adjust at activation.
- Range: 10-255 entries.
- Tune based on your server's needs (more entries for varied workloads).