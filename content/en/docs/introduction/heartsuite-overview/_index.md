---
title: "HeartSuite Core Secure Overview"
linkTitle: "HeartSuite Core Secure Overview"
weight: 1
description: "Core concepts and purpose of HeartSuite Core Secure security suite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "security", "concepts"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "heartsuite-overview"
---

**Overview**: HeartSuite Core Secure enforces a default-deny policy at the kernel level — each program must be explicitly approved to execute, to access files, and to make network connections. Any program not on the allowlist is blocked before it can execute, including malware and zero-day attacks that detection-based tools might miss.

## Kernel-Level Enforcement

HeartSuite Core Secure uses a modified Linux kernel that enforces an allowlist-based security model. No program can execute without an allowlist entry — and each allowlist entry also controls which files the program can read or write, and which network connections it can make. Even if malware is downloaded to a HeartSuite Core Secure server, the kernel prevents it from running or causing damage.

The **Dashboard** is the central interface. It tracks your progress through a 7-phase setup journey, shows what's waiting for review, and always suggests the next step.

### The 7 Phases

| Phase | Name | Purpose |
|-------|------|---------|
| 1 | System Verification | Confirm kernel and Dashboard are active |
| 2 | Program Allowlisting | Review and approve programs that need to run |
| 3 | Script Launchers | Configure interpreters for Python, Perl, PHP (if applicable) |
| 4 | File Access Allowlisting | Review and approve file read/write access for programs |
| 5 | Internet Access Allowlisting | Review and approve outbound internet connections |
| 6 | Alert Configuration | Set up notification channels (email, syslog, webhook) |
| 7 | Secure Mode | Activate enforcement — locked until phases 2–6 are complete |

## Reduced Kernel Attack Surface

Most malware escalates privilege by reaching for the same handful of kernel features. eBPF to hide processes. FUSE to redirect reads. Overlay filesystems to shadow protected directories. Userspace security frameworks — AppArmor, SMACK, Landlock — to pivot through. Unprivileged user namespaces to become root without credentials.

The HeartSuite Core Secure kernel is compiled without any of them.

Detection tools like Falco, Cilium Tetragon, and bpftrace watch these primitives and raise alerts when something looks suspicious. HeartSuite Core Secure takes a different path. It removes the primitives. Nothing to watch. Nothing to bypass. No agent to keep alive. No race against the attacker.

For the practical implications of these compile-time choices, see [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes).

## Features

### 1. Program Allowlist

An allowlist entry defines what a program is permitted to do — whether it can execute, which files it can read or write, and which network connections it can make. The HeartSuite Core Secure kernel requires every program to have an allowlist entry before it is permitted to run.

The **Dashboard review queues** present pending items for approval:

- **Programs queue** (`[p]`) — programs attempting to execute
- **File Access queue** (`[f]`) — programs attempting to read or write files
- **Internet Access queue** (`[i]`) — programs attempting outbound connections

Each queue manages volume through intelligent grouping — not blind bulk approval:

- **Individual review**: Items shown one at a time with full metadata (package name, description, category, maintainer, install date)
- **Grouped review**: Related items (e.g., "847 file reads from /usr/lib/python3/") presented as a single group with a representative sample shown
- **Queue summary**: An orientation view of total counts and a breakdown by program shown before reviewing begins

File access is divided into **read access** and **write access**. Write access always includes read access. These are approved separately — approving a file read grants read access; approving a file write upgrades to write access.

### 2. Setup Mode and Secure Mode

HeartSuite Core Secure operates in two modes:

- **Setup Mode**: The kernel logs all program executions, file accesses, and network connections without blocking them. Use this mode to build the allowlist by reviewing queues and approving programs and their access patterns. The Dashboard guides this process.
- **Secure Mode**: The kernel enforces the allowlist. Programs without an allowlist entry are blocked. Programs that exceed their permissions are blocked.

Activating Secure Mode requires all review queues to be empty, alerts to be configured, and an active subscription. The Dashboard presents a precondition checklist and requires typing `YES` (case-sensitive) to confirm.

### 3. Lockdown

Lockdown protects the integrity of allowlist entries by making them immutable. Once applied, no changes can be made to the allowlist while the server is running — preventing attackers from modifying the security configuration, even with root access.

After activating Secure Mode, the Dashboard offers two reboot options: `[r]` Reboot (enforcement active, configuration remains editable) or `[l]` Reboot + Lockdown (enforcement active, configuration sealed with filesystem immutability). Lockdown cannot be reversed at runtime. To make changes, the Dashboard's Maintenance screen (`[t]`) guides you through the correct maintenance path — including a guided 3-step process when Lockdown requires booting the Non-HS kernel.

Because access permissions are enforced inside the HeartSuite Core Secure kernel itself, HeartSuite Core Secure cannot be circumvented by any program or user, including root, while the HeartSuite Core Secure kernel is running.

### 4. File Backup and Versioning

HeartSuite Core Secure automatically backs up files in designated directories and prevents all programs from accessing the backups — only HeartSuite Core Secure itself can reach them. The version manager can restore any version of a backed-up file, regardless of whether it was encrypted, deleted, or modified.

### 5. Secure Script Launchers

Allowlist entries can be created for interpreted code such as Python, PHP, and Perl. HeartSuite Core Secure provides Secure Script Launchers that identify the specific script being run when an interpreter is launched, enabling per-script access control with the same granularity as compiled programs.

## Two Setup Paths

**Cloud Path**: Launch a pre-installed cloud instance. The Dashboard appears immediately and confirms Phase 1 is complete automatically. Proceed directly to the review queues.

**Local Path**: Download from heartsecsuite.com, extract, install, and boot the HeartSuite Core Secure kernel. Run `hs-os-boot-setup` through multiple reboots (the Dashboard shows a step counter). Once the Dashboard confirms Phase 1 is complete, both paths merge.

## Is HeartSuite Core Secure Right for You?

HeartSuite Core Secure is a strong fit for production servers, closed appliances, regulated workstations, build and CI infrastructure, and AI agent sandboxes. It is not a fit for container hosts that depend on OverlayFS, or for hosts that run eBPF-based observability. See [Deployment Scenarios](../deployment-scenarios/) for a full breakdown.

If you already run Falco, AppArmor, gVisor, or a Linux EDR agent — or a SIEM, NDR platform, or vulnerability scanner — see [How HeartSuite Core Secure Compares](../how-it-compares/) to understand which tools HeartSuite Core Secure replaces, which it runs alongside, and how it can be circumvented.

To get HeartSuite Core Secure: launch a pre-installed cloud instance or download the Local Path package from [heartsecsuite.com](https://heartsecsuite.com). Both arrive at the Dashboard — [Getting Started](../../getting-started/) covers the rest.
