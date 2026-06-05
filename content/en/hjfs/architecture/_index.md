---
title: "Architecture and compatibility"
weight: 20
description: "Technical architecture, OS compatibility, application notes, and scope for HeartSuite Joint File System."
categories: ["Essentials"]
tags: ["hjfs", "architecture", "compatibility", "deployment", "os-support"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

## Dependencies

HJFS requires an existing host file system and cannot operate standalone. A compliant system must use a standard kernel that routes all application file access through the improved file system. The current prototype implements the core file organization without modifying the host file system's code directly.

## Integration and vendor cooperation

HJFS integration involves two steps:

- **FS source code integration**: A minimal amount of HJFS source code is integrated into the file system's `open()` call. The scope of changes is small — the current prototype implements the core file organization concepts without any modifications to the host file system's code.
- **Kernel registration**: The HJFS-modified file system must be registered with the kernel. On Linux, this is a standard operation. On Windows and macOS, it requires cooperation from Microsoft or Apple respectively. Kernel registration is planned for a subsequent release.

## Long-term vision

The long-term goal is for every file system to be HJFS compliant. HJFS can in principle be deployed anywhere the encompassing file system can be deployed — for example, if integrated into FAT32, it would apply to FAT32 volumes.

## OS support

HJFS is designed to work on Linux, Windows, and macOS.

| Platform | Notes |
|---|---|
| Linux | Most straightforward path. Registering a modified file system with the kernel is a standard Linux operation. |
| Windows | More involved. Requires cooperation from Microsoft to register the HJFS-modified file system with the Windows kernel. |
| macOS | More involved. Requires cooperation from Apple to register the HJFS-modified file system with the macOS kernel. |

### Partial deployment: portable HJFS drive

Adding an HJFS-formatted disk or USB drive to a Windows computer makes programs installed on that drive safe. Programs on the rest of the computer, running on NTFS, are not protected unless NTFS itself is made HJFS compliant.

## Application compatibility

HJFS basic protection requires only OS-level changes — not application changes. Existing application software runs unchanged for the vast majority of programs. Applications hard-coded to access global system paths outside their own storage area (such as `/usr` or `/proc`) would need minor adjustments, but the scope of such changes is expected to be minimal and inconsequential for most deployments.

See [Advanced Protection](../advanced-protection/) for the tier that does require application modifications, and what it adds in return.

## Container compatibility

Containers running on an HJFS-compliant host filesystem benefit from the same per-program file isolation as native processes. Each containerized program is confined to its own storage area. Container orchestration and scheduling are unaffected.

## Network access control

[HeartSuite Root Lock](../../docs/network/) provides network access control today with kernel-level gating of outbound connections. It is not currently compatible with HJFS and cannot be deployed alongside it. HJFS 1.0 does not include its own network access control; that is planned for a subsequent version.

When implemented in HJFS, each new outbound connection will require explicit user approval rather than relying on static configuration. The approval model differs by deployment type:

- **Desktop**: The user approves each new connection through an OS confirmation dialog.
- **Server**: Access is governed by pre-approved utilities or admin-defined policies, without per-action prompts.

When network access control is available, the user approves each new connection through an OS dialog:

![Diagram 2.5 — Network connection flow: the Chess Client calls connect("chess_online.com"), the OS intercepts and shows a dialog "Confirm or type server name," the user's selection triggers connection creation, and the request is sent via the Internet to the Chess Server.](/images/hjfs/diagram-004.jpg)

## Blocking simulated user input

HJFS-compliant OS distributions disable the ability for a program to simulate user mouse clicks or keypresses in ordinary user sessions. Without this, a malicious program could simulate a user emptying the trash, approving a file open dialog, or confirming a network connection — faster than a user can observe or stop them.

## Local deployment requirement

HJFS must run locally on every machine it protects. Remote or cloud storage alone does not protect the client program. HJFS applies file isolation at the filesystem layer on the local host. A program running on a machine without HJFS is not subject to HJFS file isolation, regardless of where its data is stored.
