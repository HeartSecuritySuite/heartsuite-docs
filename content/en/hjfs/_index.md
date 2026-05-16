---
title: "HeartSuite Joint File System"
linkTitle: "HJFS (Preview)"
description: "Prototype documentation for HeartSuite Joint File System (HJFS), a filesystem-based security layer."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "security", "prototype"]
toc: true
type: docs
---

---

*HeartSuite Joint File System | Prototype*

---

> **Prototype**: HJFS is under active development. Documentation reflects current design intent and is subject to change.

**Overview**: HeartSuite Joint File System (HJFS) is a filesystem-based security layer that enforces access control at the filesystem level — distinct from HeartSuite Core Secure's kernel-level enforcement model. HJFS is designed to protect data at rest by controlling which programs can read, write, or traverse specific filesystem paths, independently of kernel module availability. Where other security tools add enforcement layers on top of the existing OS model, HJFS changes the model itself.

## See it in action

{{< loom d972ad038c1549d5aceaccc1466659ee >}}

## Learn about HJFS

- [Introduction and Overview](introduction/) — Core concepts, design goals, and how HJFS differs from kernel-based enforcement.
- [Architecture and Compatibility](architecture/) — Technical implementation, OS support, application compatibility notes, and scope.
- [Advanced Protection](advanced-protection/) — The optional tier that adds OS-mediated file dialogs and internal/user file separation, requiring application updates.
- [Deployment Scenarios](deployment-scenarios/) — Where HJFS fits, where it fits alongside HeartSuite Core Secure, and where it does not apply.
- [How HJFS Compares](how-it-compares/) — What HJFS is not, what it complements, and how to decide between HJFS alone or with HeartSuite Core Secure.
- [Real-World Attack Containment](examples/) — How HJFS is designed to contain real-world malware, ransomware, and supply chain attacks.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers HeartSuite Joint File System prototype.*
