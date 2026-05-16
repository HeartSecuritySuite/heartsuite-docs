---
title: "Deployment Scenarios"
weight: 15
description: "Environments where HJFS fits well, where it fits alongside HeartSuite Core Secure, and where it does not apply."
categories: ["Essentials"]
tags: ["hjfs", "deployment", "scenarios", "compatibility", "use-cases"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

## Where HJFS fits

### Desktop and workstation environments

The HJFS isolation model maps directly onto what desktop programs need: each program confined to its own storage area, with no path between them. A word processor cannot touch a browser's files, and neither can reach files belonging to any other program. With [Advanced Protection](../advanced-protection/), user-facing documents are opened only through an OS-mediated dialog, giving the user direct control over which files each program can access.

Desktop deployments use the full HJFS model: per-program isolation, per-version storage, and OS-mediated user file access.

### Multi-user systems

On systems with multiple user accounts, HJFS layers per-user isolation on top of per-program and per-version isolation. A program running under one user account cannot access files created by the same program under a different account. This separation is structural, not policy-based — the storage areas are physically distinct.

### Software supply chain environments

Development, build, and CI systems are high-value targets for supply chain attacks. A tainted dependency or build tool update is one of the most significant risks in this environment because it operates with the same trust as the legitimate version.

HJFS version isolation addresses this directly. When a program is updated, its prior version — including all its libraries and data files — is preserved in a separate storage area. A tainted update cannot access or destroy data created by the legitimate version. Rollback to the prior clean version is a single utility command, with no data loss.

### Regulated environments

Healthcare, financial, legal, and government systems often require demonstrable data segregation — evidence that one program's data cannot be accessed by another. HJFS provides this at the filesystem architecture level. The filesystem enforces program boundaries: no policy rule can be misconfigured to grant one program another's files.

### Standard-kernel environments

HJFS runs on a standard kernel — no kernel modification required. This makes it deployable where a modified or custom kernel is not permitted: cloud instances on AWS, Google Cloud, Azure, DigitalOcean, or Linode, systems subject to kernel certification requirements, and organisations with strict change-control policies around the kernel.

### Alongside HeartSuite Core Secure

HJFS and HeartSuite Core Secure address complementary layers. Core Secure controls program execution and network access at the kernel level. HJFS controls file read and write access at the filesystem level and adds per-version data isolation. Together they cover all three OS-level controls — file access, network communication, and program execution.

For production server and regulated deployments, running both closes all three dimensions. See [What HJFS Does and Does Not Cover](../introduction/limits/) for the specific gaps each fills.

---

## Where HJFS does not apply

### Remote or cloud-only storage

HJFS isolates files at the local filesystem layer. Data stored on remote or cloud-hosted filesystems is not protected by HJFS unless HJFS is running on the host where that data resides. A client program accessing remote storage over a network connection is outside HJFS's scope on the remote side. Network-level connection control for those programs is handled by HeartSuite Core Secure.

### Environments needing execution or network control without HS1

HJFS v1.0 does not control which programs can execute or which network connections programs can open. Where these controls are the primary requirement, use HeartSuite Core Secure, which enforces both at the kernel level. HJFS can be added alongside it for filesystem-layer isolation.

### Windows and macOS

HJFS on Linux uses standard kernel filesystem registration — no special permissions or OS modifications required. On Windows and macOS, registering a filesystem requires cooperation from Microsoft or Apple respectively. That cooperation is the blocking constraint, not a technical limitation of HJFS itself. Linux is the current deployment target. Support for Windows and macOS is planned.
