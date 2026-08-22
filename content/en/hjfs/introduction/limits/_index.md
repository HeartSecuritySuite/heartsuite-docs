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

**Overview**: A compromised program can still hurt the files it already owns. HeartSuite Joint File System (HJFS) still keeps that program inside its own storage area, including as root.

No program can read or write files belonging to another. This page states where that boundary holds, and what handles the rest.

---

## An attacker uses a compromised program within its own storage area

**The scenario.** An attacker gains control of a running program — through a vulnerability, a malicious update, or a backdoor compiled into an approved binary. The program is already running and has legitimate access to its own storage area.

**What HJFS does.** Files belonging to other programs are not reachable — not by name, not by path enumeration, not by any program. Damage stops at the compromised program's own area.

Within that area, every write is automatically backed up to a protected location no program can access. Recovery is always available: the restore utility returns any file to any prior version, including versions created before the compromise.

**What it does not cover.** If the attacker reads sensitive data from the program's own files and exfiltrates it over the network, this particular gate does not apply to the outbound connection. File isolation still holds: other programs' files stay unreachable. [Root Lock by HeartSuite](../../../docs/) closes the network gap. See [Network exfiltration](#network-exfiltration) below.

---

## Network exfiltration

**The scenario.** A compromised program reads data from its own storage area, then opens an outbound connection to an attacker-controlled server.

**What HJFS does.** The program can only reach files within its own storage area. Credentials, documents, and configuration files belonging to other programs are inaccessible. The data available for exfiltration is bounded by isolation.

**What it does not cover.** If a program holds data in its own storage area and has an open network path, this particular gate does not apply to that connection. The reachable set is still that program's own files. Root Lock gates outbound destinations per program. See [Root Lock](../../../docs/network/).

---

## Unauthorized program execution

**The scenario.** An attacker downloads a tool — a privilege escalation script, a credential dumper, a reverse shell — and attempts to run it.

**What HJFS does.** HJFS confines what a running program can open. Files belonging to other programs stay unreachable even if a new binary starts.

**What it does not cover.** If an attacker downloads a new binary and launches it, this particular gate does not apply to execution. Once it is running, HJFS still confines it to its own storage area. Root Lock requires any new binary to have an allowlist entry before it can execute. See [Root Lock](../../../docs/).

---

## Sensitive data within a program's own storage area

**The scenario.** A program stores credentials, API keys, or other secrets in its own data files. A malicious update to that program — or an attacker who has compromised it — reads those files.

**What HJFS does.** No other program can reach those files. The isolation is between programs, not between a program and its own data.

**What it does not cover.** If a malicious version of a program reads secrets stored in that program's own files, this particular gate does not apply inside that area. Files belonging to other programs remain unreachable. Advanced protection further limits silent reads of user-facing files: those open only through an OS-mediated dialog. Internal files remain accessible to the program by name. See [Advanced protection](../../advanced-protection/).

---

## Physical access

Physical or serial-console access is the path that defeats HJFS file isolation. All software-based attempts to cross program storage boundaries are prevented at the filesystem layer.

The specific defeat path is removing the HJFS drive. Standard facility controls — locked racks, access logging, console IAM, physical security policies — are the appropriate countermeasure. File isolation still holds for every software path while the drive is present. See [Security guarantees](../hjfs-overview/#security-guarantees).

---

## Complementary tools

HJFS provides filesystem-level file isolation. Network monitoring, detection, and execution control address different layers and work alongside it.

| Adjacent domain | Complementary tool |
|---|---|
| Network exfiltration | Root Lock (kernel-level network allowlisting) or network-layer egress controls |
| Unauthorized program execution | Root Lock (kernel-level program allowlisting) |
| Detection within approved boundaries | SIEM, NDR, endpoint detection tools |
| Secrets management within a program | Secrets management tools; Advanced protection for user files |

On a Root Lock kernel, both can share the host. See [HJFS and Root Lock: what each covers](../hjfs-overview/#hjfs-and-root-lock-what-each-covers).
