---
title: "The security problem HJFS solves"
linkTitle: "The security problem"
weight: 1
description: "The OS design flaw that makes malware damage possible, and how HJFS addresses it."
categories: ["Essentials"]
tags: ["hjfs", "security", "malware", "plenary-power", "design"]
type: docs
toc: true
---

## The scribe analogy

Imagine you need to write documents but cannot write yourself, so you hire a scribe. The scribe writes faithfully as you dictate. Then the session ends — and the scribe leaves with your documents. At that point the scribe holds custody of your work. The scribe could demand payment before returning the documents, alter them outside your presence, or copy them for others. This is only possible because you gave the scribe custody over your documents.

A word processor on your computer plays the role of the scribe. When you run any program, the OS grants it your full file access rights. Ransomware exploits exactly this: it opens your files using the same system call as any legitimate program, reads them into memory, encrypts them, and overwrites the originals — all because the OS hands over custody to any program you run, without asking whether you intended it.

To reclaim control, the solution is the same as with the scribe: the user, not the program, holds custody of the documents. HJFS enforces this at the filesystem level.

## The root cause

The root cause of most malware damage is a design assumption made in the earliest operating systems and carried forward unchanged: file access permissions are granted to users, not to programs. When a user runs a program, that program inherits the user's full file access rights. A word processor and a ransomware process running as the same user have identical access to every file that user owns.

This single assumption creates three persistent vulnerabilities that layered security tools cannot fully close.

## Three expressions of the problem

### 1. Unrestricted file access

The OS function `open()` allows any running program to read, write, or delete any file the current user owns. Malware uses this to encrypt files for ransom, exfiltrate data, or silently corrupt application state. Backup tools can only restore from a previous snapshot taken before the damage; detection tools identify known attack patterns but react after access has already been granted, and miss any attack without a prior signature.

### 2. Unrestricted network communication

The OS function `connect()` allows any running program to open outbound network connections. Malware uses this to exfiltrate data and communicate with command-and-control infrastructure. Network filtering blocks known patterns but cannot distinguish malicious traffic from a trusted-looking process already running inside the perimeter.

### 3. Unrestricted program spawning

The OS function `exec()` allows any running program to launch other programs. Malware uses this to persist on the system, gain higher access rights, and reach other programs and systems. Policy tools attempt to govern this behavior from outside the OS, but the underlying capability is available to every process by default.

## Why layered defenses do not solve this

Each additional security layer treats a symptom without removing the cause. Detection and prevention tools observe the behavior that results from unrestricted OS access and react — after access has already been granted, and only to attacks they already recognize.

## HJFS addresses this differently

HJFS replaces user-based file permissions with program-based file permissions, enforced inside the filesystem at the `open()` call. Each program is confined to its own storage area. Under HJFS, no program can read or write files belonging to another — including when that program runs as root. File access is specific to the program, not inherited from the user.

HJFS addresses the file access dimension. Network connection control and program execution control are outside HJFS scope. Root Lock by HeartSuite handles those dimensions but is not currently compatible with HJFS.
