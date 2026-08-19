---
title: "Root Lock by HeartSuite Overview"
linkTitle: "Root Lock by HeartSuite Overview"
weight: 1
description: "Core concepts and purpose of Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "security", "concepts"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "heartsuite-overview"
---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel, per program, including as root.

Your SSH server and your web server both run as root. They still get different permissions because they are different programs.

## Kernel-level enforcement

No program can execute without an allowlist entry. That entry also controls which files the program can read or write, and which network connections it can make.

The **Dashboard** is the interface. After unattended initial setup, it shows the checklist and what is waiting for review.

### After initial setup

Initial setup runs unattended on first boot of the Root Lock kernel, and again after a kernel update if new startup programs appear. The Dashboard appears when that chain is complete.

| Checklist | Purpose |
|-----------|---------|
| 1. Program Allowlisting | Review and approve programs that need to execute |
| 2. File Access Allowlisting | Review and approve file read/write access for programs |
| 3. Internet Access Allowlisting | Review and approve outbound internet connections |
| 4. Secure Script Launchers | Configure interpreters for Python, Perl, PHP (if applicable) |
| 5. Alert Configuration | Set up notification channels (email, syslog, webhook) |
| 6. Lockdown | Activate Lockdown — locked until the earlier checklist items are complete |

## Reduced kernel footprint

The security industry patches vulnerabilities one at a time. Root Lock removes the features attackers rely on — by design.

Most malware escalates privilege by reaching for the same handful of kernel features: eBPF to hide processes, FUSE to redirect reads, overlay filesystems to shadow directories, userspace LSM frameworks (AppArmor, SMACK, Landlock) to pivot through, and unprivileged user namespaces to gain root without credentials.

The Root Lock kernel is deliberately compiled without them. These primitives are the attack surface, path to root, and bypass vectors the allowlist model exists to close.

A stock Ubuntu kernel ships with over 6,600 loadable modules. The Root Lock kernel ships with 13.

Detection tools like Falco, Cilium Tetragon, and bpftrace watch these features. Root Lock removes them. See [Kernel architecture](../how-it-compares/#kernel-architecture).

Shared-kernel container guests, local eBPF tooling, and rootless containers are not a fit by design. See [Deployment Scenarios](../deployment-scenarios/).

## Features

### 1. Program Allowlist

An allowlist entry says whether a program may execute, which files it may read or write, and which network connections it may make. The kernel requires that entry before the program is permitted to execute.

The Dashboard presents three review queues:

- **Programs queue** (`[p]`) — programs that executed during Setup Mode
- **File Access queue** (`[f]`) — programs that read or wrote files during Setup Mode
- **Internet Access queue** (`[i]`) — programs that made outbound connections during Setup Mode

File access is approved as **read** or **write**. Write includes read. See [Allowlisting Basics](../../allowlisting/allowlisting-basics/) for how the queues group volume.

### 2. Setup Mode and Lockdown

- **Setup Mode**: The kernel logs program executions, file accesses, and network connections without blocking them. Use this mode to build the allowlist.
- **Lockdown**: The kernel enforces the allowlist. Programs without an entry, or that exceed their permissions, are blocked.

Activating Lockdown requires empty review queues, configured alerts, and an active subscription. Type `YES` (case-sensitive) to confirm.

Once Lockdown is applied, the allowlist cannot change while the machine is running, including as root. `YES` starts a probe reboot; a second reboot applies the seal. `[m]` Maintenance is the path to make changes. See [Lockdown](../../mode-switching/).

### 3. File backup and versioning

Root Lock backs up files in designated directories on every write. The version manager can restore a version after encryption, deletion, or modification.

Modern ransomware destroys backup systems before encrypting files — shadow copies and backup agents are typically the first targets. Root Lock's backups are not permission-protected: under Lockdown, the kernel blocks write and delete to the backup directory (`/.hs/b/`) for every program except Root Lock backup tooling, including root.

When an approved program is compromised, recovery starts from the write before the damage, not the last scheduled snapshot.

### 4. Secure Script Launchers

For Python, PHP, and Perl, Secure Script Launchers identify the script being executed so each script gets its own allowlist entry, the same as a compiled program.

## Two setup paths

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers. The Dashboard appears on first login.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Download from heartsecsuite.com, install, and boot the Root Lock kernel. Initial setup runs unattended. Once the Dashboard appears, both paths merge.
{{< /choice-card >}}
{{< /choice-pane >}}

## Is Root Lock right for you?

Root Lock fits production servers, closed appliances, regulated workstations, build and CI infrastructure, and AI agent sandboxes. Containers fit as OCI images built and run off-host. Shared-kernel container guests, local eBPF tooling, and rootless containers are not a fit by design: the kernel omits overlay filesystems, user namespaces, and the BPF syscall because those are the features attackers use to hide, shadow directories, and reach root. See [Deployment Scenarios](../deployment-scenarios/).

If you already run Falco, AppArmor, gVisor, a Linux EDR agent, a SIEM, NDR, or a scanner, see [How Root Lock Compares](../how-it-compares/) and [Security as economics](../security-as-economics/).

Launch a pre-installed cloud instance or download the Local Path package from [heartsecsuite.com](https://heartsecsuite.com). [Getting Started](../../getting-started/) covers the rest.
