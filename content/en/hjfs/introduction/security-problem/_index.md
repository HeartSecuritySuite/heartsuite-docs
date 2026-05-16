---
title: "The Security Problem HJFS Solves"
linkTitle: "The Security Problem"
weight: 1
description: "The OS design flaw that makes malware damage possible, and how HJFS addresses it."
categories: ["Essentials"]
tags: ["hjfs", "security", "malware", "plenary-power", "design"]
type: docs
toc: true
---

## The scribe analogy

Imagine you need to write documents but cannot write yourself, so you hire a scribe. The scribe writes faithfully as you dictate, then leaves at the end of the session — taking your documents. At that point the scribe holds custody of your work. The scribe could demand payment before returning the documents, alter them outside your presence, or copy them for others. This is only possible because you gave the scribe custody — plenary control over your documents.

A word processor on your computer plays the role of the scribe. When you run any program, the OS grants it your full file access rights. Ransomware exploits exactly this: it opens your files using the same system call as any legitimate program, reads them into memory, encrypts them, and overwrites the originals — all because the OS hands over custody to any program you run, without asking whether you intended it.

To reclaim control, the solution is the same as with the scribe: the user, not the program, holds custody of the documents. HJFS enforces this at the filesystem level.

## The root cause

The root cause of most malware damage is a design assumption made in the earliest operating systems and carried forward unchanged: file access permissions are granted to users, not to programs. When a user runs a program, that program inherits the user's full file access rights. A word processor and a ransomware process running as the same user have identical access to every file that user owns.

This single assumption creates three persistent vulnerabilities that layered security tools cannot fully close.

## Three expressions of the problem

### 1. Unrestricted file access

The OS function `open()` allows any running program to access, read, write, or delete any file the current user has permission to touch — regardless of what program is asking. Malware uses this to encrypt files for ransom, exfiltrate data, or silently corrupt application data.

Backup tools take point-in-time snapshots but cannot prevent in-place encryption before the next snapshot. Detection tools identify known attack signatures but react after access has already been granted — and miss attacks with no prior signature.

### 2. Unrestricted network communication

The OS function `connect()` allows any running program to open outbound network connections. Malware uses this to exfiltrate data and communicate with command-and-control infrastructure. Network filtering blocks known patterns but cannot identify malicious traffic from a trusted-looking process already running inside the perimeter.

### 3. Unrestricted program spawning

The OS function `exec()` allows any running program to launch other programs. Malware uses this to establish persistence, escalate privileges, and move laterally. Policy tools attempt to govern this behavior from the outside, but the underlying capability is available to every process by default.

## Why layered defenses do not solve this

Each additional security layer addresses a symptom without removing the cause. The OS continues to grant programs unrestricted access; detection and prevention tools observe the resulting behavior and attempt to react. Novel and zero-day attacks consistently evade this model — they exploit the same OS design before a detection rule or signature exists.

## How HJFS addresses this

HJFS replaces user-based file permissions with program-based file permissions, enforced inside the filesystem at the `open()` call. Each program is confined to its own storage area. No program can access files belonging to another, regardless of what user account is running it. File access is no longer inherited from the user — it is specific to the program.

HJFS v1.0 addresses the file access flaw. Network access control is planned for a subsequent version. For kernel-level program execution control, see [HeartSuite Core Secure](../../../docs/).
