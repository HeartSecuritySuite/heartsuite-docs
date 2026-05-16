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

HJFS's program-based file isolation is designed to contain the class of attacks that exploit the OS's default file access model — where any program can access any file the user owns. The examples below illustrate how HJFS's design would limit the damage of real-world attacks.

Where an attack also involves network exfiltration or unauthorized program spawning — beyond HJFS v1.0's file access scope — those dimensions are addressed by [HeartSuite Core Secure](../../docs/) when deployed alongside HJFS.

---

## WannaCry ransomware (CVE-2017-0144)

**Attack**: An SMB vulnerability allowed malware to spread across networks and encrypt files across affected systems. Over 200,000 systems were affected across 150 countries, causing an estimated $4 billion in damages including healthcare disruptions and lost productivity.

**HJFS containment**: Each program is confined to its own storage area. WannaCry can only access files within its own area — it cannot reach files belonging to other programs. Encryption does not cascade across the system. Data created by legitimate programs remains intact and inaccessible to the malware.

---

## Log4Shell (CVE-2021-44228)

**Attack**: A remote code execution vulnerability in the Log4j library allowed attackers to inject and run arbitrary code, then move laterally across enterprise environments.

**HJFS containment**: Injected code executes within the confined storage area of the exploited process. It cannot access files belonging to other programs. HJFS version isolation allows the vulnerable library version to be identified, rolled back, or replaced without data loss from other versions.

---

## SolarWinds supply chain attack

**Attack**: A tainted software update delivered a backdoor enabling sustained exfiltration and espionage. Approximately 18,000 organizations were affected, including multiple US federal agencies, with damages estimated in the hundreds of billions in government and intellectual property losses.

**HJFS containment**: HJFS identifies program versions by hash. The tainted update receives its own isolated storage area, entirely separate from the legitimate version's data. Rolling back to a prior verified version is a single utility command. Data created under the legitimate version remains intact and inaccessible to the tainted version.

---

## Colonial Pipeline ransomware

**Attack**: Compromised credentials led to ransomware deployment that encrypted operational data and forced a six-day shutdown of the largest fuel pipeline in the United States. The operator paid a $4.4 million ransom, with total economic losses exceeding $90 million.

**HJFS containment**: Ransomware is confined to its own storage area. It cannot access or encrypt files belonging to other programs. Operational files remain readable and intact throughout the attack. Recovery does not require restoring from backup — the files were never accessible to the ransomware.

---

## MOVEit Transfer (CVE-2023-34362)

**Attack**: SQL injection in a managed file transfer application enabled mass data theft and encryption. Over 2,000 organizations were affected across government, healthcare, and financial sectors.

**HJFS containment**: The exploited process is confined to its own storage area. Files belonging to other programs are not reachable — bulk data theft requires access HJFS does not grant. Spawning a secondary encryptor to act on other programs' files is blocked by the same per-program confinement.

---

## XZ Utils supply chain attack (CVE-2024-3094)

**Attack**: A patient attacker spent approximately two years as a trusted contributor to the XZ Utils open-source compression library, gradually building commit access before inserting a backdoor in versions 5.6.0 and 5.6.1. The backdoor was designed to allow unauthorized SSH authentication on affected systems. It was discovered in March 2024 weeks before reaching stable Linux distributions, narrowly preventing deployment at scale.

**HJFS containment**: The backdoored library version receives a distinct version hash — its cryptographic fingerprint differs from the prior legitimate release. Under HJFS, it is installed into its own separate storage area. Data files created under the legitimate version remain in the legitimate version's storage area and are unreachable by the backdoored version. When the backdoor is discovered, rolling back to the prior verified version is a single utility command, with no data loss. This is precisely the malicious sleeper attack pattern HJFS automatic data file backup is designed to defeat: even if the backdoored version had been dormant for months before activation, every data file written during that period remains recoverable from the protected backup area — which no program, including the backdoored version, can access or destroy.

Where the attack involves network-level exfiltration or unauthorized program execution, those dimensions are addressed by [HeartSuite Core Secure](../../docs/) when deployed alongside HJFS.

---

## Change Healthcare ransomware (2024)

**Attack**: The ALPHV/BlackCat ransomware group breached Change Healthcare, a clearinghouse processing a large share of US patient healthcare claims. The February 2024 attack disrupted healthcare billing and payment processing across the United States for weeks. UnitedHealth Group disclosed that approximately 190 million individuals had data affected — the largest healthcare data breach in US history. The operator paid a reported $22 million ransom.

**HJFS containment**: Ransomware is confined to its own storage area. Patient records, billing files, and payment data belonging to other programs are not reachable — they exist in structurally separate storage areas that the ransomware cannot enumerate or encrypt. The attack cannot cascade across healthcare systems. Billing and payment infrastructure owned by other programs remains intact throughout the attack. Recovery does not require paying a ransom — the files were never accessible to the ransomware.
