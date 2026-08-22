---
title: "The OS still treats every program as you"
linkTitle: "Introduction"
weight: 10
description: "File permissions are granted to users, not programs. HJFS isolates each program's files on a stock kernel. Start here for the prototype."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "overview", "concepts"]
type: docs
toc: true
---

---

*HeartSuite Joint File System | Prototype*

---

**Overview**: By default, every program you run gets full access to your files, including malware. HeartSuite Joint File System (HJFS) gives each program its own storage area, including programs running as root.

HJFS works on a standard Linux kernel. Which programs run and which network connections they open stay with [Root Lock by HeartSuite](../../docs/). On a Root Lock kernel, both can share the host. HJFS also runs on a standard unmodified kernel.

## In this section

- [The security problem HJFS solves](security-problem/) — Why default OS file permissions enable malware damage and how HJFS closes that gap.
- [HJFS overview](hjfs-overview/) — Core mechanisms, per-version storage, secure file transfer, version management, and patents.
- [Walkthrough](walkthrough/) — A short CLI example showing per-version isolation and rollback in action.
- [Protection limits](limits/) — Where the file isolation boundary holds, and what to use alongside it.
