---
title: "Real-World Attack Containment"
linkTitle: "Attack Examples"
weight: 30
description: "How HJFS is designed to contain real-world malware attacks and breaches."
categories: ["Essentials"]
tags: ["hjfs", "security", "malware", "ransomware", "cve", "examples"]
type: docs
toc: true
---

> **Prototype**: The protections described on this page reflect HJFS design intent. HJFS is under active development.

HJFS gives every program its own isolated storage area. No program can read or write files belonging to another. The examples below show what that means for real attacks: damage that would normally cascade across a system stops at the boundary of the program that was compromised.

Where an attack also involves network exfiltration or unauthorized program spawning — beyond HJFS v1.0's file access scope — those dimensions are addressed by [HeartSuite Root Lock](../../docs/) when deployed alongside HJFS.

---

## WannaCry ransomware (CVE-2017-0144)

**Attack**: An SMB vulnerability let malware spread across networks and encrypt files on every system it reached. Over 200,000 systems across 150 countries were affected, with damages estimated at $4 billion including healthcare disruptions and lost productivity.

**HJFS containment**: WannaCry is confined to its own storage area. It cannot read or write files belonging to other programs, so encryption stops at that boundary. Files created by legitimate programs stay intact and out of reach throughout the attack.

---

## Log4Shell (CVE-2021-44228)

**Attack**: A remote code execution flaw in the Log4j library let attackers inject and run arbitrary code, then use that foothold to reach other systems across the network.

**HJFS containment**: Injected code runs inside the confined storage area of the exploited process. No other program's files are reachable from there. HJFS version isolation also lets the vulnerable library be identified, rolled back, or replaced without touching data from other versions.

---

## SolarWinds supply chain attack

**Attack**: A tainted software update carried a backdoor that gave attackers persistent access for exfiltration and espionage over months. Roughly 18,000 organisations were affected, including multiple US federal agencies, with losses estimated in the hundreds of billions across government and intellectual property.

**HJFS containment**: HJFS identifies program versions by cryptographic hash, so the tainted update gets its own isolated storage area — entirely separate from the legitimate version's data. The company can roll back to a prior verified version with a single utility command. Data written under the legitimate version stays in that version's storage area and is unreachable by the tainted build.

---

## Colonial Pipeline ransomware

**Attack**: Compromised credentials gave attackers the access they needed to deploy ransomware that encrypted operational data and forced a six-day shutdown of the largest fuel pipeline in the United States. The company paid a $4.4 million ransom, with total economic losses exceeding $90 million.

**HJFS containment**: Ransomware is confined to its own storage area. It cannot reach or encrypt files belonging to other programs. Operational files stay readable throughout the attack. Recovery does not require paying a ransom or restoring from backup — the files were never accessible to the ransomware.

---

## MOVEit Transfer (CVE-2023-34362)

**Attack**: SQL injection in a managed file transfer application enabled mass data theft and encryption. Over 2,000 organisations across government, healthcare, and financial sectors were affected.

**HJFS containment**: The exploited process is confined to its own storage area. Files belonging to other programs are not reachable — bulk data theft requires access that HJFS does not grant. A secondary encryptor spawned to act on other programs' files hits the same wall: no program can access files it does not own.

---

## XZ Utils supply chain attack (CVE-2024-3094)

**Attack**: A patient attacker spent approximately two years as a trusted contributor to the XZ Utils open-source compression library, gradually building commit access before inserting a backdoor in versions 5.6.0 and 5.6.1. The backdoor was designed to allow unauthorized SSH authentication on affected systems. It was discovered in March 2024 weeks before reaching stable Linux distributions, narrowly preventing deployment at scale.

**HJFS containment**: The backdoored library version carries a different cryptographic hash than the prior legitimate release, so HJFS installs it into its own separate storage area. Data files created under the legitimate version stay in the legitimate version's storage area — the backdoored version cannot reach them. When the backdoor is discovered, the affected company rolls back to the prior verified version with a single utility command, with no data loss. This is precisely the malicious sleeper attack pattern HJFS automatic data file backup is designed to defeat: even if the backdoored version had been dormant for months before activation, every data file written during that period remains recoverable from the protected backup area — which no program, including the backdoored version, can access or destroy.

Where the attack involves network-level exfiltration or unauthorized program execution, those dimensions are addressed by [HeartSuite Root Lock](../../docs/) when deployed alongside HJFS.

---

## Change Healthcare ransomware (2024)

**Attack**: The ALPHV/BlackCat ransomware group breached Change Healthcare, a clearinghouse processing a large share of US patient healthcare claims. The February 2024 attack disrupted healthcare billing and payment processing across the United States for weeks. UnitedHealth Group disclosed that approximately 190 million individuals had data affected — the largest healthcare data breach in US history. The company paid a reported $22 million ransom.

**HJFS containment**: Ransomware is confined to its own storage area. Patient records, billing files, and payment data belonging to other programs sit in structurally separate storage areas that the ransomware cannot enumerate or encrypt. The attack cannot cascade across healthcare systems. Billing and payment infrastructure owned by other programs stays intact throughout the attack. Recovery does not require paying a ransom — the files were never accessible to the ransomware.
