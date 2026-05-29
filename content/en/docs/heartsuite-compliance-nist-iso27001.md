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

For SOC 2 Trust Services Criteria mapping, see the [SOC 2 Control Mapping](../soc2/) document.

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
| **A.5.22** — Monitoring, review and change management of supplier services | HeartSuite has conducted a rigorous internal security audit covering 42 formally evidenced properties across multiple scenario categories. No independent third-party engagement has been commissioned. HeartSuite is not submitted to NCSC CPA, NIAP, or Common Criteria evaluation. Several kernel hardening choices (`CONFIG_BPF_SYSCALL=n`, `CONFIG_KEXEC_FILE=n`, removal of eBPF verifier exposure, `chattr`-based immutability) align with the attack-surface-reduction objectives of Common Criteria Protection Profiles, but the certification process has not been initiated. |
| **A.5.23** — ICT supply chain security | Partially. HeartSuite blocks new or modified binaries at the execution gate, preventing a trojanised update from running unless it replaces an already-allowlisted binary with identical path. |
| **A.5.28** — Collection of evidence | Kernel logs and Dashboard queue data constitute evidence of denied activity. Export requires SIEM integration. |
| **A.5.29** — Information security during disruption | Not covered. No continuity or DR controls. |
| **A.5.30** — ICT readiness for business continuity | Not covered. |

### A.6 — People Controls

Not covered. HeartSuite has no personnel management, background check, training, or separation-of-duties features. Separation of duties at the access-control layer is partially supported (per-programme file access limits what any individual programme can reach), but organisational duty separation is out of scope.

HeartSuite does not implement role-based access control within the Dashboard. Every user with Linux root access has identical, unrestricted access to all Dashboard functions: allowlist approval, Lockdown activation and deactivation, alert configuration, log clearing, and maintenance mode. There is no operator/administrator distinction, no per-function permission check, and no audit trail that distinguishes one root user's actions from another. Restricting which personnel can reach root — and attributing their actions to individuals — requires customer-side controls: `sudoers` policy, a privileged access management tool, or bastion host session recording.

### A.7 — Physical Controls

Not covered. HeartSuite's Lockdown state requires **physical access to bypass** (reboot to a non-HeartSuite kernel to clear immutability flags). This means physical security of the host is a dependency, not a capability HeartSuite provides.

In cloud deployments, the cloud provider's out-of-band serial console (AWS EC2 Serial Console, GCP serial port, Azure Serial Console, DigitalOcean Console) provides the same bypass path as physical keyboard access. HeartSuite installs `agetty` autologin on `/dev/ttyS0`; restricting serial console access in the cloud provider's IAM is therefore a customer-side dependency that must be addressed to maintain the integrity of Lockdown's protection model.

### A.8 — Technological Controls

| Control | HeartSuite contribution |
|---|---|
| **A.8.2** — Privileged access rights | Immutable seal and per-programme enforcement override root privilege at runtime. Root cannot execute new binaries, modify sealed files, or clear Lockdown state. Dashboard access requires Linux root credentials; no additional authentication layer exists within HeartSuite. Every allowlist approval action is recorded with a timestamp and TTY in `/var/log/heartsuite/ui.log`; attributing TTY sessions to named personnel requires customer-side session logging (auditd or a PAM tool). |
| **A.8.3** — Information access restriction | Per-programme file-access allowlist restricts which paths each programme can read or write. |
| **A.8.4** — Access to source code | Not covered natively; HeartSuite does not distinguish source code files. File-access allowlists can be configured to restrict access to specific paths. |
| **A.8.5** — Secure authentication | Immutable seal protects `/etc/passwd`, `/etc/shadow`, and SSH configuration from runtime modification. HeartSuite does not provide authentication mechanisms itself. |
| **A.8.7** — Protection against malware | Default-deny execution allowlist prevents unauthorised binaries from running. No signature-based or behavioural malware detection. |
| **A.8.8** — Management of technical vulnerabilities | Not covered. HeartSuite constrains the impact of unpatched vulnerabilities via allowlist boundaries but does not scan for, report on, or remediate them. |
| **A.8.9** — Configuration management | Allowlist plus Lockdown constitutes an enforced configuration state. No change is possible at runtime without a documented maintenance window. Dashboard records all approvals. The allowlist is managed per-host only; there is no remote management interface or centralised distribution mechanism. Revoking a compromised allowlist entry requires a maintenance window — no emergency revocation path exists while Lockdown is active. Boot-path integrity: `CONFIG_IMA` is not set (Integrity Measurement Architecture disabled) and `CONFIG_KEXEC_FILE` is not set (signed-image kexec variant compiled out). The kernel image directory is sealed under Lockdown via `chattr +i`, but there is no Secure Boot enforcement, no shim, and no IMA measurement log. |
| **A.8.10** — Information deletion | Not covered. HeartSuite's restricted `rm` under Lockdown limits accidental deletion but has no secure-deletion or data-retention controls. |
| **A.8.11** — Data masking | Not covered. |
| **A.8.12** — Data leakage prevention | Partially. Network allowlist prevents outbound connections to unapproved destinations; it does not inspect the content of approved connections. |
| **A.8.13** — Information backup | File Backup & Versioning provides automatic per-write versioned snapshots, kernel-sealed from runtime interference. Backup files are versioned filesystem copies with no encryption at the HeartSuite layer; for data-at-rest requirements (GDPR, HIPAA, PCI DSS), disk-level encryption (dm-crypt/LUKS) must be configured at the OS level. No offsite copy capability. |
| **A.8.15** — Logging | Kernel logs all programme execution, file access, and network connection attempts. Dashboard queues surface denied activity. On-device retention: `/.hs/sys/HS_log.txt` is cleared on each maintenance cycle; `/var/log/heartsuite/ui.log` is size-capped at approximately 8 MB with no time-based retention policy. There is no tamper-evident off-host log; a customer-operated SIEM receiving the syslog alert feed is required for audit-period-length evidence. |
| **A.8.16** — Monitoring activities | Alert triggers deliver denial events to email, syslog, webhook, or passive status endpoint (`~/.cache/heartsuite/status.json`, updated every 60 seconds — see schema below). The Fleet tab in Alert Settings configures a `node_id`, syslog server, and webhook URL; it is a one-way outbound push channel only. There is no inbound API, no remote allowlist control, and no centralised view across hosts. No fleet-wide or behavioural monitoring. |
| **A.8.17** — Clock synchronisation | Not covered. HeartSuite does not manage NTP or clock state. |
| **A.8.18** — Use of privileged utility programmes | Under Lockdown, privileged tools (editors, module loaders, file operation utilities) are sealed. Kernel-module hardening documentation covers `kmod` allowlisting. |
| **A.8.19** — Installation of software on operational systems | Per-programme execution allowlist enforces "approved programmes only." New software cannot execute until it has been reviewed and approved through the Dashboard. |
| **A.8.20** — Networks security | Per-programme network allowlist controls outbound connections using literal IPv4/IPv6 addresses only; CIDR notation and DNS-based rules are not supported. Inbound connection monitoring is not provided; inbound filtering is a customer-side responsibility via OS firewall (`iptables`, `nftables`) or cloud security groups. VLAN segregation and firewall policy are out of scope. |
| **A.8.22** — Segregation of networks | Network allowlist controls which programmes reach which destinations. This is host-level segregation, not network-layer segregation. |
| **A.8.23** — Web filtering | Not covered. HeartSuite filters by destination IP, not URL or content category. |
| **A.8.24** — Use of cryptography | No native encryption. HeartSuite configuration files (allowlist, mode state) are sealed by filesystem immutability flags but are not encrypted; they can be read from disk on a non-HS kernel boot. Backup snapshots are also unencrypted at the HeartSuite layer. OS-level disk encryption (dm-crypt/LUKS) is the required complementary control for data-at-rest compliance. |
| **A.8.28** — Secure coding | Not covered. HeartSuite does not inspect code or enforce secure development practices. |
| **A.8.29** — Security testing in development and production | Not covered. |
| **A.8.30** — Outsourced development | Not covered. |
| **A.8.32** — Change management | Maintenance window workflow provides a structured, logged change process. All newly executed programmes and file-access paths appear in Dashboard review queues before Lockdown can be re-engaged. |
| **A.8.33** — Test information | Not covered. |
| **A.8.34** — Protection of information systems during audit testing | Not directly covered. Immutable Lockdown state protects system integrity during audit activities. |

#### `hs-status.json` field reference

Written to `~/.cache/heartsuite/status.json` every 60 seconds by the HeartSuite daemon. Read-only; does not accumulate history.

| Field | Type | Notes |
|---|---|---|
| `node_id` | string | Configured host identifier |
| `mode` | string | `"Secure Mode"`, `"Setup Mode"`, or `"Unknown"` |
| `is_hs_kernel` | bool | Whether the running kernel is the HeartSuite kernel |
| `lockdown` | bool | Whether Lockdown is currently active |
| `lockdown_on_boot` | bool \| null | Lockdown re-engagement setting; null if unset |
| `pending_programs` | int | Programmes awaiting review |
| `pending_files` | int | Sum of `pending_file_r` + `pending_file_w` |
| `pending_network` | int | Network destinations awaiting review |
| `last_alert_at` | string | ISO 8601 UTC timestamp of last alert, or empty string |
| `updated_at` | string | ISO 8601 UTC timestamp of last daemon write |
| `daemon_ok` | bool | Whether the HeartSuite daemon is running normally |
| `channel_errors` | object | **Optional** — present only when the daemon passes an `AlertState` with errors |
| └ `email.message` / `email.at` | string | Last email delivery error and its timestamp |
| └ `syslog.message` / `syslog.at` | string | Last syslog delivery error and its timestamp |
| └ `webhook.message` / `webhook.at` | string | Last webhook delivery error and its timestamp |

For Nagios/Zabbix/Ansible polling, `lockdown`, `is_hs_kernel`, and `daemon_ok` are the three fields that constitute a healthy Lockdown state.

---

## Open Questions

The following 11 questions remain without a complete public answer. Status annotations indicate how close each is to being closeable.

### Evidence & Attestation

1. **Can HeartSuite export a signed compliance evidence package** — a machine-readable record of the current allowlist, Lockdown state, and alert history — for submission to an auditor or GRC platform?

2. **Does HeartSuite generate a time-stamped attestation of continuous Lockdown state?** `hs-status.json` reflects current state only; the daemon's reboot history records reboots, not continuous Lockdown state. There is no historical attestation record.

### Access Control & Identity

3. **How does HeartSuite interact with PAM, LDAP, or Active Directory?** No HeartSuite code calls PAM, LDAP, or any directory service. Regulated environments requiring centralised identity management must bridge this at the OS layer.

### Vulnerability & Patch Management

4. **How does HeartSuite handle kernel CVEs in its own kernel build?** *(Partially answerable.)* Active kernel maintenance is evidenced by the 5.19.6 → 6.18 LTS port. However, no patch SLA (e.g., "within 30 days of NVD publication") and no customer notification process are publicly documented.

5. **Is there a published SBOM for the HeartSuite kernel and Dashboard components?** *(Partially answerable.)* A detailed internal component inventory exists. The gaps to a publishable SBOM are format (SPDX or CycloneDX), upstream dependency tracking against NVD, and a publication decision — not a research problem. Update bundles are currently authenticated by SHA-256 only; there is no GPG or PGP signature against a HeartSuite-controlled key.

6. **What is HeartSuite's vulnerability disclosure and response programme?** *(Organisational — not in the product.)* Customers need a responsible disclosure policy and CVE numbering authority (CNA) status for ISO 27001 A.5.22 procurement assessments.

### Incident Response & Recovery

7. **What is the documented RTO for restoring a Lockdown host after a security incident?** Recovery requires a minimum three-step, two-reboot sequence with manual Dashboard queue review. No time estimate is defined; duration is queue-dependent. There is no fast path.

8. **Can HeartSuite backups be restored to a different host?** The restore mechanism is local-only. There is no export, archive, or transfer capability; cross-host restore is architecturally absent.

9. **How are HeartSuite security incidents (in the product itself) disclosed to customers?** *(Organisational — not in the product.)* ISO 27001 A.5.24 requires a defined customer notification process for product-level events.

### Scalability & Fleet Management

10. **What does the licensing model look like at scale?** *(Organisational — not in the product.)* No pricing tiers, volume discount structures, or MSP terms are publicly documented.

### Compliance Certifications

11. **Does HeartSuite map to sector-specific compliance frameworks** — PCI DSS, HIPAA, NIS2, DORA, CMMC? *(Derivable without new research.)* The evidence base is the same as the NIST CSF and ISO 27001 mappings in this document. PCI DSS Req 7 (least privilege) and Req 10 (log integrity), HIPAA §164.312(a) (access controls) and §164.312(b) (audit controls), and NIS2/CMMC controls that derive from NIST 800-171 all map directly to controls already described here. This is a document task, not an investigation.

---

## Cloud Shared-Responsibility Matrix

When HeartSuite Core Secure runs as a guest VM on a cloud platform, responsibility for controls is split across three parties.

| Control layer | HeartSuite | Cloud provider | Customer |
|---|---|---|---|
| Kernel-level execution enforcement | Primary | — | — |
| Per-programme file access control | Primary | — | — |
| Outbound network allowlist | Primary | — | — |
| Configuration immutability (Lockdown) | Primary | — | — |
| File backup & versioning | Primary | — | Offsite / encrypted copy for DR |
| Hypervisor and host hardware security | — | Primary | — |
| Physical data centre security | — | Primary | — |
| Network infrastructure (VPC, routing) | — | Primary | — |
| Serial / out-of-band console access control | Installs `agetty` autologin on `/dev/ttyS0` | Provides console (AWS EC2 Serial Console, GCP serial port, Azure Serial Console) | **Must restrict console access via cloud IAM** |
| Inbound firewall / security groups | — | Provides capability | Customer configures |
| Disk encryption at rest | — | Provides capability (EBS encryption, etc.) | Customer enables; LUKS recommended |
| Identity & access management | — | Provides IAM | Customer configures; controls who reaches root and serial console |
| OS-level audit logging (login, sudo) | — | — | Customer configures (auditd, CloudTrail) |
| SIEM / log retention beyond device | — | — | Customer operates |
| Vulnerability scanning | — | — | Customer operates |
| Incident response programme | — | — | Customer defines |

The most operationally significant customer responsibility in cloud deployments is **restricting serial console access**. HeartSuite installs `agetty` autologin on `/dev/ttyS0`, meaning anyone who can reach the cloud provider's out-of-band serial console can boot to the non-HS kernel without further authentication from HeartSuite. Restricting serial console access at the cloud provider IAM layer is the control that preserves Lockdown's protection model in cloud environments.

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
