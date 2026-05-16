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

> **Prototype**: HJFS is under active development.

## Current capabilities

HJFS currently includes the following capabilities:

| Capability | Notes |
|---|---|
| Per-program file isolation | `open()` interception — programs are confined to their own storage area |
| Per-version storage | Each installed program version receives its own isolated storage area |
| Version rollback | Non-destructive — prior versions and their data remain intact |
| Secure file transfer | Copy utility and transfer area for explicit cross-program data movement |
| Trash-only deletion | Programs cannot permanently delete files. Permanent deletion requires explicit user action through a separate utility |
| Automatic data file backup | Every data file version is backed up to a protected area inaccessible to ordinary programs |
| Version management utilities | `HJFS_update_program` and `HJFS_version_manager` |

HJFS implements core file organization with the host file system code left unchanged — enabling deployment on standard, unmodified kernels. See [Architecture and compatibility](../architecture/) for details.

## Planned

### Next release

| Item | Notes |
|---|---|
| FS source code integration | Integrates minimal HJFS source code into the host file system's `open()` call. Required for production deployment |
| Kernel registration | Registers the HJFS-modified file system with the kernel. Requires FS vendor cooperation on non-Linux platforms |

### Subsequent releases

| Item | Notes |
|---|---|
| Network access control | New outbound connections are mediated by the OS. Desktop deployments prompt the user for confirmation; server deployments apply policy rules |
| Python script compartmentalization | Confines individual Python scripts to separate file spaces. Scripts no longer share the interpreter's storage area. Requires a small amount of kernel cooperation |
| Advanced protection | Separates internal and user files and introduces OS-mediated file dialogs. Requires application updates. See [Advanced Protection](../advanced-protection/) for design details |
