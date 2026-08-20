---
title: "Compliance Reference: NIST CSF & ISO 27001"
weight: 112
description: "How Root Lock by HeartSuite maps to NIST CSF 1.1 and ISO 27001:2022 Annex A controls."
categories: ["Reference"]
tags: ["compliance", "NIST", "ISO 27001"]
type: docs
---

This document maps Root Lock by HeartSuite capabilities to the NIST Cybersecurity Framework (CSF) **1.1** and ISO/IEC 27001:2022 **Annex A** as **technical contributions** a customer may cite after their own risk assessment. It is not a Statement of Applicability, not an ISMS, and not a product certification.

ISO 27001 certifies an **organization's ISMS** (clauses 4–10). Annex A is a reference control set selected in a **Statement of Applicability**. CSF 1.1 outcomes are organizational. A kernel allowlist does not “cover A.8” or “implement ISO 27001.”

CSF 2.0 (February 2024) reorganized Protect (for example PR.AC → PR.AA). This page stays on **1.1 IDs** so the table does not mix versions. It is not a 2.0 crosswalk.

Root Lock is a **preventive enforcement layer**, not a comprehensive compliance platform. It enforces a default-deny execution, file-access, and network policy at kernel level — one that, under Lockdown, remote root is not intended to lift at runtime.

For SOC 2 Trust Services Criteria mapping, see the [SOC 2 Control Mapping](../soc2/) document.

---

## What Root Lock enforces

Root Lock operates through three enforcement gates, applied per program, not per user or per privilege level.

| Gate | What it controls |
|---|---|
| **Execution** | A program must be explicitly allowlisted to execute. Unapproved binaries are blocked even for root. |
| **File access** | Each approved program can only read or write paths explicitly permitted in its allowlist entry. |
| **Network access** | Each approved program can only connect to specific IPv4/IPv6 addresses. All other outbound connections are blocked. |

Two modes govern behaviour: **Setup Mode** (log and review, no blocking) and **Lockdown** (blocking active, configuration sealed with filesystem immutability flags that, by design, remote root cannot clear at runtime). Recovery is the maintenance kernel via physical or serial-console access.

Under Lockdown, kernel-level immutability also protects authentication files (`/etc/passwd`, `/etc/shadow`), SSH configuration, systemd units, sudo policy, scheduled tasks (cron/anacron), system libraries (`/usr/lib/`), and Root Lock's own configuration and kernel image directory.

File Backup & Versioning takes an automatic snapshot on every write to designated directories (default: `/home`). Under Lockdown the kernel blocks write and delete to the backup directory (`/.hs/b/`) for every program except Root Lock backup tooling, including root.

---

## NIST Cybersecurity Framework Coverage

### Function: Identify

Root Lock contributes to asset visibility through the **program allowlisting workflow**. During Setup Mode, program executions are logged and surfaced in the Dashboard review queues with package metadata (name, version, install date, maintainer). That forms a working inventory of executable software on the host.

**What is not covered:** Root Lock does not produce a hardware asset inventory, does not integrate with a CMDB via an inbound API, and does not aggregate inventory across a fleet on its own.

The inventory is per-host and lives in the Dashboard. Export to asset management tooling and fleet aggregation uses the syslog streams, status.json, dedicated JSONL approval log, and harvest of allowlist state into your SIEM or central systems (see [Central Policy Management and External Control](../alerts/central-policy-management/)).

Relevant CSF **subcategory** (partial): **ID.AM-2** (software platforms and applications are inventoried). **ID.AM-1** is physical devices — not this product. The customer still owns the asset inventory / CMDB.

### Function: Protect

This is Root Lock's primary contribution.

These are CSF 1.1 **subcategories**, not categories. Rows that were previously mapped incorrectly (identity lifecycle, remote access, network segmentation, data-at-rest encryption, vulnerability-management **plan**, remote maintenance, logging **program**) are omitted rather than stretched.

| CSF 1.1 subcategory | HeartSuite contribution (partial) |
|---|---|
| **PR.AC-4** — Access permissions are managed, incorporating the principles of least privilege and separation of duties | Per-program execution and file-access allowlists enforce least privilege at the kernel, including for root. Dashboard RBAC / organizational SoD is **not** provided. |
| **PR.DS-5** — Protections against data leaks are implemented | Outbound network allowlist limits exfiltration **destinations**; it does not inspect content of approved connections. |
| **PR.IP-1** — A baseline configuration of information technology/industrial control systems is created and maintained | Allowlist plus Lockdown is an enforced host baseline. Changes take a maintenance window. |
| **PR.PT-3** — The principle of least functionality is incorporated by configuring systems to provide only essential capabilities | Lockdown disables editors, restricts `rm`/`cp`/`mv`, and seals scheduled-task files. |

**Not claimed here (complementary customer controls):**

- **PR.AC-1** identity lifecycle — sealing `/etc/shadow` is integrity of the file, not issue/revoke/audit of identities.
- **PR.AC-3** remote access — outbound IP allowlisting is not VPN/SSH/RDP management; inbound is unmanaged.
- **PR.AC-5** network integrity / segmentation — host socket allowlisting is not network segregation.
- **PR.DS-1** data-at-rest — backups and config are **not** encrypted at the Root Lock layer; LUKS is the complementary control (see A.8.13 / A.8.24).
- **PR.IP-12** vulnerability management plan — same idea as ISO **A.8.8**, which is **not covered**. Blast-radius reduction is not a VM plan.
- **PR.MA-2** remote maintenance — Root Lock maintenance is local/serial two-reboot. That is the opposite of remote maintenance.
- **PR.PT-1** audit/log records determined, documented, implemented, and reviewed — a logging **program**, not `chattr` on a buffer that is cleared on maintenance.

### Function: Detect

Root Lock generates alerts for denial events: new program blocked, network burst to unapproved destination, critical file modification outside a maintenance window, mode switches, and Lockdown state changes. Alerts are delivered via email, syslog, webhook, and a passive status JSON endpoint.

This is **reactive logging on policy violations**, not behavioural detection. Root Lock does not perform anomaly detection, baseline comparison, heuristic analysis, or threat-intelligence enrichment.

Relevant CSF subcategory (partial): **DE.CM-7** (monitoring for unauthorized personnel, connections, devices, and software). **DE.CM-1** is **network** monitoring — not this product. **DE.AE** (anomaly and event analysis) is not addressed.

### Function: Respond

Root Lock does not automate incident response. Maintenance guides recovery steps, and File Backup & Versioning enables file-level recovery. Beyond this, response is manual.

Relevant CSF categories: RS.CO, RS.AN, RS.MI — not meaningfully covered.

### Function: Recover

File Backup & Versioning provides per-write timestamped, hash-deduplicated snapshots sealed from runtime interference. This supports recovery from ransomware-style overwrites and accidental deletion within the backup scope.

Relevant CSF subcategory (partial, host-local copies only): recovery *content* on the box. **RC.RP-1** is execution of a **recovery plan** (RTO, offsite, cross-host). Root Lock does not define that plan.

---

## ISO 27001:2022 Annex A — technical contributions

Cite these only in a customer **Statement of Applicability** after risk treatment. Annex A names are 27001; implementation guidance is ISO/IEC 27002.

### A.5: Organisational controls

Most A.5 rows are **organizational**. A host kernel does not implement them.

| Control | HeartSuite contribution |
|---|---|
| **A.5.7** — Threat intelligence | Not covered. HeartSuite has no threat feed integration. |
| **A.5.15** — Access control | Organizational **policy** control. Kernel per-program enforcement can **support** a policy the customer already wrote. It is not the policy. |
| **A.5.21** — Managing information security in the ICT supply chain | Organizational supplier-relationship control. Execution allowlisting can **contribute** to “unapproved binary cannot run.” It is not supplier due diligence, contracts, or monitoring. |
| **A.5.22** — Monitoring, review and change management of supplier services | **Not covered.** This is the **customer** monitoring **their** suppliers (including HeartSuite). HeartSuite’s own testing, and the absence of NCSC CPA / NIAP / Common Criteria, belong in a vendor questionnaire — not this control. |
| **A.5.23** — Information security for use of cloud services | **Not covered.** This is cloud-use governance (roles, acquisition, use, exit). It is not ICT supply chain (that is A.5.21) and not a binary allowlist. |
| **A.5.28** — Collection of evidence | Organizational / legal process. Denial logs and the JSONL approval log can be **inputs** a customer SIEM retains. They are not a forensic evidence program. |
| **A.5.29** — Information security during disruption | Not covered. No continuity or DR controls. |
| **A.5.30** — ICT readiness for business continuity | Not covered. |

### A.6 — People Controls

Not covered. Root Lock has no personnel management, background check, training, or separation-of-duties features. Per-program file limits are not organisational segregation of duties.

Root Lock does not implement role-based access control within the Dashboard. Every user with Linux root access has identical access to all Dashboard functions: allowlist approval, Lockdown activation and deactivation, alert configuration, log clearing, and Maintenance.

There is no operator/administrator distinction and no per-function permission check. Every allowlist approval is written to `/var/log/heartsuite/allowlist-audit.log` with timestamp, uid, and tty. That distinguishes **sessions**, not people who share uid 0. Restricting which personnel can reach root — and attributing those sessions to named people — requires customer-side controls: `sudoers` policy, a privileged access management tool, or bastion host session recording.

### A.7 — Physical Controls

Not covered. Lockdown requires **physical or serial-console access to bypass** (reboot to a maintenance kernel to clear immutability flags). Physical security of the host is a dependency, not a capability Root Lock provides.

In cloud deployments, the provider's out-of-band serial console (AWS EC2 Serial Console, GCP serial port, Azure Serial Console, DigitalOcean Console) is the same bypass path as a keyboard. Root Lock installs `agetty` autologin on `/dev/ttyS0`. Restricting serial console access in the cloud provider's IAM is a customer-side dependency that preserves Lockdown's protection model.

### A.8 — Technological Controls

| Control | HeartSuite contribution |
|---|---|
| **A.8.2** — Privileged access rights | Immutable seal and per-program enforcement override root privilege at runtime. Root cannot execute new binaries, modify sealed files, or clear Lockdown state. Dashboard access requires Linux root credentials; no additional authentication layer exists within HeartSuite. Every allowlist approval action is recorded with timestamp, uid, and tty in `/var/log/heartsuite/allowlist-audit.log`; attributing those sessions to named personnel requires customer-side session logging (auditd or a PAM tool). The rotating application log (`/var/log/heartsuite/ui.log`) is supplementary. |
| **A.8.3** — Information access restriction | Per-program file-access allowlist restricts which paths each program can read or write. |
| **A.8.4** — Access to source code | Not covered natively; HeartSuite does not distinguish source code files. File-access allowlists can be configured to restrict access to specific paths. |
| **A.8.5** — Secure authentication | **Not covered.** HeartSuite provides no authentication mechanism. Sealing `/etc/passwd` and `sshd_config` is integrity of those files, not authentication. |
| **A.8.7** — Protection against malware | Default-deny execution allowlist prevents unauthorised binaries from running. No signature-based or behavioural malware detection. |
| **A.8.8** — Management of technical vulnerabilities | Not covered. HeartSuite constrains the impact of unpatched vulnerabilities via allowlist boundaries but does not scan for, report on, or remediate them. |
| **A.8.9** — Configuration management | Allowlist plus Lockdown is an enforced host configuration state. Changes take a maintenance window. No HeartSuite multi-host push. Customer automation applies policy per host. No emergency revocation while Lockdown is sealed. **Boot integrity:** fielded 6.18.9-hs has `CONFIG_KEXEC_FILE=y` and live LSM includes IMA/EVM; do not cite 5.19.6 `CONFIG_IMA` / `CONFIG_KEXEC_FILE` not-set as the current pin. Secure Boot for the HS kernel remains incomplete. See [Threat model](../kernel-hardening/auditor-brief/) and [Central Policy Management](../alerts/central-policy-management/). |
| **A.8.10** — Information deletion | Not covered. HeartSuite's restricted `rm` under Lockdown limits accidental deletion but has no secure-deletion or data-retention controls. |
| **A.8.11** — Data masking | Not covered. |
| **A.8.12** — Data leakage prevention | Partially. Network allowlist prevents outbound connections to unapproved destinations; it does not inspect the content of approved connections. |
| **A.8.13** — Information backup | File Backup & Versioning provides automatic per-write versioned snapshots. Under Lockdown the kernel blocks write and delete to `/.hs/b/` for every program except Root Lock backup tooling. Backup files are versioned filesystem copies with no encryption at the HeartSuite layer; for data-at-rest requirements (GDPR, HIPAA, PCI DSS), disk-level encryption (dm-crypt/LUKS) must be configured at the OS level. No offsite copy capability. |
| **A.8.15** — Logging | Kernel emits a per-**denial** enforcement stream (`HS-PROG-DENY`, `HS-FILE-DENY`, `HS-FILE-WDENY`, `HS-NET-DENY`) and a separate higher-level alert stream to the local journal under ident `heartsuite`. Every allowlist approval is written to `/var/log/heartsuite/allowlist-audit.log` (JSONL, timestamp, uid, tty; rotates at 1 MB + `.1`). An always-on rotating application audit log (`/var/log/heartsuite/ui.log`) captures UI and core events. On-device activity buffers are cleared on maintenance; the syslog streams and the JSONL approval log are the mechanisms for audit-period retention and reconstruction. Lockdown advisories are verdict-driven with provenance to the underlying records. |
| **A.8.16** — Monitoring activities | Alert triggers deliver denial events to email, syslog, webhook, or passive status endpoint (`~/.cache/heartsuite/status.json`, updated every 60 seconds — see schema below). Alert Settings Email tab sets **Node ID** (`node_id` in JSON), SMTP, and **Your email**. The Fleet tab sets **Setup Mode Alerts**, the syslog switch (local `/dev/log` only — no syslog-server field), and **Webhook URL (must be HTTPS)**. All of those are one-way outbound or local write. There is no built-in inbound API or remote allowlist control from HeartSuite itself. Central policy application and fleet-wide views are achieved by driving the per-host CLI tools (`hs-app-perm-orders-manager`, batch tools) from your automation and consuming the syslog streams, JSONL approval log, status.json, and webhook into your SIEM / CMDB / orchestration layer. See [Central Policy Management and External Control](../alerts/central-policy-management/). No fleet-wide or behavioural monitoring inside HeartSuite. |
| **A.8.17** — Clock synchronisation | Not covered. HeartSuite does not manage NTP or clock state. |
| **A.8.18** — Use of privileged utility programs | Under Lockdown, privileged tools (editors, module loaders, file operation utilities) are sealed. Kernel-module hardening documentation covers `kmod` allowlisting. |
| **A.8.19** — Installation of software on operational systems | Per-program execution allowlist enforces "approved programs only." New software cannot execute until it has been reviewed and approved through the Dashboard. |
| **A.8.20** — Networks security | Per-program network allowlist controls outbound connections using literal IPv4/IPv6 addresses only; CIDR notation and DNS-based rules are not supported. Inbound connection monitoring is not provided; inbound filtering is a customer-side responsibility via an OS packet filter or cloud security groups. VLAN segregation and firewall policy are out of scope. |
| **A.8.22** — Segregation of networks | **Not covered** as network-layer segregation. Host outbound allowlisting is a different control; do not cite this ID for it. |
| **A.8.23** — Web filtering | Not covered. HeartSuite filters by destination IP, not URL or content category. |
| **A.8.24** — Use of cryptography | No native encryption. HeartSuite configuration files (allowlist, mode state) are sealed by filesystem immutability flags but are not encrypted; they can be read from disk on a maintenance kernel boot. Backup snapshots are also unencrypted at the HeartSuite layer. OS-level disk encryption (dm-crypt/LUKS) is the required complementary control for data-at-rest compliance. |
| **A.8.28** — Secure coding | Not covered. HeartSuite does not inspect code or enforce secure development practices. |
| **A.8.29** — Security testing in development and acceptance | Not covered. |
| **A.8.30** — Outsourced development | Not covered. |
| **A.8.32** — Change management | Maintenance window workflow provides a structured, logged change process. All newly executed programs and file-access paths appear in Dashboard review queues before Lockdown can be re-engaged. |
| **A.8.33** — Test information | Not covered. |
| **A.8.34** — Protection of information systems during audit testing | **Not covered.** This is how the organization protects production during an auditor’s tests (copies, isolation). Lockdown is not that process. |

#### `hs-status.json` field reference

Written to `~/.cache/heartsuite/status.json` every 60 seconds by the HeartSuite daemon. Read-only; does not accumulate history.

| Field | Type | Notes |
|---|---|---|
| `node_id` | string | Configured host identifier |
| `mode` | string | `"Secure Mode"`, `"Setup Mode"`, or `"Unknown"`. `"Secure Mode"` is the on-disk token; the Dashboard and email copy say **Lockdown**. |
| `is_hs_kernel` | bool \| null | Whether the running kernel is the Root Lock kernel. `null` if the daemon did not observe the host this cycle. |
| `lockdown` | bool \| null | Whether the immutable seal is currently applied. Separate from `mode`. |
| `lockdown_on_boot` | bool \| null | Whether Lockdown re-engages on the next Root Lock boot |
| `pending_programs` | int \| null | Programs awaiting review |
| `pending_files` | int \| null | Sum of `pending_file_r` + `pending_file_w` |
| `pending_network` | int \| null | Network destinations awaiting review |
| `fully_protected` | bool \| null | True when `mode` is `"Secure Mode"` and the seal is applied |
| `subscription` | string \| null | `"Active"` or `"Expired"` |
| `version` | string | Build identity |
| `last_alert_at` | string | ISO 8601 UTC timestamp of last alert, or empty string |
| `updated_at` | string | ISO 8601 UTC timestamp of last daemon write |
| `daemon_ok` | bool | Whether the HeartSuite daemon is running normally |
| `channel_errors` | object | Present when the daemon writes an `AlertState` (includes empty strings when healthy) |
| └ `email.message` / `email.at` | string | Last email delivery error and its timestamp |
| └ `syslog.message` / `syslog.at` | string | Last syslog delivery error and its timestamp |
| └ `webhook.message` / `webhook.at` | string | Last webhook delivery error and its timestamp |

For Nagios/Zabbix/Ansible polling, `lockdown`, `is_hs_kernel`, and `daemon_ok` are the three fields that constitute a healthy Lockdown state. Treat `"Secure Mode"` plus `lockdown: true` as the sealed Lockdown posture.

---

## Open Questions

The following items remain open or only partly answerable. Kernel CVE process, OSV, and CycloneDX are no longer in that set.

### Evidence & Attestation

1. **Can HeartSuite export a signed compliance evidence package** — a machine-readable record of the current allowlist, Lockdown state, and alert history — for submission to an auditor or GRC platform? Today you harvest `status.json`, the JSONL approval log, and syslog. There is no signed, single-file evidence package.

2. **Does HeartSuite generate a time-stamped record of continuous Lockdown state?** `status.json` reflects current state only; the daemon's reboot history records reboots, not continuous Lockdown state. There is no historical status archive. (This is not an SSAE attestation.)

### Access Control & Identity

1. **How does HeartSuite interact with PAM, LDAP, or Active Directory?** No HeartSuite code calls PAM, LDAP, or any directory service. Regulated environments requiring centralised identity management must bridge this at the OS layer.

### Vulnerability & Patch Management

1. **How does HeartSuite handle kernel CVEs in its own kernel build?** Active kernel maintenance is evidenced by the 5.19.6 → 6.18 LTS port. Public patch targets, notification channels, and version-string semantics: [Kernel Support Policy](../kernel-hardening/kernel-support-policy/). Scanner workflow: [CVE Hygiene for Scanners](../kernel-hardening/cve-hygiene-for-scanners/). **OSV is published** (279 entries at [`/advisories/osv.json`](/advisories/osv.json)). Treat those OSV records as HeartSuite’s feed, not as a substitute for CSAF/VEX, and confirm gates on the **running pin** — fielded 6.18.9-hs does not compile BPF/FUSE/io_uring out. OVAL XML and GPG-signed bundles are not generally available. Binding SLAs remain in the subscription agreement. Measured 6.18.9-hs #37 scores are published; see [Evidence Status](../kernel-hardening/evidence-status/).

1. **Is there a published SBOM for the Root Lock kernel and Dashboard components?** *(Partially answerable.)* **CycloneDX** bundle SBOM and CONFIG-gate SBOM are published at [`/advisories/`](/advisories/index.json). Installer bundles still use SHA-256 only — there is no GPG or cosign signature. SPDX dual-format is not generally available. See [Supply Chain and Advisory Feeds](../kernel-hardening/supply-chain-and-advisories/).

1. **What is HeartSuite's vulnerability disclosure and response program?** *(Organisational — not in the product.)* A customer’s supplier questionnaire may ask for a disclosure policy. That is not ISO 27001 A.5.22 (customer monitoring of suppliers), and HeartSuite is not a CVE Numbering Authority.

### Incident Response & Recovery

1. **What is the documented RTO for restoring a Lockdown host after a security incident?** Recovery requires a minimum three-step, two-reboot sequence with manual Dashboard queue review. No time estimate is defined; duration is queue-dependent. There is no fast path.

1. **Can HeartSuite backups be restored to a different host?** The restore mechanism is local-only. There is no export, archive, or transfer capability; cross-host restore is architecturally absent.

1. **How are HeartSuite security incidents (in the product itself) disclosed to customers?** *(Organisational — not in the product.)* A.5.24 is the **customer organization’s** incident-management planning. Vendor notification terms live in the subscription agreement, not in that control.

### Scalability & Fleet Management

1. **What does the licensing model look like at scale?** *(Organisational — not in the product.)* No pricing tiers, volume discount structures, or MSP terms are publicly documented.

### Compliance Certifications

1. **Does HeartSuite map to sector-specific frameworks** — PCI DSS, HIPAA, NIS2, DORA, CMMC? **Not in this document.** Those regimes are not copy-paste of CSF 1.1 or ISO Annex A. NIS2 and DORA are not 800-171. CMMC Level 2 is 800-171-based; that still needs its own map. Do not treat this page as a PCI, HIPAA, NIS2, DORA, or CMMC mapping.

---

## Cloud Shared-Responsibility Matrix

When Root Lock runs as a guest VM on a cloud platform, responsibility for controls is split across three parties.

| Control layer | HeartSuite | Cloud provider | Customer |
|---|---|---|---|
| Kernel-level execution enforcement | Primary | — | — |
| Per-program file access control | Primary | — | — |
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
| Incident response program | — | — | Customer defines |

The most operationally significant customer responsibility in cloud deployments is **restricting serial console access**. Root Lock installs `agetty` autologin on `/dev/ttyS0`. Anyone who can reach the cloud provider's out-of-band serial console can boot to the maintenance kernel without further authentication from Root Lock.

Restricting serial console access at the cloud provider IAM layer is the control that preserves Lockdown's protection model in cloud environments.

---

## How Root Lock fits into a compliance program

Root Lock addresses a narrow but high-value control: **kernel-enforced, root-resistant mandatory access control**. It does not replace the controls listed below. A compliance program relying on Root Lock alone will have significant gaps.

| Layer | HeartSuite role | Complementary tool required |
|---|---|---|
| Execution control | Primary control | — |
| File access control | Primary control | — |
| Outbound network control | Primary control | Firewall / NAC for inbound |
| Configuration immutability | Primary control | — |
| File backup & recovery | Primary control | Offsite / encrypted backup for DR |
| Fleet-wide logging | Per-decision enforcement stream + dedicated JSONL approval log + rotating audit log (on-host); journal ident `heartsuite`; status.json and allowlist harvest for policy state | SIEM plus your automation / GitOps / ITSM for retention, correlation, and policy reconciliation |
| Behavioural detection | None | NDR / EDR |
| Vulnerability management | None | Scanner (Nessus, Qualys, Wiz) |
| Identity & access management | None | IAM / PAM platform |
| Data encryption | None | LUKS, TLS, application-layer encryption |
| Personnel & training controls | None | HRMS / LMS / GRC platform |
| Supplier management | None | GRC / vendor risk management |

For a NIST CSF or ISO 27001 program, Root Lock contributes most directly to the **Protect** function and **ISO 27001 A.8** (Technological Controls), with meaningful but partial contributions to logging, monitoring, and recovery.
