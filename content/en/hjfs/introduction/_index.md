---
title: "Introduction and overview"
weight: 10
description: "Overview of HeartSuite Joint File System, its design goals, and how it differs from kernel-based security."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "overview", "concepts"]
type: docs
toc: true
---

---

*HeartSuite Joint File System | Prototype*

---

**Overview**: By default, every program runs with the user's full file access rights. The OS grants this to any process — including malware and compromised software. HJFS changes that at the filesystem layer. Each program is confined to its own storage area. No other program can read or write its files. This holds even for programs running as root. HJFS works on a standard Linux kernel, so it is available wherever the HeartSuite kernel is not deployed. For execution and network blocking, HeartSuite Core Secure operates at the kernel level. The two products address different layers and can be used together.

## In this section

- [The security problem HJFS solves](security-problem/) — Why default OS file permissions enable malware damage and how HJFS closes that gap.
- [HJFS overview](hjfs-overview/) — Core mechanisms, per-version storage, secure file transfer, version management, and patents.
- [Walkthrough](walkthrough/) — A short CLI example showing per-version isolation and rollback in action.
- [What HJFS does and does not cover](limits/) — Where the file isolation boundary holds, where it does not, and what to use alongside it.
