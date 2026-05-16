---
title: "How HJFS Compares"
linkTitle: "How It Compares"
weight: 35
description: "What HJFS is, what it is not, what it complements, and how to choose between HJFS alone or alongside HeartSuite Core Secure."
categories: ["Essentials"]
tags: ["hjfs", "comparison", "heartsuite", "deployment", "security"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: Every program on a Linux system can, by default, read any file the user owns, execute any binary it can reach, and open any network connection — and so can any malware running under that user. HJFS addresses one of these three OS-level controls: file read and write access is restricted per program and per version, including when the program runs as root. The question HJFS answers is not "can this user access this file?" but "did this specific program version create it?" Execution control and network connection control are outside HJFS's scope. HeartSuite Core Secure handles those. This page describes what HJFS controls, what it leaves open, how it can be defeated, and how to decide whether to deploy it alongside Core Secure.

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
| Network connections — which destinations a program can reach | HeartSuite Core Secure (kernel-level network allowlisting) |
| Program execution — which binaries are permitted to run | HeartSuite Core Secure (kernel-level program allowlisting) |
| Detection and alerting on suspicious behaviour | SIEM, NDR, endpoint detection tools |
| Secrets isolation within a single program's own storage area | Secrets management tools; [Advanced Protection](../advanced-protection/) for user files |
| Encryption of data at rest | Standard disk or volume encryption |
| Off-site backup and disaster recovery | Dedicated backup infrastructure |

HJFS and HeartSuite Core Secure address complementary OS-level controls. HJFS covers file read and write access at the filesystem layer, with per-program and per-version isolation. Core Secure covers network communication and program execution at the kernel layer. Together they address all three OS-level controls that malware typically exploits.

---

## HJFS alone vs. HJFS with HeartSuite Core Secure

**HJFS alone** fits deployments where the primary risk is lateral file access across programs, data destruction by ransomware, or supply chain updates that taint data created by prior versions. It runs on a standard kernel, which makes it the right choice for cloud instances where the kernel is provider-managed, systems under kernel certification requirements, or organisations with strict change-control policies. Network and execution control are left to other means — network-layer egress filtering, separate allowlisting tools, or existing controls already in place.

**HJFS alongside HeartSuite Core Secure** is the right fit for production servers and regulated environments that need the full picture. Core Secure blocks unauthorised program execution and network connections at the kernel level, regardless of privilege. HJFS adds per-program, per-version file isolation and automatic data file backup at the filesystem layer. Together they close all three OS-level controls.

**HeartSuite Core Secure without HJFS** is appropriate when kernel-level blocking is available and per-version file isolation is not required. Core Secure's program allowlisting and network blocking provide strong protection on their own. HJFS adds the per-version dimension and automatic data file backup, which matter most in supply chain scenarios and regulated environments.

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
