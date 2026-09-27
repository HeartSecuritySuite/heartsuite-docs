---
title: "Where the file isolation boundary holds"
linkTitle: "Protection limits"
weight: 3
description: "Where HJFS file isolation holds, where a program can still hurt you inside its own area, and what to run alongside it."
categories: ["Essentials"]
tags: ["hjfs", "security", "limits", "exfiltration", "network", "in-practice"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: HeartSuite Joint File System (HJFS) keeps every program inside its own storage area, including programs running as root, so no program can read or write files belonging to another. A compromised program can still damage the files it already owns.

This page describes where the boundary holds, what a compromised program can still do inside it, and which tools cover the rest.

---

## An attacker uses a compromised program within its own storage area

**The scenario.** An attacker gains control of a running program — through a vulnerability, a malicious update, or a backdoor compiled into an approved binary. The program is already running and has legitimate access to its own storage area.

**What HJFS does.** The compromised program cannot reach files belonging to other programs, either by name or by path enumeration, so the damage stops at its own storage area.

Within that area, every write is automatically backed up to a protected location no program can access. Recovery is always available: the restore utility returns any file to any prior version, including versions created before the compromise.

**What it does not cover.** HJFS does not control network connections, so the attacker can read sensitive data from the program's own files and send it out over the network. [Root Lock by HeartSuite](../../../rootlock/) covers that connection; see [Network exfiltration](#network-exfiltration) below.

---

## Network exfiltration

**The scenario.** A compromised program reads data from its own storage area, then opens an outbound connection to an attacker-controlled server.

**What HJFS does.** The program can reach only the files in its own storage area, so credentials, documents, and configuration files belonging to other programs are out of its reach. What the attacker can send out is limited to that program's own files.

**What it does not cover.** HJFS does not decide which destinations a program may connect to, so it does not stop the upload itself. Root Lock gates outbound destinations per program. See [Root Lock](../../../rootlock/network/).

---

## Unauthorized program execution

**The scenario.** An attacker downloads a tool — a privilege escalation script, a credential dumper, a reverse shell — and attempts to run it.

**What HJFS does.** HJFS confines what a running program can open, so a newly started tool cannot reach files belonging to other programs.

**What it does not cover.** If an attacker downloads a new binary and launches it, this particular gate does not apply to execution. Once it is running, HJFS still confines it to its own storage area. Root Lock requires any new binary to have an allowlist entry before it can execute. See [Root Lock](../../../rootlock/).

---

## Sensitive data within a program's own storage area

**The scenario.** A program stores credentials, API keys, or other secrets in its own data files. An attacker who has compromised the running version of that program reads those files.

**What HJFS does.** No other program can reach those files. A malicious update is a new version with its own empty storage area, so it reaches those secrets only if you copy them into its area with the file transfer utility. See [Walkthrough](../walkthrough/).

**What it does not cover.** The isolation is between programs and between versions, not between a running version and its own data, so a compromised version can read the secrets stored in its own files. Advanced protection narrows this for user-facing files, which the program can open only through an OS-mediated dialog, so it cannot read them silently. Internal files remain accessible to the program by name. See [Advanced protection](../../advanced-protection/).

---

## Physical access

Physical access to the drive is the path that defeats HJFS file isolation: removing the HJFS drive and reading it elsewhere bypasses it. While the drive is present, the filesystem layer refuses every software attempt to cross program storage boundaries.

Standard facility controls — locked racks, access logging, console IAM, physical security policies — are the appropriate countermeasure for the drive itself. See [Security guarantees](../hjfs-overview/#security-guarantees).

---

## Complementary tools

HJFS provides filesystem-level file isolation. Network monitoring, detection, and execution control address different layers and work alongside it.

| Adjacent domain | Complementary tool |
|---|---|
| Network exfiltration | Root Lock (kernel-level network allowlisting) or network-layer egress controls |
| Unauthorized program execution | Root Lock (kernel-level program allowlisting) |
| Detection within approved boundaries | SIEM, NDR, endpoint detection tools |
| Secrets management within a program | Secrets management tools; Advanced protection for user files |

On a Root Lock kernel, HJFS and Root Lock can share the host. See [HJFS and Root Lock: what each covers](../hjfs-overview/#hjfs-and-root-lock-what-each-covers).
