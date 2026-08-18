---
title: "HeartSuite Joint File System"
linkTitle: "HJFS (Preview)"
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

Every program the user runs gets full access to the user's files by default — including any malware present.

HeartSuite Joint File System (HJFS) changes this at the filesystem layer. Each program is confined to its own storage area. No other program can read or write its files, including programs running as root. HJFS controls which files each program can read or write, tracked per program and per version. No custom kernel is required.

HJFS does not control which programs run or which network connections they open. Those are [Root Lock by HeartSuite](../../docs/)'s domain. HJFS and Root Lock address different problems and can be deployed together.

If the primary requirement is execution control or network connection control, HJFS is not the right fit on its own. See [Deployment scenarios](deployment-scenarios/) for fit and non-fit by environment.

## See it in action

{{< loom d972ad038c1549d5aceaccc1466659ee >}}

## Learn about HJFS

- [Introduction and overview](introduction/) — Core concepts, design goals, and how HJFS differs from traditional file permission models.
- [Architecture and compatibility](architecture/) — Technical implementation, OS support, and application compatibility notes.
- [Advanced protection](advanced-protection/) — An optional level that adds system-managed file dialogs and separates internal from user files, requiring application updates.
- [Deployment scenarios](deployment-scenarios/) — Where HJFS fits, where it fits alongside Root Lock, and where it does not apply.
- [How HJFS compares](how-it-compares/) — What HJFS is not, what it complements, and how to decide between HJFS alone or with Root Lock.
- [Real-world attack containment](examples/) — How HJFS is designed to contain real-world malware, ransomware, and supply chain attacks.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers HeartSuite Joint File System prototype.*
