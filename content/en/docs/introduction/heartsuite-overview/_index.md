---
title: "Root Lock by HeartSuite Overview"
linkTitle: "Root Lock by HeartSuite Overview"
weight: 1
description: "Core concepts and purpose of Root Lock by HeartSuite security suite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "security", "concepts"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "heartsuite-overview"
---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite controls all three — per program, not per user. Your SSH server and your web server both run as root; they still get different permissions because they are different programs. Any program not on the allowlist is blocked at the kernel before it can run or cause damage.

## Kernel-level enforcement

Root Lock by HeartSuite uses a modified Linux kernel that enforces an allowlist-based security model. No program can execute without an allowlist entry — and each allowlist entry also controls which files the program can read or write, and which network connections it can make. Even if malware is downloaded to a Root Lock by HeartSuite server, the kernel prevents it from running or causing damage.

The **Dashboard** is the central interface. It tracks your progress through a 7-phase setup journey, shows what's waiting for review, and always suggests the next step.

### The 7 phases

| Phase | Name | Purpose |
|-------|------|---------|
| 1 | System Verification | Confirm kernel and Dashboard are active |
| 2 | Program Allowlisting | Review and approve programs that need to run |
| 3 | Script Launchers | Configure interpreters for Python, Perl, PHP (if applicable) |
| 4 | File Access Allowlisting | Review and approve file read/write access for programs |
| 5 | Internet Access Allowlisting | Review and approve outbound internet connections |
| 6 | Alert Settings | Set up notification channels (email, syslog, webhook) |
| 7 | Lockdown | Activate Lockdown — locked until phases 2–6 are complete |

## Reduced kernel footprint

The security industry patches vulnerabilities one at a time. Root Lock by HeartSuite removes the features attackers rely on — by design.

Most malware escalates privilege by reaching for the same handful of kernel features: eBPF to hide processes, FUSE to redirect reads, overlay filesystems to shadow directories, userspace LSM frameworks (AppArmor, SMACK, Landlock) to pivot through, and unprivileged user namespaces to gain root without credentials.

The Root Lock by HeartSuite kernel is deliberately compiled without them. These primitives are the attack surface, path to root, and bypass vectors the allowlist model exists to close.

A stock Ubuntu kernel ships with over 6,600 loadable modules. The HeartSuite kernel ships with 13 — one config file you can read in an afternoon.

Detection tools like Falco, Cilium Tetragon, and bpftrace watch these features. Root Lock by HeartSuite removes them instead. Nothing to watch. Nothing to bypass. No agent to kill. No race against the attacker. For the layer comparison, see [Kernel architecture](../how-it-compares/#kernel-architecture).

Workloads needing the omitted primitives (on-host containers, local eBPF, rootless) are not a fit by design. See [Deployment Scenarios](../deployment-scenarios/) for alternatives.

## Features

### 1. Program Allowlist

An allowlist entry defines what a program is permitted to do — whether it can execute, which files it can read or write, and which network connections it can make. The Root Lock by HeartSuite kernel requires every program to have an allowlist entry before it is permitted to run.

The **Dashboard review queues** present pending items for approval:

- **Programs queue** (`[p]`) — programs attempting to execute
- **File Access queue** (`[f]`) — programs attempting to read or write files
- **Internet Access queue** (`[i]`) — programs attempting outbound connections

Each queue manages volume through intelligent grouping — not blind bulk approval:

- **Individual review**: Items shown one at a time with full metadata (package name, description, category, maintainer, install date)
- **Grouped review**: Related items (e.g., "847 file reads from /usr/lib/python3/") presented as a single group with a representative sample shown
- **Queue summary**: An orientation view of total counts and a breakdown by program shown before reviewing begins

File access is divided into **read access** and **write access**. Write access always includes read access. These are approved separately — approving a file read grants read access; approving a file write upgrades to write access.

### 2. Setup Mode and Lockdown

Root Lock by HeartSuite operates in two modes:

- **Setup Mode**: The kernel logs all program executions, file accesses, and network connections without blocking them. Use this mode to build the allowlist by reviewing queues and approving programs and their access patterns. The Dashboard guides this process.
- **Lockdown**: The kernel enforces the allowlist. Programs without an allowlist entry are blocked. Programs that exceed their permissions are blocked.

Activating Lockdown requires all review queues to be empty, alerts to be configured, and an active subscription. The Dashboard presents a precondition checklist. Before the final confirmation, the prep shown during Lockdown activation offers actions and opt-outs (e.g. `[u]` undo auto-narrowed grants, `[p]` patch, `[g]` restrict rm/cp/mv, `[x]` exclude write conflicts). The inventory and summaries are read-only. It requires typing `YES` (case-sensitive) to confirm. See [Mode Switching and Lockdown](mode-switching/) for full keys and flow.

### 3. Lockdown

Lockdown protects the integrity of allowlist entries by making them immutable. Once applied, no changes can be made to the allowlist while the server is running — preventing attackers from modifying the security configuration, even with root access.

After activating Lockdown, the Dashboard offers one reboot option: `[r]` Reboot — Lockdown active on next boot. Lockdown is engaged automatically on every HeartSuite kernel boot; no program or user, including root, can reverse it at runtime. To make changes, the Dashboard's Maintenance (`[m]`) guides you through the correct maintenance path — including a guided 3-step process that boots the Non-HS kernel.

Because access permissions are enforced inside the Root Lock by HeartSuite kernel itself, Root Lock by HeartSuite cannot be circumvented by any program or user, including root, while the Root Lock by HeartSuite kernel is running.

### 4. File backup and versioning

Root Lock by HeartSuite automatically backs up files in designated directories and prevents all programs from accessing the backups — only Root Lock by HeartSuite itself can reach them. The version manager can restore any version of a backed-up file, regardless of whether it was encrypted, deleted, or modified.

Modern ransomware destroys backup systems before encrypting files — shadow copies and backup agents are typically the first targets. Root Lock by HeartSuite's backups are not permission-protected: under Lockdown, the kernel itself blocks write access to backup files. No program, including root, can reach them.

The allowlist blocks most attacks at the kernel. When an approved program is compromised, a backup on every write means recovery starts from the moment before damage began — not the last scheduled snapshot.

### 5. Secure Script Launchers

Allowlist entries can be created for interpreted code such as Python, PHP, and Perl. Root Lock by HeartSuite provides Secure Script Launchers that identify the specific script being run when an interpreter is launched, enabling per-script access control with the same granularity as compiled programs.

## Two setup paths

**Cloud Path**: Launch a pre-installed cloud instance. The Dashboard appears immediately and confirms Phase 1 is complete. Proceed directly to the review queues.

**Local Path**: Download from heartsecsuite.com, extract, install, and boot the Root Lock by HeartSuite kernel. The System Setup guides you through multiple setup steps with a step counter. Once the Dashboard confirms Phase 1 is complete, both paths merge.

## How Root Lock by HeartSuite stands alone

No other product combines all three: enforcement that survives root compromise, standalone operation with no background process or vendor console, and a backup on every file write — not on a schedule, on every write. Each exists separately in other products. Together, they make Root Lock by HeartSuite the right choice for deployments where the security layer itself must be protected from the attacker who is already inside. The allowlist is sealed — immutable on disk, refused at runtime by the kernel itself: no program or user, including root, can modify it while the machine is running. The backup files are protected by the Root Lock by HeartSuite kernel itself, not by filesystem permissions.

## Is Root Lock by HeartSuite right for you?

Root Lock by HeartSuite is a strong fit for production servers, closed appliances, regulated workstations, build and CI infrastructure, and AI agent sandboxes. Containers fit as OCI images built and run off-host; running a shared-kernel container runtime directly on a host running the HeartSuite kernel is not a fit by design — the kernel omits the overlay and user-namespace primitives that would reintroduce the attack surface the allowlist model exists to close. Hosts where eBPF-based tooling must run locally require the maintenance kernel for the same reason: the BPF syscall and verifier are deliberately absent. See [Deployment Scenarios](../deployment-scenarios/) for a full breakdown.

If you already run Falco, AppArmor, gVisor, or a Linux EDR agent — or a SIEM, NDR platform, or vulnerability scanner — see [How Root Lock by HeartSuite Compares](../how-it-compares/) to understand which tools Root Lock by HeartSuite replaces, which it runs alongside, how it can be circumvented, and [how the operational cost compares to SELinux, EDR, and tools like Zafran — including what changes for patching urgency and alert volume](../security-as-economics/).

To get Root Lock by HeartSuite: launch a pre-installed cloud instance or download the Local Path package from [heartsecsuite.com](https://heartsecsuite.com). Both arrive at the Dashboard — [Getting Started](../../getting-started/) covers the rest.
