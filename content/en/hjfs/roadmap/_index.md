---
title: "Roadmap"
linkTitle: "Roadmap"
weight: 35
description: "Current prototype scope and planned development for HeartSuite Joint File System."
categories: ["Essentials"]
tags: ["hjfs", "roadmap", "planned", "prototype"]
type: docs
toc: true
---

> **Prototype**: HJFS is under active development. This page reflects current scope and known planned work.

## Current prototype

The following capabilities are implemented in the current HJFS prototype:

| Capability | Notes |
|---|---|
| Per-program file isolation | `open()` enforcement — programs confined to their own storage area |
| Per-version storage | Each installed program version receives its own isolated storage area |
| Version rollback | Non-destructive — prior versions and their data remain intact |
| Secure file transfer | Copy utility and transfer area for explicit cross-program data movement |
| Trash-only deletion | Programs cannot permanently delete files; permanent deletion requires explicit user action via a separate utility |
| Automatic data file backup | Every data file version backed up to a protected area inaccessible to ordinary programs |
| Version management utilities | `HJFS_update_program` and `HJFS_version_manager` |

The current prototype implements core file organization without modifying the host file system's code directly. See [Architecture and Compatibility](../architecture/) for details.

## Planned

### Next release

| Item | Notes |
|---|---|
| FS source code integration | Minimal HJFS source code integrated into the host file system's `open()` call — required for production deployment |
| Kernel registration | HJFS-modified file system registered with the kernel — requires FS vendor cooperation on non-Linux platforms |

### Subsequent releases

| Item | Notes |
|---|---|
| Network access control | New outbound connections mediated by the OS; user confirmation on desktop, policy-based on server |
| Python script compartmentalization | Individual Python scripts confined to separate file spaces rather than sharing the interpreter's area — requires a small amount of kernel cooperation |
| Advanced protection | Internal/user file separation and OS-mediated file dialogs — requires application updates. See [Advanced Protection](../advanced-protection/) for design details |
