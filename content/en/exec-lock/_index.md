---
title: "HeartSuite Exec"
linkTitle: "Exec"
description: "HeartSuite Exec is the filesystem UI for programs, next to HJFS. Root Lock is the kernel product."
categories: ["Essentials"]
tags: ["heartsuite", "exec", "hjfs", "filesystem"]
type: docs
toc: true
---

> **Proposal**: HeartSuite Exec has no engineering underway. This page records the intended product only. There is no release timeline.

**Overview**: HeartSuite Exec is the filesystem UI for programs, next to HeartSuite Joint File System (HJFS). Root Lock by HeartSuite is the kernel product.

HeartSuite Exec is not Root Lock, and it is not a kernel slice.

## What the product is

HJFS isolates each program's files on a stock kernel. It operates entirely within the filesystem layer. Executables live in a separate area.

The official tools for that area today are `HJFS_update_program` (install a new program version) and `HJFS_version_manager` (list, check, and set the active version).

HeartSuite Exec is the planned UI for those program tools: install, update, and version selection against the HJFS Executables area. File isolation stays with HJFS, including the OS file-selection dialog already specified under [Advanced Protection](../hjfs/advanced-protection/).

HeartSuite Exec does not add kernel execution gates. It does not add kernel network gates. [Root Lock network controls](../docs/network/) are not compatible with HJFS today; later network mediation is planned inside HJFS, not as a companion product.

## Who uses which product

| Need | Product |
|------|---------|
| Kernel default-deny for programs, files, and outbound network on a general-purpose host | Root Lock |
| Per-program files on a stock kernel | HJFS; HeartSuite Exec is that product's program UI |

## Current status

This product is a proposal. No engineering work has begun and no release timeline exists.

## See also

- [HJFS overview](../hjfs/introduction/hjfs-overview/)
- [HJFS architecture](../hjfs/architecture/)
- [Root Lock overview](../docs/introduction/heartsuite-overview/)
