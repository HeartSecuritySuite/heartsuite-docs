---
title: "HeartSuite Overview"
linkTitle: "HeartSuite Overview"
weight: 1
description: "Core concepts and purpose of HeartSuite security suite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "security", "concepts"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "heartsuite-overview"
---

**Overview**: HeartSuite enforces a default-deny policy at the kernel level — only explicitly approved programs can execute, access files, or make network connections. Any program not on the allowlist is blocked before it can execute, including malware and zero-day attacks that detection-based tools might miss.

## How HeartSuite Works

HeartSuite uses a modified Linux kernel that enforces an allowlist-based security model. No program can execute, access files, or make network connections unless explicitly approved by an administrator. Even if malware is downloaded to a HeartSuite server, the kernel prevents it from running or causing damage.

The **Dashboard** is the central interface. It tracks your progress through a 7-phase setup journey, shows pending events that need review, and always suggests the next step.

### The 7-Phase Model

| Phase | Name | Purpose |
|-------|------|---------|
| 1 | System Verification | Confirm kernel and Dashboard are active |
| 2 | Program Allowlisting | Review and approve programs that need to run |
| 3 | Script Launchers | Configure interpreters for Python, Perl, PHP (if applicable) |
| 4 | File Access Allowlisting | Review and approve file read/write access for programs |
| 5 | Internet Access Allowlisting | Review and approve outbound internet connections |
| 6 | Alert Configuration | Set up notification channels (email, syslog, webhook) |
| 7 | Secure Mode | Activate enforcement — locked until phases 2–6 are complete |

## Core Features

### 1. Program Allowlist

An allowlist entry defines what a program is permitted to do: which files it can access, which directories it can read or write, and which network connections it can make. The HeartSuite kernel requires every program to have an allowlist entry before it is permitted to run.

The **Dashboard review queues** present pending events for approval:

- **Programs queue** (`[p]`) — programs attempting to execute
- **File Access queue** (`[f]`) — programs attempting to read or write files
- **Internet Access queue** (`[i]`) — programs attempting outbound connections

Each queue uses a tiered review model to manage volume efficiently:

- **Tier 1**: Individual events shown one at a time with full metadata (package name, description, category, maintainer, install date)
- **Tier 2**: Grouped events (e.g., "847 file reads from /usr/lib/python3/") with a representative sample shown
- **Tier 3**: Informational summary of what is ahead before reviewing

File access is divided into **read access** and **write access**. Write access always includes read access. These are approved separately — approving a file read event grants read access; approving a file write event upgrades to write access.

The caching mechanism loads only a single allowlist entry into memory for a running program, even with thousands of concurrent instances, minimising impact on kernel memory.

### 2. Setup Mode and Secure Mode

HeartSuite operates in two modes:

- **Setup Mode**: The kernel logs all denied actions without blocking them. Use this mode to build the allowlist by reviewing queues and approving legitimate programs and access patterns. The Dashboard guides this process.
- **Secure Mode**: The kernel enforces the allowlist. Programs without an allowlist entry are blocked. Programs that exceed their permissions are blocked.

Activating Secure Mode requires all review queues to be empty, alerts to be configured, and an active subscription. The Dashboard presents a precondition checklist and requires typing `YES` (case-sensitive) to confirm.

### 3. Lockdown

Lockdown protects the integrity of allowlist entries by making them immutable. Once applied, no changes can be made to the allowlist while the server is running — preventing attackers from modifying the security configuration, even with root access.

After activating Secure Mode, the Dashboard offers two reboot options: `[r]` Reboot (enforcement active, configuration remains editable) or `[l]` Reboot + Lockdown (enforcement active, configuration sealed with filesystem immutability). Lockdown cannot be reversed at runtime. To make changes, the Dashboard's Maintenance screen (`[t]`) guides you through the correct maintenance path — including a guided 3-step process when Lockdown requires booting the Non-HS kernel.

Because access permissions are enforced inside the HeartSuite kernel itself, HeartSuite cannot be circumvented by any program or user, including root.

### 4. File Backup and Versioning

HeartSuite automatically backs up files in designated directories and prevents all programs from accessing the backups — only HeartSuite itself can reach them. The version manager can restore any version of a backed-up file, regardless of whether it was encrypted, deleted, or modified.

### 5. Secure Script Launchers

Allowlist entries can be created for interpreted code such as Python, PHP, and Perl. HeartSuite provides Secure Script Launchers that identify the specific script being run when an interpreter is launched, enabling per-script access control with the same granularity as compiled programs.

## Two Setup Paths

**Cloud Path**: Launch a pre-installed cloud instance. The Dashboard appears immediately. Phase 1 (System Verification) auto-completes. Proceed directly to the review queues.

**Local Path**: Download from heartsecsuite.com, extract, install, and boot the HeartSuite kernel. Run `hs-os-boot-setup` through multiple reboots (the Dashboard shows a step counter). After Phase 1 completes, the Dashboard appears and both paths merge.
