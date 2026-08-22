---
title: "HJFS on a stock kernel"
linkTitle: "Architecture"
weight: 20
description: "How HJFS isolates files without replacing the kernel, which operating systems it targets, and how the prototype sits on the host filesystem."
categories: ["Essentials"]
tags: ["hjfs", "architecture", "compatibility", "deployment", "os-support"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: HeartSuite Joint File System (HJFS) isolates files inside the host filesystem on a stock kernel. Enforcement sits in the filesystem `open()` path, not in a custom kernel.

HJFS sits on an existing host filesystem. The current prototype implements the core file organization without modifying the host filesystem's code directly.

## Integration and vendor cooperation

HJFS integration involves two steps:

- **FS source code integration**: A minimal amount of HJFS source code is integrated into the file system's `open()` call. The scope of changes is small.
- **Kernel registration**: The HJFS-modified file system must be registered with the kernel. On Linux, this is a standard operation. On Windows and macOS, it requires cooperation from Microsoft or Apple respectively. Kernel registration is planned for a subsequent release.

## OS support

HJFS is designed to work on Linux, Windows, and macOS.

| Platform | Notes |
|---|---|
| Linux | Most straightforward path. Registering a modified file system with the kernel is a standard Linux operation. |
| Windows | More involved. Requires cooperation from Microsoft to register the HJFS-modified file system with the Windows kernel. |
| macOS | More involved. Requires cooperation from Apple to register the HJFS-modified file system with the macOS kernel. |

### Partial deployment: portable HJFS drive

Adding an HJFS-formatted disk or USB drive to a Windows computer isolates programs installed on that drive. Files on the HJFS volume stay isolated per program. Programs on the rest of the computer stay on NTFS until NTFS itself is made HJFS compliant.

## Application compatibility

HJFS basic protection requires only OS-level changes — not application changes. Existing application software runs unchanged for the vast majority of programs.

Applications hard-coded to access global system paths outside their own storage area (such as `/usr` or `/proc`) would need minor adjustments. The scope of such changes is expected to be small.

See [Advanced protection](../advanced-protection/) for the level that does require application modifications, and what it adds in return.

## Container compatibility

Containers running on an HJFS-compliant host filesystem benefit from the same per-program file isolation as native processes. Each containerized program is confined to its own storage area. Container orchestration and scheduling are unaffected.

## Network access control

[Root Lock by HeartSuite](../../docs/network/) provides network access control today with kernel-level gating of outbound connections. On a Root Lock kernel, both can share the host.

HJFS network mediation is planned. File isolation on a standard kernel still holds without it. See [Roadmap](../roadmap/).

When that HJFS path ships, each new outbound connection requires explicit approval rather than a static list:

- **Desktop**: you approve each new connection through an OS confirmation dialog.
- **Server**: access is governed by pre-approved utilities or admin-defined policies, without per-action prompts.

Planned desktop path:

![Diagram 2.5 — Network connection flow: the Chess Client calls connect("chess_online.com"), the OS intercepts and shows a dialog "Confirm or type server name," the user's selection triggers connection creation, and the request is sent via the Internet to the Chess Server.](/images/hjfs/diagram-004.jpg)

## Blocking simulated user input

HJFS-compliant OS distributions disable the ability for a program to simulate user mouse clicks or keypresses in ordinary user sessions. Without this, a malicious program could simulate a user emptying the trash, approving a file open dialog, or confirming a network connection — faster than a user can observe or stop them.

## Local deployment requirement

HJFS must run locally on every machine it protects. Remote or cloud storage alone leaves the client program on whatever filesystem that host uses.

HJFS applies file isolation at the filesystem layer on the local host. A program running on a machine without HJFS stays on that host's native filesystem, regardless of where its data is stored. On a host where HJFS is present, that host's local files stay isolated per program.
