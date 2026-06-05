---
title: "How HJFS Compares"
linkTitle: "How It Compares"
weight: 35
description: "What HJFS is, what it is not, what it complements, and how to choose between HJFS alone or alongside Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["hjfs", "comparison", "heartsuite", "deployment", "security"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: Every program on a Linux system can, by default, read any file the user owns, execute any binary it can reach, and open any network connection — and so can any malware running under that user. HJFS addresses one of these three OS-level controls: file read and write access is restricted per program and per version, including when the program runs as root. The question HJFS answers is not "can this user access this file?" but "did this specific program version create it?" Execution control and network connection control are outside HJFS's scope. Root Lock by HeartSuite handles those dimensions but is not currently compatible with HJFS. This page describes what HJFS controls, what it leaves open, how it can be defeated, and how to think about complementary controls.

---

## Root Lock by HeartSuite and HJFS: two approaches

Three OS-level controls are unrestricted by default on Linux: file access, network communication, and program execution. Every program can open any user file, connect to any network destination, and launch any binary it can reach — and so can any malware running under the same user.

Root Lock by HeartSuite and HJFS share the same goal: closing all three of those controls. They do it in different ways.

**Root Lock by HeartSuite** is production-ready today. It works with the existing Linux OS: you configure allowlist entries, tighten them down, and enable Lockdown. With Lockdown enabled, only explicitly permitted programs, files, and network destinations are allowed. Everything else is blocked.

**HJFS** redesigns the file access layer from the ground up. Every program is confined to its own private storage area at the filesystem level. Prior versions of programs are preserved automatically before any update overwrites them. Cross-program file access is architecturally impossible, not policy-dependent. Network access mediation and OS-mediated user-file access are planned for subsequent releases.

| Aspect | Root Lock by HeartSuite | HJFS | What This Means in Practice |
|---|---|---|---|
| File isolation | Global filesystem; the admin adds allowlist entries for directories and paths (commonly `/usr/lib`, `/etc`, `/home`) | Per-program isolated storage area; the filesystem blocks any overlap | Core Secure can allow accidental cross-program access if allowlist entries are not kept tight. HJFS makes overlap impossible by design. |
| Handling malicious updates | No automatic program versioning. Data backup applies only to admin-configured directories (default: `/home`) | Per-version isolation: prior executable and libraries are preserved automatically before any update overwrites them | HJFS stops a supply-chain attack from destroying the clean version of a program (for example, a tainted `sshd`). Core Secure requires the admin to detect the problem and manually restore the prior binary if it was backed up. |
| Network and user-file access | Allowlist entries set once; no per-action prompts | OS-mediated access planned: user approval on desktops, policy rules on servers (not in v1.0 scope) | Core Secure handles network and user-file access today via static allowlist entries. HJFS will prevent programs from silently connecting anywhere or touching user files without explicit permission once that capability ships. |
| Executables and updates | Standard Linux paths; updates often require switching to Setup Mode | Separate read-only area for executables; only the official HJFS installer can write to it | Core Secure depends on admin discipline for update discipline. HJFS enforces the separation automatically. |
| Data sharing and deletion | Any program can read, write, or delete anything its allowlist entry permits | Cross-program transfers require an explicit copy utility; programs can only move files to trash, not permanently delete them | Core Secure is more convenient to administer but places more risk on correct allowlist configuration. HJFS forces deliberate, auditable data movement. |
| Lockdown | Enabled via `HS_lockdown.sh`; immutable flags seal key files | Enforced by the filesystem structure — no separate Lockdown step required | Core Secure provides strong immediate Lockdown. HJFS provides stronger long-term structural guarantees. |

### For production deployments today

**Root Lock by HeartSuite** is production-ready for Linux servers. Tight allowlist configuration, Lockdown enabled, and restricted backup directories provide strong real-world protection with existing software.

**HJFS** eliminates entire risk classes — cross-program file leakage, malicious updates reaching prior-version data, programs permanently deleting files — by design, without depending on correct admin configuration. It runs on a standard unmodified kernel. Network access mediation and execution control are planned for subsequent releases; for those controls today, use Root Lock by HeartSuite.

The two products are not currently compatible and cannot be deployed together.

---

## What HJFS is not

**HJFS is not network security.** HJFS does not control which network connections a program can open. A confined program can still reach any network destination. Isolation limits what data is reachable — a confined program can only read its own files — but the outbound connection itself is not blocked by HJFS. See [Network exfiltration](../introduction/limits/#network-exfiltration).

**HJFS is not program execution control.** HJFS does not gate which programs can run. A binary placed on the system can be executed. HJFS confines what running programs can access; it does not decide which programs are permitted to run in the first place. See [Unauthorized program execution](../introduction/limits/#unauthorized-program-execution).

**HJFS is not filesystem encryption.** Files within a program's storage area are readable by that program in plaintext. Isolation controls which programs can reach a file — it does not protect the file's contents from a program that legitimately owns it. Use standard disk or volume encryption alongside HJFS for encryption at rest.

**HJFS is not a traditional permissions system.** Standard OS permissions are user-based: they answer "can this user read this file?" HJFS is program-based: it answers "did this program create this file?" The two operate at different levels and are complementary.

**HJFS is not a general-purpose backup system.** HJFS automatically backs up every data file each time it is written, to a protected area no program can access. This provides fine-grained version history for ransomware recovery and rollback. It is not a substitute for off-site backup, disaster recovery, or compliance-driven backup management.

**HJFS is not a detection system.** HJFS does not alert on suspicious behaviour. For behavioural detection, fleet correlation, and incident response, SIEM and NDR tools remain the right answer and should run alongside HJFS.

---

## What HJFS complements

| Gap HJFS leaves open | Complementary control |
|---|---|
| Network connections — which destinations a program can reach | Dedicated network allowlisting tools; Root Lock by HeartSuite handles this but is not currently compatible with HJFS |
| Program execution — which binaries are permitted to run | Dedicated execution allowlisting tools; Root Lock by HeartSuite handles this but is not currently compatible with HJFS |
| Detection and alerting on suspicious behaviour | SIEM, NDR, endpoint detection tools |
| Secrets isolation within a single program's own storage area | Secrets management tools; [Advanced Protection](../advanced-protection/) for user files |
| Encryption of data at rest | Standard disk or volume encryption |
| Off-site backup and disaster recovery | Dedicated backup infrastructure |

HJFS and Root Lock by HeartSuite address complementary OS-level controls. HJFS covers file read and write access at the filesystem layer, with per-program and per-version isolation. Core Secure covers network communication and program execution at the kernel layer. The two products are not currently compatible and cannot be deployed together.

---

## HJFS alone vs. HJFS with Root Lock by HeartSuite

**HJFS alone** fits deployments where the primary risk is lateral file access across programs, data destruction by ransomware, or supply chain updates that taint data created by prior versions. It runs on a standard kernel, which makes it the right choice for cloud instances where the kernel is provider-managed, systems under kernel certification requirements, or organisations with strict change-control policies. Network and execution control are left to other means — network-layer egress filtering, separate allowlisting tools, or existing controls already in place.

**Root Lock by HeartSuite** covers network connection and program execution control at the kernel level. It is not currently compatible with HJFS and cannot be deployed alongside it. Organisations that need file isolation together with execution and network control should use HJFS with a compatible dedicated allowlisting tool for network and execution coverage.

---

## Positioning relative to common security categories

| Category | Does HJFS apply? | Notes |
|---|---|---|
| Ransomware containment | Yes — primary use case | Ransomware confined to its own area cannot touch files belonging to other programs |
| Supply chain / tainted update | Yes — primary use case | Tainted update receives isolated storage; rollback is a single command |
| Lateral file access between programs | Yes | Structural isolation, not policy-based |
| Network exfiltration | Partial | Limits what data is reachable; does not block the connection |
| Unauthorized program execution | No | Not in scope for v1.0 |
| Privilege escalation | No | Not a filesystem-layer concern |
| Detection and alerting | No | Use SIEM/NDR alongside |
| Data encryption at rest | No | Use standard disk encryption |

**How HJFS can be circumvented**: HJFS file isolation operates at the filesystem layer, below any running software. No program — regardless of privilege — can cross program storage boundaries while HJFS is present. The one path around it is physical: an attacker with physical access to the machine can delete the HJFS drive, removing the isolation layer entirely. Standard physical access controls apply. See [Security guarantees](../introduction/hjfs-overview/#security-guarantees).
