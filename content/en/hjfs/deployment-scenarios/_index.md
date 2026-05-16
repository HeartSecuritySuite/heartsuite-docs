---
title: "Deployment Scenarios"
weight: 15
description: "Environments where HJFS fits well, where it fits alongside HeartSuite Core Secure, and where it does not apply."
categories: ["Essentials"]
tags: ["hjfs", "deployment", "scenarios", "compatibility", "use-cases"]
type: docs
toc: true
menu:
  main:
    identifier: "hjfs-deployment-scenarios"
    weight: 18
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

## Where HJFS fits

### Desktop and workstation environments

HJFS is well suited to desktop and workstation use. Every program running on the system is confined to its own storage area — a word processor cannot touch a browser's files, and neither can reach files belonging to any other program. With [Advanced Protection](../advanced-protection/), user-facing documents are opened only through an OS-mediated dialog, giving the user direct control over which files each program can access.

Desktop deployments benefit most from the full HJFS model: per-program isolation, per-version storage, and OS-mediated user file access.

### Multi-user systems

On systems with multiple user accounts, HJFS layers per-user isolation on top of per-program and per-version isolation. A program running under one user account cannot access files created by the same program under a different account. This is structural, not policy-based — the storage areas are physically separate.

### Software supply chain environments

Development, build, and CI systems are high-value targets for supply chain attacks. A tainted dependency or build tool update is one of the most dangerous attack vectors in this environment because it operates with the same trust as the legitimate version.

HJFS version isolation addresses this directly. When a program is updated, its prior version — including all its libraries and data files — is preserved in a separate storage area. A tainted update cannot access or destroy data created by the legitimate version. Rollback to the prior clean version is a single utility command, with no data loss.

### Regulated environments

Healthcare, financial, legal, and government systems often require demonstrable data segregation — evidence that one program's data cannot be accessed by another. HJFS provides this at the filesystem architecture level, not through access policies that can be misconfigured. Per-program and per-version storage boundaries are enforced by the filesystem itself, not by an administrator's rule set.

### Standard-kernel environments

HJFS operates on a standard kernel — no kernel modification is required. This makes it deployable in environments where a modified or custom kernel is not permitted: cloud instances where the kernel is managed by the provider, systems subject to kernel certification requirements, or organisations with strict change-control policies around the kernel.

### Alongside HeartSuite Core Secure

HJFS and HeartSuite Core Secure address complementary layers. Core Secure controls program execution and network access at the kernel level. HJFS controls file access at the filesystem level and adds per-version data isolation. Together they address all three OS-level plenary powers — file access, network communication, and program execution.

For most production server deployments, running both provides the most complete coverage. See [What HJFS Does and Does Not Cover](../introduction/limits/) for the specific gaps each fills.

---

## Where HJFS does not apply

### Remote or cloud-only storage

HJFS enforcement happens at the local filesystem layer. Data stored on remote or cloud-hosted filesystems is not protected by HJFS unless HJFS is running on the host where that data resides. A client program accessing remote storage over a network connection is not subject to HJFS controls on the remote side.

### Environments needing execution or network control without HS1

HJFS v1.0 does not control which programs can execute or which network connections programs can open. Environments where these controls are the primary requirement should use HeartSuite Core Secure, which enforces both at the kernel level. HJFS can be added alongside it for filesystem-layer isolation.

### Windows and macOS without vendor cooperation

Deploying HJFS on Windows or macOS requires registering the HJFS-modified filesystem with the OS kernel, which requires cooperation from Microsoft or Apple respectively. This is planned for a subsequent release. The current prototype targets Linux, where filesystem registration is a standard kernel operation.
