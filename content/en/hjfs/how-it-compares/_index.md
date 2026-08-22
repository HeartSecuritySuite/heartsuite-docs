---
title: "What HJFS isolates — and what it complements"
linkTitle: "How it compares"
weight: 35
description: "Per-program file isolation on a stock kernel, the tools that own execution and network, and when to run HJFS alone versus beside Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["hjfs", "comparison", "heartsuite", "deployment", "security"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: Every program on a Linux system can, by default, read any file you own, execute any binary it can reach, and open any network connection — and so can any malware running under that user.

HeartSuite Joint File System (HJFS) addresses one of these three OS-level controls: file read and write access is restricted per program and per version, including as root. Which programs run and which network connections they open stay with [Root Lock by HeartSuite](../../docs/). On a Root Lock kernel, both can share the host.

---

## Root Lock and HJFS: two approaches

Three OS-level controls are unrestricted by default on Linux: file access, network communication, and program execution.

Root Lock and HJFS share the same goal: closing all three. They do it in different ways.

**Root Lock** is production-ready today. It works with the existing Linux OS: you configure allowlist entries, tighten them down, and enable Lockdown. With Lockdown enabled, only explicitly permitted programs, files, and network destinations are allowed. Everything else is blocked.

**HJFS** redesigns the file access layer from the ground up. Every program is confined to its own private storage area at the filesystem level. Prior versions of programs are preserved automatically before any update overwrites them. Cross-program file access is architecturally impossible, not policy-dependent.

Network access mediation and OS-mediated user-file access are planned for subsequent releases.

| Aspect | Root Lock | HJFS | What this means in practice |
|---|---|---|---|
| File isolation | Global filesystem; you add allowlist entries for directories and paths (commonly `/usr/lib`, `/etc`, `/home`) | Per-program isolated storage area; the filesystem blocks any overlap | An allowlist entry that is too wide can share files across programs. HJFS has no overlap path. |
| Handling malicious updates | No automatic program versioning. Data backup applies only to admin-configured directories (default: `/home`) | Per-version isolation: prior executable and libraries are preserved automatically before any update overwrites them | HJFS keeps the clean version of a program (for example, a tainted `sshd`) in its own area. Root Lock restores a prior binary if it was backed up. |
| Network and user-file access | Allowlist entries set once; no per-action prompts | OS-mediated access planned: approval on desktops, policy rules on servers (v1.0 ships file isolation) | Root Lock handles network and user-file access today via static allowlist entries. HJFS v1.0 isolates files; OS-mediated network and user-file access is on the [roadmap](../roadmap/). |
| Executables and updates | Standard Linux paths; updates often require switching to Setup Mode | Separate read-only area for executables; only the official HJFS installer can write to it | HJFS keeps executables in a read-only area. Root Lock uses Setup Mode for updates. |
| Data sharing and deletion | Any program can read, write, or delete anything its allowlist entry permits | Cross-program transfers require an explicit copy utility; programs can only move files to trash, not permanently delete them | HJFS makes cross-program copies explicit. Root Lock permits whatever the allowlist entry names. |
| Lockdown | Enabled via `HS_lockdown.sh`; immutable flags seal key files | Enforced by the filesystem structure — no separate Lockdown step required | Root Lock seals the allowlist. HJFS isolation is the filesystem layout. |

### For production deployments today

**Root Lock** is production-ready for Linux servers. Tight allowlist configuration, Lockdown enabled, and restricted backup directories provide strong real-world protection with existing software.

**HJFS** eliminates entire risk classes — cross-program file leakage, malicious updates reaching prior-version data, programs permanently deleting files — by design, without depending on correct admin configuration. It runs on a standard unmodified kernel.

Network access mediation and execution control are planned for subsequent releases. For those controls today, use Root Lock. On a Root Lock kernel, both can share the host.

---

## What HJFS is

HJFS is per-program file isolation on a standard unmodified kernel. Each program has its own storage area, including as root. Which programs run and which network connections they open stay with [Root Lock](../../docs/).

**Network.** Which connections a program can open is Root Lock's domain. Isolation still limits what data is reachable — a confined program can only read its own files. See [Network exfiltration](../introduction/limits/#network-exfiltration).

**Execution.** Which programs may start is Root Lock's domain. A binary placed on the system can be launched. HJFS still confines what running programs can access. See [Unauthorized program execution](../introduction/limits/#unauthorized-program-execution).

**Encryption.** Files within a program's storage area are readable by that program in plaintext. Isolation controls which programs can reach a file. Use standard disk or volume encryption alongside HJFS for encryption at rest. Per-program isolation still holds on the plaintext files.

**Permissions.** Standard OS permissions are user-based: they answer "can this user read this file?" HJFS is program-based: it answers "did this program create this file?" The two operate at different levels and are complementary.

**Backup.** HJFS automatically backs up every data file each time it is written, to a protected area no program can access. This provides fine-grained version history for ransomware recovery and rollback. Off-site backup, disaster recovery, and compliance-driven backup management stay with dedicated backup infrastructure. The per-write history still holds for files HJFS itself stores.

**Detection.** For behavioural detection, fleet correlation, and incident response, SIEM and NDR tools remain the right answer and should run alongside HJFS.

---

## What HJFS complements

| Adjacent domain | Complementary control |
|---|---|
| Network connections — which destinations a program can reach | [Root Lock](../../docs/network/) on a Root Lock kernel, or network-layer egress controls on a stock kernel |
| Program execution — which binaries are permitted to run | [Root Lock](../../docs/) on a Root Lock kernel, or existing host execution controls on a stock kernel |
| Detection and alerting on suspicious behaviour | SIEM, NDR, endpoint detection tools |
| Secrets isolation within a single program's own storage area | Secrets management tools; [Advanced protection](../advanced-protection/) for user files |
| Encryption of data at rest | Standard disk or volume encryption |
| Off-site backup and disaster recovery | Dedicated backup infrastructure |

HJFS covers file read and write access at the filesystem layer, per program and per version. Root Lock covers network communication and program execution at the kernel layer.

---

## HJFS alone, and on a Root Lock kernel

**HJFS alone** fits deployments where the primary risk is lateral file access across programs, data destruction by ransomware, or supply chain updates that taint data created by prior versions. It runs on a standard kernel — cloud instances with a provider-managed kernel, systems under kernel certification, or organisations that keep a stock kernel.

Network and execution control on that host stay with existing tooling: egress filtering, separate allowlisting, or whatever is already in place.

**On a Root Lock kernel** both can share the host: Root Lock for execute and network, HJFS for per-program file isolation and versioning. Per-program file isolation on a standard kernel still holds when you run HJFS alone.

---

## Positioning relative to common security categories

| Category | Does HJFS apply? | Notes |
|---|---|---|
| Ransomware containment | Yes — primary use case | Ransomware confined to its own area cannot touch files belonging to other programs |
| Supply chain / tainted update | Yes — primary use case | Tainted update receives isolated storage; rollback is a single command |
| Lateral file access between programs | Yes | Structural isolation, not policy-based |
| Network exfiltration | Partial | Limits what data is reachable. Which connections a program can open is Root Lock's domain. |
| Unauthorized program execution | Complementary | Which programs may start is Root Lock's domain. File isolation still holds for whatever runs. |
| Privilege escalation | Complementary | Privilege stays Root Lock's domain. Program storage boundaries still hold. |
| Detection and alerting | Complementary | Use SIEM/NDR alongside |
| Data encryption at rest | Complementary | Use standard disk encryption |

**How HJFS can be circumvented.** HJFS file isolation operates at the filesystem layer, below any running software. No program — regardless of privilege — can cross program storage boundaries while HJFS is present.

The one path around it is physical or serial-console access: an attacker who can remove the HJFS drive removes the isolation layer. Standard physical and console controls apply. See [Security guarantees](../introduction/hjfs-overview/#security-guarantees). File isolation still holds for every software path while the drive is present.
