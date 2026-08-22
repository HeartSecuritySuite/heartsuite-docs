---
title: "Where per-program file isolation fits"
linkTitle: "Deployment scenarios"
weight: 15
description: "When HJFS alone is enough, when it should sit beside Root Lock, and when a different control is the right one for the workload."
categories: ["Essentials"]
tags: ["hjfs", "deployment", "scenarios", "compatibility", "use-cases"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: HeartSuite Joint File System (HJFS) isolates files per program on a stock kernel, including as root. Which programs run and which network connections they open stay Root Lock's domain.

On a Root Lock kernel, both can share the host. HJFS also runs on a standard unmodified kernel.

## Where HJFS fits

### Desktop and workstation environments

The HJFS isolation model maps directly onto what desktop programs need: each program confined to its own storage area, with no path between them. A word processor cannot touch a browser's files, and neither can reach files belonging to any other program.

With [Advanced protection](../advanced-protection/), user-facing documents are opened only through an OS-mediated dialog, so you choose which files each program can access.

### Multi-user systems

On systems with multiple user accounts, HJFS layers per-user isolation on top of per-program and per-version isolation. A program running under one user account cannot access files created by the same program under a different account. This separation is structural, not policy-based — the storage areas are physically distinct.

### Software supply chain environments

Development, build, and CI systems are high-value targets for supply chain attacks. A tainted dependency or build tool update operates with the same trust as the legitimate version.

HJFS version isolation addresses this. When a program is updated, its prior version — including all its libraries and data files — is preserved in a separate storage area. A tainted update cannot access or destroy data created by the legitimate version. Rollback to the prior clean version is a single utility command, with no data loss.

### Regulated environments

Healthcare, financial, legal, and government systems often require demonstrable data segregation — evidence that one program's data cannot be accessed by another. HJFS provides this at the filesystem architecture level. The filesystem enforces program boundaries: no policy rule can be misconfigured to grant one program another's files.

### Standard-kernel environments

HJFS runs on a standard kernel — no kernel modification required. This makes it deployable where a modified or custom kernel is not permitted: cloud instances on AWS, Google Cloud, Azure, DigitalOcean, or Linode, systems subject to kernel certification requirements, and organisations with strict change-control policies around the kernel.

### Alongside Root Lock by HeartSuite

HJFS and Root Lock address complementary layers. Root Lock controls program execution and network access at the kernel level. HJFS controls file read and write access at the filesystem level and adds per-version data isolation.

On that host they cover all three OS-level controls — file access, network communication, and program execution. See [Protection limits](../introduction/limits/).

---

## Where another control owns the workload

### Remote or cloud-only storage

HJFS isolates files at the local filesystem layer. Isolation on remote or cloud-hosted filesystems holds only where HJFS is running on the host that stores the data.

A client program accessing remote storage over a network connection is isolated on the local host. On the remote side, isolation holds only where HJFS is running. Network-level connection control for those programs is handled by Root Lock.

### Environments needing execution or network control

Which programs can execute and which network connections they can open stay Root Lock's domain. Where those controls are the primary requirement, use Root Lock, which enforces both at the kernel level.

HJFS can be added alongside it for filesystem-layer isolation. Per-program file isolation on a standard kernel still holds.

### Windows and macOS

HJFS on Linux uses standard kernel filesystem registration — no special permissions or OS modifications required.

On Windows and macOS, registering a filesystem requires cooperation from Microsoft or Apple respectively. Linux is the current deployment target because that registration is a standard kernel operation there. Support for Windows and macOS is planned. File isolation on Linux still holds.
