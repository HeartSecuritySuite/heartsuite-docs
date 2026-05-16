---
title: "What HJFS Does and Does Not Cover"
linkTitle: "Protection Limits"
weight: 3
description: "Where HJFS's file isolation holds, where it does not, and what to use alongside it."
categories: ["Essentials"]
tags: ["hjfs", "security", "limits", "exfiltration", "network", "in-practice"]
type: docs
toc: true
menu:
  main:
    parent: "hjfs-introduction"
    identifier: "hjfs-limits"
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: HJFS enforces one thing: file access is per program and per version — no program can access files belonging to another, regardless of user privilege. An attacker who stays entirely within a compromised program's own storage area is constrained but not stopped. This page describes exactly where the boundary is, and what handles the rest.

---

## An attacker uses a compromised program within its own storage area

**The scenario.** An attacker gains control of a running program — through a vulnerability, a malicious update, or a backdoor compiled into an approved binary. The program is already running and has legitimate access to its own storage area.

**What HJFS enforces.** The attacker is confined to that program's storage area. Files belonging to other programs are not reachable — not readable, not writable, not enumerable. The blast radius is structurally bounded.

Within the program's own storage area, the attacker can read, modify, and move files to trash. Every write is automatically backed up by HJFS to a protected area no program can access. Recovery is always available: the restore utility returns any data file to any prior version, including versions created before the compromise.

**What HJFS does not cover.** If the attacker reads sensitive data from the program's own files and exfiltrates it over the network, HJFS v1.0 does not block the outbound connection. File isolation limits what data is reachable — but once data is in memory, the network is open. See [Network exfiltration](#network-exfiltration) below.

---

## Network exfiltration

**The scenario.** A compromised program reads data from its own storage area, then opens an outbound network connection to send it to an attacker-controlled server.

**What HJFS enforces.** The program can only reach files within its own storage area. It cannot access credentials, documents, or configuration files belonging to other programs. The data it can exfiltrate is bounded by its isolation.

**What HJFS does not cover.** HJFS v1.0 has no network controls. A program that has data in its own storage area and an open network path can exfiltrate that data. The isolation limits the scope of what can be stolen — it does not prevent transmission.

For network-level enforcement — per-program control over which destinations a program can connect to — [HeartSuite Core Secure](../../../docs/network/) provides kernel-level gating of outbound connections. Used alongside HJFS, it closes this gap.

---

## Unauthorized program execution

**The scenario.** An attacker downloads a tool — a privilege escalation script, a credential dumper, a reverse shell — and attempts to run it.

**What HJFS enforces.** HJFS confines what running programs can access. It does not gate which programs can run.

**What HJFS does not cover.** HJFS v1.0 has no execution controls. A program placed on the system can be launched. For kernel-level program execution control — which requires a new binary to have an allowlist entry before it can run — [HeartSuite Core Secure](../../../docs/) handles this. The two products address complementary layers: HJFS at the filesystem, Core Secure at the kernel.

---

## Sensitive data within a program's own storage area

**The scenario.** A program stores credentials, API keys, or other secrets in its own data files. A malicious update to that same program — or an attacker who has compromised it — reads those files.

**What HJFS enforces.** No other program can reach those files. The isolation is between programs.

**What HJFS does not cover.** HJFS does not isolate a program from its own data. A malicious version of a program has the same access to that program's storage area as the legitimate version. Secrets stored in a program's own files are accessible to any version of that program — including a compromised one.

[Advanced protection](../../advanced-protection/) partially addresses this for user-facing files: under the advanced tier, user files can only be opened through an OS-mediated dialog, limiting silent reads even within the program. Internal files remain accessible to the program by name.

---

## Physical access

HJFS enforcement is defeated by physical access to the machine combined with deletion of the HJFS drive. This is documented in [Security Guarantees](../hjfs-overview/#security-guarantees). Protect physical access to systems running HJFS through standard facility controls.

---

## Complementary tools

HJFS is a filesystem-level protection layer. It does not replace detection, network monitoring, or execution control.

| Gap | Complementary tool |
|---|---|
| Network exfiltration | HeartSuite Core Secure (kernel-level network allowlisting) or network-layer egress controls |
| Unauthorized program execution | HeartSuite Core Secure (kernel-level program allowlisting) |
| Detection within approved boundaries | SIEM, NDR, endpoint detection tools |
| Secrets management within a program | Secrets management tools; Advanced Protection for user files |

For the full picture of how Core Secure and HJFS work together, see [How HJFS Differs from HeartSuite Core Secure](../hjfs-overview/#how-hjfs-differs-from-heartsuite-core-secure).
