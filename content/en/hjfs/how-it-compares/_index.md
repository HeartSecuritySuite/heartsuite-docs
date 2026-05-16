---
title: "How HJFS Compares"
linkTitle: "How It Compares"
weight: 35
description: "What HJFS is, what it is not, what it complements, and how to choose between HJFS alone or alongside HeartSuite Core Secure."
categories: ["Essentials"]
tags: ["hjfs", "comparison", "heartsuite", "deployment", "security"]
type: docs
toc: true
menu:
  main:
    identifier: "hjfs-how-it-compares"
    weight: 40
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: HJFS enforces one thing at the filesystem layer — no program can access files belonging to another program, and no version of a program can access files belonging to a different version. The question is not "can this user access this file?" but "did this specific program version create it?" This page describes what follows from that: what other controls HJFS does not provide, what it works alongside, and how to decide whether to deploy it with or without HeartSuite Core Secure.

---

## What HJFS is not

Understanding what HJFS does not do is as important as understanding what it does.

**HJFS is not network security.** HJFS v1.0 does not control which network connections a program can open. A confined program can still reach any network destination. Isolation limits the data that can be exfiltrated — a confined program can only read its own files — but it does not block the outbound connection itself. See [Network exfiltration](../introduction/limits/#network-exfiltration).

**HJFS is not program execution control.** HJFS does not gate which programs can run. A binary placed on the system can be executed. HJFS confines what running programs can access; it does not decide which programs are permitted to run in the first place. See [Unauthorized program execution](../introduction/limits/#unauthorized-program-execution).

**HJFS is not filesystem encryption.** HJFS does not encrypt data at rest. Files within a program's storage area are readable by that program in plaintext. Isolation controls which programs can reach a file — it does not protect the file's contents from a program that legitimately owns it. For encryption at rest, use standard disk or volume encryption alongside HJFS.

**HJFS is not a traditional permissions system.** Standard OS permissions (user, group, other) are user-based: they answer "can this user read this file?" HJFS is program-based: it answers "did this program create this file?" The two are complementary and operate at different levels.

**HJFS is not a general-purpose backup system.** HJFS automatically backs up every data file every time it is written, to a protected area no program can access. This provides fine-grained version history that supports ransomware recovery and rollback. It is not a substitute for off-site backup, disaster recovery, or backup management for compliance purposes — those remain separate requirements.

**HJFS is not a detection system.** HJFS does not alert on suspicious behaviour. It constrains what running programs can do. For behavioural detection, fleet correlation, and incident response, SIEM and NDR tools remain the right answer and should run alongside HJFS.

---

## What HJFS complements

| Gap HJFS leaves open | Complementary control |
|---|---|
| Network connections — which destinations a program can reach | HeartSuite Core Secure (kernel-level network allowlisting) |
| Program execution — which binaries are permitted to run | HeartSuite Core Secure (kernel-level program allowlisting) |
| Detection and alerting on suspicious behaviour | SIEM, NDR, endpoint detection tools |
| Secrets isolation within a single program's own storage area | Secrets management tools; [Advanced Protection](../advanced-protection/) for user files |
| Encryption of data at rest | Standard disk or volume encryption |
| Off-site backup and disaster recovery | Dedicated backup infrastructure |

HJFS and HeartSuite Core Secure address complementary OS-level controls: file access, network communication, and program execution. HJFS covers file access and per-version isolation at the filesystem layer. Core Secure covers network communication and program execution at the kernel layer. Together they address all three OS-level plenary powers.

---

## HJFS alone vs. HJFS with HeartSuite Core Secure

**HJFS alone** is appropriate when:

- The deployment environment requires a standard kernel — cloud instances where the kernel is managed by the provider, systems subject to kernel certification requirements, or organisations with strict change-control policies around the kernel.
- The primary risk is lateral file access across programs, data destruction by ransomware, or supply chain updates that taint data created by prior versions.
- Network and execution control are addressed through other means (network-layer egress filtering, separate allowlisting tools) or are not the primary concern.

**HJFS alongside HeartSuite Core Secure** provides the most complete coverage for production server and regulated deployments:

- Core Secure handles which programs can run and which network connections they can open — at the kernel level, regardless of privilege.
- HJFS adds per-program, per-version file isolation and automatic data file backup — at the filesystem layer, on a standard kernel if needed.
- Together they cover all three OS-level enforcement dimensions that malware typically exploits.

**HeartSuite Core Secure without HJFS** is appropriate when kernel-level enforcement is available and per-version file isolation is not required. Core Secure's allowlisting and network gating provide strong protection without HJFS. HJFS adds the per-version dimension and automatic data file backup, which are most valuable in supply chain and regulated environments.

---

## Positioning relative to common security categories

| Category | Does HJFS apply? | Notes |
|---|---|---|
| Ransomware containment | Yes — primary use case | Ransomware confined to its own area cannot encrypt files belonging to other programs |
| Supply chain / tainted update | Yes — primary use case | Tainted update receives isolated storage; rollback is a single command |
| Lateral file access between programs | Yes | Structural isolation, not policy-based |
| Network exfiltration | Partial | Limits what data is reachable; does not block the connection |
| Unauthorized program execution | No | Not in scope for v1.0 |
| Privilege escalation | No | Not a filesystem-layer concern |
| Detection and alerting | No | Use SIEM/NDR alongside |
| Data encryption at rest | No | Use standard disk encryption |
