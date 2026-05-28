---
title: "Compliance Reference: NIST CSF & ISO 27001"
weight: 112
description: "How HeartSuite Core Secure maps to NIST Cybersecurity Framework and ISO 27001:2022 Annex A controls."
categories: ["Reference"]
tags: ["compliance", "NIST", "ISO 27001"]
type: docs
---

This document maps HeartSuite Core Secure capabilities to the NIST Cybersecurity Framework (CSF) and ISO 27001:2022 Annex A controls. It is intended for compliance officers, auditors, and security staff evaluating where HeartSuite contributes to an organisation's compliance posture and where complementary controls are required.

HeartSuite is a **preventive enforcement layer**, not a comprehensive compliance platform. It addresses a specific, high-value problem: enforcing a default-deny execution, file-access, and network policy at kernel level — one that survives root compromise. This document clarifies what that means for your compliance programme and what questions remain open.

---

## What HeartSuite Enforces

HeartSuite operates through three enforcement gates, applied per programme, not per user or per privilege level.

| Gate | What it controls |
|---|---|
| **Execution** | A programme must be explicitly allowlisted to execute. Unapproved binaries are blocked even for root. |
| **File access** | Each approved programme can only read or write paths explicitly permitted in its allowlist entry. |
| **Network access** | Each approved programme can only connect to specific IPv4/IPv6 addresses. All other outbound connections are blocked. |

Two modes govern behaviour: **Setup Mode** (log and review, no blocking) and **Lockdown** (enforcement active, configuration sealed with filesystem immutability flags that root cannot clear at runtime).

Under Lockdown, kernel-level immutability also protects: authentication files (`/etc/passwd`, `/etc/shadow`), SSH configuration, systemd units, sudo policy, scheduled tasks (cron/anacron), system libraries (`/usr/lib/`), and HeartSuite's own configuration and kernel image directory.

File Backup & Versioning takes an automatic snapshot on every write to designated directories (default: `/home`). Under Lockdown the kernel prevents any programme, including root, from accessing those backups.

---

## NIST Cybersecurity Framework Coverage

### Function: Identify

HeartSuite contributes to asset visibility through its **programme allowlisting workflow**. During Setup Mode, all programme execution attempts are logged and surfaced in the Dashboard review queues with package metadata (name, version, install date, maintainer). This forms a working inventory of executable software on the host.

**What is not covered:** HeartSuite does not produce a hardware asset inventory, does not integrate with a configuration management database (CMDB), and does not aggregate inventory across a fleet. The inventory it produces is per-host and lives in the Dashboard; there is no export to asset management tooling without a SIEM integration.

Relevant CSF categories: ID.AM-1, ID.AM-2 (partially)

### Function: Protect

This is HeartSuite's primary contribution.

| CSF Category | HeartSuite mechanism |
|---|---|
| **PR.AC-1** — Identity and credential management | Immutable seal protects `/etc/passwd`, `/etc/shadow`, `/etc/group`; no programme can modify authentication state at runtime under Lockdown. |
| **PR.AC-3** — Remote access management | Network allowlist controls outbound connection destinations per programme; inbound access is not managed. |
| **PR.AC-4** — Access control, least privilege | Per-programme execution and file-access allowlists enforce least-privilege at the enforcement layer, overriding user and root privilege. |
| **PR.AC-5** — Network integrity | Network allowlist restricts each programme to approved destinations; unapproved outbound connections are blocked at the kernel socket layer. |
| **PR.DS-1** — Data-at-rest protection | File versioning backups are sealed by the kernel under Lockdown; no programme (including root) can delete or alter backup copies at runtime. |
| **PR.DS-5** — Protection against data leaks | Outbound network allowlist limits exfiltration paths; programmes cannot reach unapproved destinations. |
| **PR.IP-1** — Baseline configuration | Allowlist and immutability together constitute an enforced configuration baseline. No configuration change is possible at runtime without a maintenance window that requires rebooting to a non-HeartSuite kernel. |
| **PR.IP-12** — Vulnerability management | HeartSuite reduces the exploitable blast radius: approved programme CVEs with network or file-access exploitation paths are constrained by allowlist boundaries. |
| **PR.MA-2** — Remote maintenance | Maintenance windows are structured: requires kernel reboot, checklist-guided steps, and Dashboard review of all new activity before re-engaging Lockdown. |
| **PR.PT-1** — Audit log protection | Under Lockdown, immutability flags protect log files; the kernel prevents attribute changes that would allow log deletion. |
| **PR.PT-3** — Principle of least functionality | Lockdown disables editors, restricts `rm`/`cp`/`mv`, and seals scheduled-task files, enforcing a minimal-function runtime posture. |

### Function: Detect

HeartSuite generates alerts for denial events: new programme blocked, network burst to unapproved destination, critical file modification outside a maintenance window, mode switches, and Lockdown state changes. Alerts are delivered via email, syslog, webhook, and a passive status JSON endpoint.

This is **reactive logging on policy violations**, not behavioural detection. HeartSuite does not perform anomaly detection, baseline comparison, heuristic analysis, or threat-intelligence enrichment.

Relevant CSF categories: DE.CM-1, DE.CM-7 (partially). DE.AE (anomaly and event analysis) is not addressed.

### Function: Respond

HeartSuite does not automate incident response. The Dashboard provides a Maintenance section that guides recovery steps, and File Backup & Versioning enables file-level recovery. Beyond this, response is manual.

Relevant CSF categories: RS.CO, RS.AN, RS.MI — not meaningfully covered.

### Function: Recover

File Backup & Versioning provides per-write timestamped, hash-deduplicated snapshots sealed from runtime interference. This supports recovery from ransomware-style overwrites and accidental deletion within the backup scope.

Relevant CSF categories: RC.RP-1 (partially). Fleet-wide recovery plans, backup-to-offsite, and recovery-time objectives are not defined by HeartSuite.

---

## ISO 27001:2022 Annex A Coverage

### A.5 — Organisational Controls

| Control | HeartSuite contribution |
|---|---|
| **A.5.7** — Threat intelligence | Not covered. HeartSuite has no threat feed integration. |
| **A.5.15** — Access control | Kernel-enforced per-programme access control, overriding user and root privilege. Supports enforcement of an access control policy. |
| **A.5.22** — Monitoring, review and change management of supplier services | Not covered. |
| **A.5.23** — ICT supply chain security | Partially. HeartSuite blocks new or modified binaries at the execution gate, preventing a trojanised update from running unless it replaces an already-allowlisted binary with identical path. |
| **A.5.28** — Collection of evidence | Kernel logs and Dashboard queue data constitute evidence of denied activity. Export requires SIEM integration. |
| **A.5.29** — Information security during disruption | Not covered. No continuity or DR controls. |
| **A.5.30** — ICT readiness for business continuity | Not covered. |

### A.6 — People Controls

Not covered. HeartSuite has no personnel management, background check, training, or separation-of-duties features. Separation of duties at the access-control layer is partially supported (per-programme file access limits what any individual programme can reach), but organisational duty separation is out of scope.

### A.7 — Physical Controls

Not covered. HeartSuite's Lockdown state requires **physical access to bypass** (reboot to a non-HeartSuite kernel to clear immutability flags). This means physical security of the host is a dependency, not a capability HeartSuite provides.

### A.8 — Technological Controls

| Control | HeartSuite contribution |
|---|---|
| **A.8.2** — Privileged access rights | Immutable seal and per-programme enforcement override root privilege at runtime. Root cannot execute new binaries, modify sealed files, or clear Lockdown state. |
| **A.8.3** — Information access restriction | Per-programme file-access allowlist restricts which paths each programme can read or write. |
| **A.8.4** — Access to source code | Not covered natively; HeartSuite does not distinguish source code files. File-access allowlists can be configured to restrict access to specific paths. |
| **A.8.5** — Secure authentication | Immutable seal protects `/etc/passwd`, `/etc/shadow`, and SSH configuration from runtime modification. HeartSuite does not provide authentication mechanisms itself. |
| **A.8.7** — Protection against malware | Default-deny execution allowlist prevents unauthorised binaries from running. No signature-based or behavioural malware detection. |
| **A.8.8** — Management of technical vulnerabilities | Not covered. HeartSuite constrains the impact of unpatched vulnerabilities via allowlist boundaries but does not scan for, report on, or remediate them. |
| **A.8.9** — Configuration management | Allowlist plus Lockdown constitutes an enforced configuration state. No change is possible at runtime without a documented maintenance window. Dashboard records all approvals. |
| **A.8.10** — Information deletion | Not covered. HeartSuite's restricted `rm` under Lockdown limits accidental deletion but has no secure-deletion or data-retention controls. |
| **A.8.11** — Data masking | Not covered. |
| **A.8.12** — Data leakage prevention | Partially. Network allowlist prevents outbound connections to unapproved destinations; it does not inspect the content of approved connections. |
| **A.8.13** — Information backup | File Backup & Versioning provides automatic per-write versioned snapshots, kernel-sealed from runtime interference. No encryption of backup data, no offsite copy. |
| **A.8.15** — Logging | Kernel logs all programme execution, file access, and network connection attempts. Dashboard queues surface denied activity. Raw logs accessible via `dmesg` and syslog. |
| **A.8.16** — Monitoring activities | Alert triggers deliver denial events to email, syslog, webhook, or passive status endpoint. No fleet-wide or behavioural monitoring. |
| **A.8.17** — Clock synchronisation | Not covered. HeartSuite does not manage NTP or clock state. |
| **A.8.18** — Use of privileged utility programmes | Under Lockdown, privileged tools (editors, module loaders, file operation utilities) are sealed. Kernel-module hardening documentation covers `kmod` allowlisting. |
| **A.8.19** — Installation of software on operational systems | Per-programme execution allowlist enforces "approved programmes only." New software cannot execute until it has been reviewed and approved through the Dashboard. |
| **A.8.20** — Networks security | Per-programme network allowlist controls outbound connections. Inbound traffic management, VLAN segregation, and firewall policy are out of scope. |
| **A.8.22** — Segregation of networks | Network allowlist controls which programmes reach which destinations. This is host-level segregation, not network-layer segregation. |
| **A.8.23** — Web filtering | Not covered. HeartSuite filters by destination IP, not URL or content category. |
| **A.8.24** — Use of cryptography | Not covered. No native encryption. HeartSuite is compatible with OS-level disk encryption (LUKS or equivalent). |
| **A.8.28** — Secure coding | Not covered. HeartSuite does not inspect code or enforce secure development practices. |
| **A.8.29** — Security testing in development and production | Not covered. |
| **A.8.30** — Outsourced development | Not covered. |
| **A.8.32** — Change management | Maintenance window workflow provides a structured, logged change process. All newly executed programmes and file-access paths appear in Dashboard review queues before Lockdown can be re-engaged. |
| **A.8.33** — Test information | Not covered. |
| **A.8.34** — Protection of information systems during audit testing | Not directly covered. Immutable Lockdown state protects system integrity during audit activities. |

---

## What the Documentation Does Not Answer

The following are questions a compliance officer or auditor would reasonably ask about HeartSuite when assessing its contribution to a NIST CSF or ISO 27001 programme. The product documentation does not contain answers to these questions. They represent either genuine gaps in current HeartSuite capability or documentation gaps that may reflect capability not yet described.

### Evidence & Attestation

1. **Can HeartSuite export a signed compliance evidence package** — a machine-readable record of the current allowlist, Lockdown state, and alert history — for submission to an auditor or GRC platform?

2. **Is there an audit log that cannot be cleared by the local administrator?** Kernel logs and Dashboard queues are local; a determined local administrator with physical access could clear them before an audit. Is there a tamper-evident, off-host log record?

3. **Does HeartSuite generate a time-stamped attestation of Lockdown state?** A control assessment requires point-in-time evidence that Lockdown was active during a given period. The current documentation describes Lockdown state but not how to prove it was active continuously.

4. **What is the format and schema of the JSON status endpoint?** Compliance teams integrating HeartSuite with a GRC or SIEM platform need field definitions, retention guarantees, and version stability commitments.

5. **Are Dashboard approval records retained across reboots?** If the activity log is cleared on reboot, there is no audit trail of who approved what programme and when.

### Access Control & Identity

1. **Does HeartSuite support multiple administrative roles?** The documentation describes a single administrative interface. ISO 27001 A.5.15 and NIST PR.AC-4 require separation of duties. Can review and approval of allowlist entries be assigned to different individuals, with one approving and another confirming?

2. **Is Dashboard access authenticated and logged?** Who can access the Dashboard, by what credential, and is that access itself logged? The documentation notes the Dashboard is a trust boundary at console access, but does not define the authentication model.

3. **How does HeartSuite interact with PAM, LDAP, or Active Directory?** Regulated environments often require centralised identity management. The documentation does not describe integration with directory services.

4. **Can the allowlist be managed remotely, and if so, what protects that management channel?** The documentation describes Lockdown as sealing configuration, but does not clearly state whether remote allowlist changes are possible and, if so, what the authentication and authorisation model is.

### Cryptography & Data Protection

1. **What encryption, if any, protects HeartSuite's own configuration files?** The allowlist files are described as sealed by immutability flags but not encrypted. A physical attacker with access to the disk could read or, on a non-HS kernel, modify them. Is there a plan to add encryption at rest for configuration?

2. **Are backup snapshots encrypted?** File Backup & Versioning creates versioned snapshots but the documentation does not describe whether snapshot contents are encrypted. For environments subject to data-at-rest requirements (GDPR, HIPAA, PCI DSS), unencrypted backups of `/home` may be a compliance finding.

3. **Does HeartSuite validate the integrity of its own kernel image at boot?** Secure Boot integration and kernel image signing are referenced in the sealed directory list, but the documentation does not confirm whether Secure Boot is required, optional, or verified by HeartSuite during startup.

### Vulnerability & Patch Management

1. **How does HeartSuite handle kernel CVEs in its own kernel build?** The product ships a custom kernel. When a kernel CVE is disclosed, what is the patch cadence, how are customers notified, and what is the expected update window?

2. **Is there a published software bill of materials (SBOM) for the HeartSuite kernel and Dashboard components?** ISO 27001 A.5.23 and NIST SP 800-204C reference SBOM as a supply-chain control. An SBOM would allow customers to correlate HeartSuite components against vulnerability databases.

3. **What is HeartSuite's own vulnerability disclosure and response programme?** For procurement and supplier-risk assessments under ISO 27001 A.5.22, customers need to understand the vendor's vulnerability management process, including responsible disclosure policy and CVE numbering authority (CNA) status.

### Network & Monitoring

1. **Does HeartSuite support CIDR notation or DNS-based network allowlisting?** The documentation explicitly states only literal IPv4/IPv6 addresses are supported. For cloud-hosted services with dynamic IPs or CDN endpoints, this creates a maintenance burden. Is this a planned feature, and is there a recommended workaround?

2. **Can syslog output be shipped to a remote SIEM in real time under Lockdown?** The documentation lists syslog as an alert channel, but Lockdown seals network access. Is a syslog forwarder pre-allowlisted, and if so, what is its allowlist configuration?

3. **What is the retention period for kernel log data before it is overwritten?** The documentation notes logs are cleared from the Dashboard when review queues are emptied. For compliance programmes requiring 90-day or 1-year log retention, what is the recommended architecture?

4. **Does HeartSuite provide any inbound connection monitoring?** The network allowlist is described as controlling outbound connections. Inbound threat detection (port scans, brute-force) is not mentioned. What is the recommended complementary control?

### Incident Response & Recovery

1. **What is the documented recovery time objective (RTO) for restoring a Lockdown host after a security incident?** The maintenance window process requires a two-reboot sequence and manual review. For environments with defined RTO requirements, is there a faster recovery path?

2. **Can HeartSuite backups be restored to a different host?** The documentation describes file versioning for recovery on the same host. For disaster recovery scenarios, can backup snapshots be transferred to and restored on a replacement machine?

3. **Is there a procedure for revoking a compromised allowlist entry without disabling Lockdown?** If a specific programme is found to be malicious, the current process appears to require a maintenance window to modify the allowlist. Is there an emergency revocation path?

4. **How are HeartSuite security incidents (in the product itself) disclosed to customers?** ISO 27001 A.5.24 requires an information security incident management process. Does HeartSuite have a defined customer notification process for product-level security events?

### Scalability & Fleet Management

1. **How is the allowlist managed across a fleet of identical servers?** The documentation describes a per-host allowlist workflow. For environments with hundreds of identical servers, is there a mechanism to define and push a common allowlist, or must each host be configured individually?

2. **Is there a centralised management plane for multi-host deployments?** The Dashboard is described as a per-host interface. For SOC and compliance teams that need a fleet-wide view of Lockdown status, blocked events, and approval history, is there a management server or API?

3. **What does the licensing model look like at scale?** The documentation notes that licensing operates on a per-host basis, but does not provide pricing tiers, volume discount structures, or terms for managed service providers (MSPs) that may need to report licence compliance to customers.

### Compliance Certifications

1. **Has HeartSuite itself undergone an independent security assessment, penetration test, or third-party audit?** For procurement under ISO 27001 A.5.22, customers need evidence that the supplier has assessed its own product. Is a report or summary available under NDA?

2. **Is HeartSuite listed in any government or regulatory approved-products list** (e.g., UK NCSC CPA, US NIAP, Common Criteria)? Certain regulated sectors (defence, government, critical infrastructure) require products to appear on such lists before deployment.

3. **Does HeartSuite map to any specific sector compliance frameworks** — PCI DSS, HIPAA, NIS2, DORA, CMMC? The documentation addresses NIST CSF and ISO 27001 at a general level. Sector-specific frameworks have additional requirements (e.g., PCI DSS Requirement 10 for audit log integrity, HIPAA §164.312 for access controls) that may have specific HeartSuite answers.

4. **Is there a shared-responsibility model document for cloud deployments?** When HeartSuite runs as a guest VM on AWS, GCP, or Azure, the cloud provider controls the hypervisor layer. A shared-responsibility matrix would clarify which controls HeartSuite addresses, which the cloud provider addresses, and which remain the customer's responsibility.

---

## How HeartSuite Fits Into a Compliance Programme

HeartSuite addresses a narrow but high-value control: **kernel-enforced, root-resistant mandatory access control**. It does not replace the controls listed below, and a compliance programme relying on HeartSuite alone will have significant gaps.

| Layer | HeartSuite role | Complementary tool required |
|---|---|---|
| Execution control | Primary control | — |
| File access control | Primary control | — |
| Outbound network control | Primary control | Firewall / NAC for inbound |
| Configuration immutability | Primary control | — |
| File backup & recovery | Primary control | Offsite / encrypted backup for DR |
| Fleet-wide logging | None | SIEM (Splunk, Sentinel, Elastic) |
| Behavioural detection | None | NDR / EDR |
| Vulnerability management | None | Scanner (Nessus, Qualys, Wiz) |
| Identity & access management | None | IAM / PAM platform |
| Data encryption | None | LUKS, TLS, application-layer encryption |
| Personnel & training controls | None | HRMS / LMS / GRC platform |
| Supplier management | None | GRC / vendor risk management |

For a NIST CSF or ISO 27001 programme, HeartSuite contributes most directly to the **Protect** function and **ISO 27001 A.8** (Technological Controls), with meaningful but partial contributions to logging, monitoring, and recovery.
