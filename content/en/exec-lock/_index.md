---
title: "HeartSuite Exec Lock"
linkTitle: "Exec Lock"
description: "Kernel-level program execution control and network allowlisting, designed to work alongside HJFS."
categories: ["Essentials"]
tags: ["heartsuite", "execution", "network", "allowlisting", "hjfs"]
type: docs
toc: true
---

**Overview**: HeartSuite Exec Lock provides the program execution and network controls of HeartSuite Core Secure without the file access layer. It is designed to be deployed together with HJFS. HJFS supplies per-program, per-version file isolation and automatic data backup. HeartSuite Exec Lock supplies kernel-level gating of which programs may run and which network destinations they may reach.

## What the product controls

| Control | Layer | How it works |
|---------|-------|--------------|
| Program execution | Kernel | Only programs on the allowlist may run. Any binary without an entry is blocked before it starts. |
| Outbound network connections | Kernel | Only approved IP destinations are permitted. All other connection attempts are blocked at the kernel. |
| File access | — | Not provided. Use HJFS for file isolation, version rollback, and automatic backup. |

## Why this product exists

Full HeartSuite Core Secure and HJFS currently cannot be used together because both implement file access controls at different layers. Removing file access management from Core Secure removes that conflict. The resulting product supplies exactly the two controls that HJFS does not yet provide.

Administrators who adopt HJFS for its file protections can add HeartSuite Exec Lock to regain strong kernel-level execution and network enforcement without replacing HJFS's file model.

## How it works with HJFS

HJFS confines every program to its own storage area at the filesystem layer. HeartSuite Exec Lock adds the two missing gates at the kernel layer:

- A program cannot launch unless it has an allowlist entry.
- A program cannot open a network connection unless the destination is approved.

Together the two products close all three OS-level attack surfaces: execution, file access, and network communication. Neither product alone provides the full set.

## Relationship to HeartSuite Core Secure

Customers who do not need HJFS continue to use HeartSuite Core Secure unchanged. That product still supplies execution, network, and file controls in a single package.

Customers who want HJFS's stronger file isolation use HeartSuite Exec Lock alongside HJFS. The two together give the same three-layer coverage that HeartSuite Core Secure once provided, but with the file layer now handled by HJFS.

## Current status

This product is a proposal. No engineering work has begun and no release timeline exists.

## See also

- [HJFS Overview](../hjfs/introduction/hjfs-overview/)
- [HeartSuite Core Secure overview](../docs/introduction/heartsuite-overview/)
- [How HeartSuite Core Secure compares](../docs/introduction/how-it-compares/)
