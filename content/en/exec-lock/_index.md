---
title: "HeartSuite Exec"
linkTitle: "Exec (Prototype)"
description: "HeartSuite Exec is the HJFS interface for installing, updating, and selecting program versions. Prototype documentation. Kernel-level program and network control stays with Root Lock."
categories: ["Essentials"]
tags: ["heartsuite", "exec", "hjfs", "filesystem", "prototype"]
type: docs
toc: true
---

*HeartSuite Exec | Prototype*

---

> **Prototype**: HeartSuite Exec is the HJFS interface for installing, updating, and selecting program versions. Documentation reflects current design intent and will be updated as the product matures.

**Overview**: HeartSuite Exec is the filesystem UI for programs, next to HeartSuite Joint File System (HJFS). It works at the filesystem layer; kernel-level control of programs and network connections belongs to Root Lock by HeartSuite, the kernel product.

## What the product is

HJFS isolates each program's files on a stock kernel, entirely within the filesystem layer, and keeps executables in a separate area that only the official HJFS installer can write.

The official tools for that area today are `HJFS_update_program` (install a new program version) and `HJFS_version_manager` (list, check, and set the active version).

HeartSuite Exec is the intended UI for those program tools: install, update, and version selection against the HJFS Executables area. File isolation stays with HJFS, including the OS file-selection dialog already specified under [Advanced Protection](../hjfs/advanced-protection/).

HeartSuite Exec adds no kernel-level control over which programs execute or which network connections they open. For those controls, use [Root Lock](../rootlock/network/), which can share a host with HJFS on a Root Lock kernel; later network mediation is planned inside HJFS rather than as a companion product.

## Who uses which product

| Need | Product |
|------|---------|
| Kernel default-deny for programs, files, and outbound network on a general-purpose host | Root Lock |
| Per-program files on a stock kernel | HJFS; HeartSuite Exec is that product's program UI |

## See also

- [HJFS overview](../hjfs/introduction/hjfs-overview/)
- [HJFS architecture](../hjfs/architecture/)
- [Root Lock overview](../rootlock/introduction/heartsuite-overview/)
