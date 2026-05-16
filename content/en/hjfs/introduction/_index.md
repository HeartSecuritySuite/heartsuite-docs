---
title: "Introduction and Overview"
weight: 10
description: "Overview of HeartSuite Joint File System, its design goals, and how it differs from kernel-based security."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "overview", "concepts"]
type: docs
toc: true
menu:
  main:
    identifier: "hjfs-introduction"
    weight: 15
---

---

*HeartSuite Joint File System | Prototype*

---

**Overview**: HJFS enforces access control at the filesystem layer — controlling which programs can read, write, or traverse specific paths — without requiring a modified kernel. This makes it deployable on standard kernels where HeartSuite Core Secure's kernel-level enforcement is not available.

## In this section

- [The Security Problem HJFS Solves](security-problem/) — The OS design flaw behind malware damage, why layered defenses don't fix it, and how HJFS does.
- [HJFS Overview](hjfs-overview/) — Core mechanisms, per-version storage, secure file transfer, version management, and patents.
- [Walkthrough](walkthrough/) — A short CLI example showing per-version isolation and rollback in action.
- [What HJFS Does and Does Not Cover](limits/) — Where the file isolation boundary holds, where it does not, and what to use alongside it.
