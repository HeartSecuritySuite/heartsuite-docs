---
title: "What HJFS Does and Does Not Cover"
linkTitle: "Protection Limits"
weight: 3
description: "Where HJFS's file isolation holds, where it does not, and what to use alongside it."
categories: ["Essentials"]
tags: ["hjfs", "security", "limits", "exfiltration", "network", "in-practice"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: HJFS enforces one thing: file read/write access is per program and per version — including programs running as root. No program can read or write files belonging to another. An attacker who stays within a compromised program's own storage area is constrained but not stopped. This page states exactly where the boundary is, and what handles the rest.

---

## An attacker uses a compromised program within its own storage area

**The scenario.** An attacker gains control of a running program — through a vulnerability, a malicious update, or a backdoor compiled into an approved binary. The program is already running and has legitimate access to its own storage area.

**What HJFS enforces.** Files belonging to other programs are not reachable — not by name, not by path enumeration, not by any program on the system. The blast radius is structurally bounded to the compromised program's own area.

Within that area, every write is automatically backed up to a protected location no program can access. Recovery is always available: the restore utility returns any file to any prior version, including versions created before the compromise.

**What HJFS does not cover.** If the attacker reads sensitive data from the program's own files and exfiltrates it over the network, the outbound connection is outside HJFS's scope. Once data is in memory, the network path is open. HeartSuite Core Secure closes this gap. See [Network exfiltration](#network-exfiltration) below.

---

## Network exfiltration

**The scenario.** A compromised program reads data from its own storage area, then opens an outbound connection to an attacker-controlled server.

**What HJFS enforces.** The program can only reach files within its own storage area. Credentials, documents, and configuration files belonging to other programs are inaccessible. The data available for exfiltration is bounded by isolation.

**What HJFS does not cover.** HJFS controls what data a program can reach; it does not control which connections a program can open. A program that holds data in its own storage area and has an open network path can exfiltrate that data. HeartSuite Core Secure provides kernel-level gating of outbound connections, with per-program control over which destinations a program can reach. Used alongside HJFS, it closes this gap. See [HeartSuite Core Secure](../../../docs/network/).

---

## Unauthorized program execution

**The scenario.** An attacker downloads a tool — a privilege escalation script, a credential dumper, a reverse shell — and attempts to run it.

**What HJFS enforces.** HJFS controls what running programs can access. Execution control is HeartSuite Core Secure's domain. This is a deliberate division of layers, not a gap.

**What HJFS does not cover.** A binary placed on the system can be launched. HeartSuite Core Secure requires any new binary to have an allowlist entry before it can execute. HJFS operates at the filesystem layer; Core Secure operates at the kernel. See [HeartSuite Core Secure](../../../docs/).

---

## Sensitive data within a program's own storage area

**The scenario.** A program stores credentials, API keys, or other secrets in its own data files. A malicious update to that program — or an attacker who has compromised it — reads those files.

**What HJFS enforces.** No other program can reach those files. The isolation is between programs, not between a program and its own data.

**What HJFS does not cover.** A malicious version of a program has the same access to that program's storage area as the legitimate version. Secrets stored in a program's own files are accessible to any version of that program, including a compromised one.

Advanced Protection partially closes this gap for user-facing files. Under the advanced tier, user files can only be opened through an OS-mediated dialog, limiting silent reads even within the program. Internal files remain accessible to the program by name. See [Advanced Protection](../../advanced-protection/).

---

## Physical access

Physical access is the only path that defeats HJFS file isolation. All software-based attempts to cross program storage boundaries are prevented at the filesystem layer. The specific defeat path is physical access combined with deletion of the HJFS drive. Standard facility controls — locked racks, access logging, physical security policies — are the appropriate countermeasure. See [Security guarantees](../hjfs-overview/#security-guarantees) for details.

---

## Complementary tools

HJFS provides filesystem-level file isolation. Network monitoring, detection, and execution control address different layers and work alongside it.

| Gap | Complementary tool |
|---|---|
| Network exfiltration | HeartSuite Core Secure (kernel-level network allowlisting) or network-layer egress controls |
| Unauthorized program execution | HeartSuite Core Secure (kernel-level program allowlisting) |
| Detection within approved boundaries | SIEM, NDR, endpoint detection tools |
| Secrets management within a program | Secrets management tools; Advanced Protection for user files |

For the full picture of how Core Secure and HJFS work together, see [HJFS and HeartSuite Core Secure: what each covers](../hjfs-overview/#hjfs-and-heartsuite-core-secure-what-each-covers).
