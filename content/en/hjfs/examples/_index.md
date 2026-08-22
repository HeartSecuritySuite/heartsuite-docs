---
title: "When ransomware cannot reach another program's files"
linkTitle: "Attack examples"
weight: 30
description: "How HJFS is designed to contain a separate ransomware binary or a tainted update's files, and the residual when a program hurts files it already owns."
categories: ["Essentials"]
tags: ["hjfs", "security", "malware", "ransomware", "cve", "examples"]
type: docs
toc: true
---

> **Prototype**: The protections described on this page reflect HJFS design intent. HJFS is under active development. Incident facts below are taken from public reporting, not from HeartSuite exploitation tests.

**Overview**: When a program is compromised, damage usually spreads through every file that user can reach. HeartSuite Joint File System (HJFS) is designed to stop that spread at the compromised program's storage area.

These incidents are here so the residual is visible.

Which programs run and which network connections they open stay with [Root Lock by HeartSuite](../../docs/). On a Root Lock kernel, both can share the host. A program can still hurt files it already owns — see [Protection limits](../introduction/limits/).

---

## WannaCry ransomware (CVE-2017-0144)

**What happened.** An SMB vulnerability let malware spread across networks and encrypt files on every system it reached. Over 200,000 systems across 150 countries were affected.

**What the campaign needed.** A new encryptor process that could open files belonging to other programs on the same host, plus a network worm path.

**What HJFS is designed to do.** Confine that encryptor to its own storage area. It cannot read or write files belonging to other programs, so encryption of *those* files stops at that boundary.

**Residual.** Network spread stays with [Root Lock](../../docs/). Files the encryptor already owns in its own area can still be encrypted. Automatic backup recovers those files. Isolation still stops that process from opening another program's files.

---

## Log4Shell (CVE-2021-44228)

**What happened.** A remote code execution flaw in the Log4j library let attackers inject and run arbitrary code, then use that foothold to reach other systems.

**What the campaign needed.** Code running inside an already-trusted process, then a path from that process to other programs' files or to the network.

**What HJFS is designed to do.** Keep injected code inside the exploited process's storage area. No other program's files are reachable from there. Version isolation lets the vulnerable library be identified and rolled back without touching data from other versions.

**Residual.** The RCE still happens inside the exploited process. Outbound callbacks stay with [Root Lock](../../docs/). Secrets already in that process's own files remain readable by it. Isolation still stops that process from opening another program's files.

---

## SolarWinds supply chain attack

**What happened.** A tainted software update carried a backdoor that gave attackers persistent access for exfiltration and espionage over months. Roughly 18,000 organisations were affected, including multiple US federal agencies.

**What the campaign needed.** A new binary (or a new version of a trusted binary) that could still open files written by the legitimate version, plus months of quiet access.

**What HJFS is designed to do.** Identify program versions by cryptographic hash, so the tainted update gets its own isolated storage area — separate from the legitimate version's data. Roll back to a prior verified version. Data written under the legitimate version stays in that version's storage area.

**Residual.** Data written *while the tainted version was active* lives in the tainted version's area. Automatic backup is the path for that window — see [The malicious sleeper](../introduction/hjfs-overview/#the-malicious-sleeper-attack). Network exfiltration from the backdoor's own files stays with [Root Lock](../../docs/). Isolation still keeps that version out of the legitimate version's files.

---

## Colonial Pipeline ransomware

**What happened.** Compromised credentials gave attackers the access they needed to deploy ransomware that encrypted operational data and forced a six-day shutdown of the largest fuel pipeline in the United States.

**What the campaign needed.** Either a new encryptor binary that could open operational files, or encryption from inside the programs that already owned those files.

**What HJFS is designed to do.** If the encryptor is a separate program, it cannot reach files belonging to other programs.

**Residual.** If encryption ran inside the operational software that already owned those files, that is [a program hurting files it already owns](../introduction/limits/#an-attacker-uses-a-compromised-program-within-its-own-storage-area). Credential theft and lateral movement stay with [Root Lock](../../docs/). Isolation still stops a separate encryptor from opening those files.

---

## MOVEit Transfer (CVE-2023-34362)

**What happened.** SQL injection in a managed file transfer application enabled mass data theft and encryption. Over 2,000 organisations across government, healthcare, and financial sectors were affected.

**What the campaign needed.** Code running inside the file-transfer application that already stored the files being stolen.

**What HJFS is designed to do.** A *secondary* encryptor spawned as a different program still cannot open files it does not own.

**Residual.** Theft from inside MOVEit itself is in-process access to that program's own storage area. Isolation is between programs, not between a program and its own data. See [Sensitive data within a program's own storage area](../introduction/limits/#sensitive-data-within-a-programs-own-storage-area). A secondary encryptor still cannot open files it does not own.

---

## XZ Utils supply chain attack (CVE-2024-3094)

**What happened.** A patient attacker spent approximately two years as a trusted contributor to the XZ Utils open-source compression library, gradually building commit access before inserting a backdoor in versions 5.6.0 and 5.6.1.

The backdoor was designed to allow unauthorized SSH authentication on affected systems. It was discovered in March 2024 weeks before reaching stable Linux distributions.

**What the campaign needed.** A new library hash (a new HJFS version) plus a path from that version to prior data, or to SSH authentication.

**What HJFS is designed to do.** The backdoored library version carries a different cryptographic hash than the prior legitimate release, so HJFS installs it into its own storage area. Data files created under the legitimate version stay there — the backdoored version cannot reach them. Roll back to the prior verified version.

This is the malicious sleeper pattern HJFS automatic data-file backup is designed to close for files written *during* the backdoored version's life. Even if that version had been dormant for months, writes from that period remain in the protected backup area. No program, including the backdoored version, can open that area.

**Residual.** Unauthorized SSH authentication stays with [Root Lock](../../docs/). Isolation still keeps the backdoored version out of the legitimate version's files.

---

## Change Healthcare ransomware (2024)

**What happened.** The ALPHV/BlackCat ransomware group breached Change Healthcare, a clearinghouse processing a large share of US patient healthcare claims. The February 2024 attack disrupted healthcare billing and payment processing across the United States for weeks.

UnitedHealth Group disclosed that approximately 190 million individuals had data affected.

**What the campaign needed.** Either a new encryptor that could open billing and patient files, or encryption from inside the programs that already stored them.

**What HJFS is designed to do.** A separate ransomware binary cannot enumerate or encrypt files belonging to other programs.

**Residual.** Patient records stored by the billing stack itself remain that stack's files. A compromised billing program can still hurt files it already owns. Isolation still stops a separate ransomware binary from opening those files. See [Protection limits](../introduction/limits/).
