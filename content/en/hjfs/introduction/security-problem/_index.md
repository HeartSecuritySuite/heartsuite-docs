---
title: "Your word processor inherits every file you own"
linkTitle: "The security problem"
weight: 1
description: "Malware encrypts your files with the same open() your editor uses. HJFS keeps custody with you, not with the program you ran."
categories: ["Essentials"]
tags: ["hjfs", "security", "malware", "plenary-power", "design"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: When you run a program, the OS grants it every file you can reach. A word processor and ransomware running as the same user have the same access.

HeartSuite Joint File System (HJFS) keeps file access with you, not with the program. Isolation is per program and per version, including as root.

## The root cause

File permissions are granted to users, not to programs. That assumption is still the default. A word processor and a ransomware process running as the same user have identical access to every file that user owns.

Ransomware opens your files using the same system call as any legitimate program, reads them, encrypts them, and overwrites the originals. Backup restores a snapshot taken before the damage. Detection reacts after access was already granted, and only to attacks it already recognizes.

## What HJFS changes

HJFS replaces user-based file permissions with program-based file permissions, enforced inside the filesystem. Each program has its own storage area. No other program can read or write those files, including programs running as root.

Execution and network control are [Root Lock by HeartSuite](../../docs/)'s domain. On a Root Lock kernel, both can share the host. See [What HJFS does and does not cover](../limits/).
