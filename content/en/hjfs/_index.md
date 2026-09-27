---
title: "HeartSuite Joint File System"
linkTitle: "HJFS (Prototype)"
description: "HJFS gives each program its own files. A word processor can no longer open every document you own. Prototype documentation."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "security", "prototype"]
toc: true
type: docs
---

---

*HeartSuite Joint File System | Prototype*

---

> **Prototype**: HJFS is under active development. Documentation reflects current design intent and is subject to change.

**Overview**: Every program you run gets full access to your files by default, including malware. HeartSuite Joint File System (HJFS) changes this at the filesystem layer.

Each program has its own storage area, and no other program can read or write its files, including programs running as root. Isolation is per program and per version, so an update to a program cannot reach the files an earlier version created. HJFS enforces this inside the filesystem, so no custom kernel is required.

Which programs run and which network connections they open stay with [Root Lock by HeartSuite](../../rootlock/). HJFS runs on a standard unmodified kernel, and on a Root Lock kernel HJFS and Root Lock can share the host.

If you need to control which programs execute or which connections they open, that job belongs to Root Lock, or to existing host controls on a stock kernel. See [Deployment scenarios](deployment-scenarios/).

## See it in action

{{< loom d972ad038c1549d5aceaccc1466659ee >}}

## Learn about HJFS

- [Introduction and overview](introduction/) — Core concepts, design goals, and how HJFS differs from traditional file permission models.
- [Architecture and compatibility](architecture/) — Technical implementation, OS support, and application compatibility notes.
- [Advanced protection](advanced-protection/) — An optional level that adds system-managed file dialogs and separates internal from user files, requiring application updates.
- [Deployment scenarios](deployment-scenarios/) — Where HJFS fits, where it sits beside Root Lock, and where another control owns the workload.
- [How HJFS compares](how-it-compares/) — What HJFS isolates, what it complements, and when to run it alone versus beside Root Lock.
- [Attack examples](examples/) — How HJFS is designed to confine a separate encryptor or a tainted version, and what stays exposed when a compromised program damages files it already owns.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers HeartSuite Joint File System prototype.*
