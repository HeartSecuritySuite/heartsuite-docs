---
title: "SOC 2 Control Mapping"
weight: 113
description: "HeartSuite Core Secure mapped to AICPA Trust Services Criteria (TSC) for SOC 2 Type I and Type II audits."
categories: ["Reference"]
tags: ["compliance", "SOC 2", "AICPA"]
type: docs
---

**Purpose**: This document maps HeartSuite Core Secure product capabilities to the AICPA Trust Services Criteria (TSC) used in SOC 2 audits. It is written for use by HeartSuite customers preparing for SOC 2 Type I or Type II audits, and as a reference document to hand to auditors.

Each criterion entry includes: the control requirement, how HeartSuite satisfies it, where it does not, and what evidence an auditor should request.

---

## Table of contents

- [How to use this document](#how-to-use-this-document)
- [CC6 — Logical and physical access controls](#cc6--logical-and-physical-access-controls)
- [CC7 — System operations](#cc7--system-operations)
- [CC8 — Change management](#cc8--change-management)
- [A1 — Availability](#a1--availability)
- [C1 — Confidentiality](#c1--confidentiality)
- [Summary table](#summary-table)

---

## How to use this document

HeartSuite Core Secure is deployed on Linux servers to enforce a default-deny security policy at the kernel level. It is a technical control your organization operates. In a SOC 2 audit:

- HeartSuite satisfies specific sub-criteria as a **technical control** in your control environment.
- You still need **organizational controls** (policies, procedures, access reviews, training) alongside it.
- Evidence artifacts listed here are those your auditor can observe, request logs of, or inspect directly on the system.

---

## CC6 — Logical and physical access controls

### CC6.1 — Logical access security: Restricting access to information assets

**Control requirement**: The entity implements logical access security measures to restrict access to information assets to authorized users.

**How HeartSuite satisfies this**:

HeartSuite Core Secure controls, per program, which programs can execute, which files they can read or write, and which network destinations they can connect to — independently of which user account runs them, including root. In Lockdown, every program must have an explicit allowlist entry before the kernel will permit it to execute, read or write files, or make outbound network connections.

The three dimensions of per-program access control:

| Dimension | HeartSuite mechanism |
|-----------|---------------------|
| Program execution | In Lockdown, the kernel refuses `execve()` for any program not in the allowlist |
| File access | Per-program read and write permissions; read and write approved separately |
| Network access | Per-program, per-destination IPv4/IPv6 allowlist; no CIDR ranges, hostnames, or wildcards |

Access permissions are built during Setup Mode via the Dashboard's review queues, where each program's execution, file access, and network access is presented for explicit human approval before Lockdown is activated.

Under Lockdown, the allowlist is sealed using filesystem immutability (`chattr +i`) and the running kernel refuses any modification to it — including from root. No program or user can extend access permissions at runtime.

**Scope**: HeartSuite records a timestamp and TTY for every allowlist approval action. In environments where multiple administrators share root access, TTY-to-person attribution requires correlating this log against customer-side session records — terminal session logging (`auditd`) or a privileged access management tool provides this attribution. Dashboard access requires Linux root credentials; there is no additional authentication layer within HeartSuite.

**Evidence artifacts**:

- Dashboard allowlist export (Programs, File Access, Internet Access queues)
- Allowlist approval audit log showing timestamp, TTY, and entry details for each approval action
- Lockdown status screenshot showing "Applied"
- `hs-manage-allowlist list` output showing per-program permissions
- Demonstration that a non-allowlisted program cannot execute while Lockdown is active

---

### CC6.3 — Role-based access control

**Control requirement**: The entity restricts access to information assets based on job responsibilities.

**How HeartSuite addresses this**:

HeartSuite does not implement role-based access control within the Dashboard. Every user with Linux root access has identical, unrestricted access to all Dashboard functions: allowlist approval, Lockdown activation and deactivation, alert configuration, log clearing, and maintenance mode. There is no operator/administrator distinction, no per-function permission check, and no audit trail distinguishing one root user's actions from another.

CC6.3 is an organizational control for this product. Restricting which personnel can reach root — and attributing their actions — requires customer-side controls: `sudoers` policy, a privileged access management tool, bastion host session recording, or equivalent.

**Evidence artifacts**:

- `sudoers` policy or PAM configuration showing which users can execute which HeartSuite commands
- Privileged access management records (bastion logs, PAM session records, or equivalent)
- Documentation of which personnel hold root access and under what job function

---

### CC6.6 — Logical access controls for infrastructure: Restricting privileged access

**Control requirement**: Logical access security measures restrict access to infrastructure, including operating system configurations, network configurations, and authentication databases.

**How HeartSuite satisfies this**:

HeartSuite Lockdown seals five categories of system infrastructure using `chattr +i` filesystem immutability. The Dashboard presents a per-category inventory before Lockdown is confirmed, and the Lockdown activation log records what was sealed.

The five sealed categories:

| Category | What is protected |
|----------|------------------|
| HeartSuite configuration | Allowlist files, mode state file, kernel image directory |
| System integrity | Shared libraries (`/usr/lib/`), systemd unit directories, SSH server config (`sshd_config`), sudo policy |
| Authentication state | `/etc/passwd`, `/etc/shadow`, `/etc/group`, no-login shells |
| Scheduled tasks and login scripts | Cron and anacron configuration, environment defaults, root shell profiles |
| Maintenance tools | File editors made non-executable; `rm`/`cp`/`mv` replaced with restricted copies |

While Lockdown is active, the kernel itself disables `chattr` — no user or program, including root, can remove the immutable flags. Modifying any of these resources requires booting the Non-HS kernel, which requires physical presence (keyboard and monitor, serial port, or cloud provider serial console).

This means an attacker who reaches root via SSH cannot modify the SSH server configuration, create new user accounts, change passwords, install malicious cron jobs, or plant login-script backdoors.

**Scope**: HeartSuite installs `agetty` autologin on the serial port (`/dev/ttyS0`). Whoever has access to the cloud provider's out-of-band console (AWS EC2 Serial Console, Azure Serial Console, GCP serial port, DigitalOcean Console) can reach the Non-HS kernel without further authentication from HeartSuite. Restricting serial console access is a customer-side organizational control enforced through cloud provider IAM — it is the final backstop of Lockdown's protection model.

**Evidence artifacts**:

- Lockdown activation log showing the five sealed categories and their file counts
- Demonstration that `/etc/passwd` cannot be modified while Lockdown+sealed is active
- Demonstration that SSH config cannot be modified while Lockdown+sealed is active
- `ls -la /.hs/sys/` showing immutable flags on allowlist files
- Cloud provider IAM policy restricting serial console access to named personnel

---

### CC6.7 — Transmission integrity and confidentiality

**Control requirement**: The entity restricts the transmission of confidential information to authorized internal and external users and protects it during transmission.

**How HeartSuite satisfies this**:

HeartSuite enforces per-program outbound network controls. In Lockdown, every outbound connection attempt by every program is either on the network allowlist or blocked at the kernel. This applies regardless of user privilege.

Specific transmission controls:

- **Outbound allowlist**: Each program has its own set of approved destination IP addresses. Approving a destination for one program does not grant any other program access to the same destination.
- **HTTPS enforcement**: Webhook alert delivery requires an HTTPS URL. HTTP (non-TLS) webhook URLs are rejected at configuration time.
- **C2 callback prevention**: In Lockdown, any program attempting to connect to a destination not in its network allowlist is blocked. This includes malware attempting to reach command-and-control infrastructure. The Log4Shell attack (CVE-2021-44228), which works by causing a vulnerable application to reach outbound to attacker infrastructure, is blocked at the network gate.
- **Exfiltration prevention**: Even if an attacker compromises an approved program, that program can only connect to destinations already in its network allowlist — destinations reviewed and approved by an administrator during Setup Mode.

**Scope**: HeartSuite enforces no inbound connection controls. Inbound network filtering (port restrictions, protocol controls) is a customer-side responsibility via the OS (`iptables`, `nftables`, `ufw`) or cloud security groups.

**Evidence artifacts**:

- Internet Access queue showing per-program, per-IP approvals
- Alert log showing blocked outbound connections (in Lockdown)
- Webhook configuration showing HTTPS requirement
- Demonstration that a new outbound connection attempt generates a block alert when the destination is not allowlisted

---

### CC6.8 — Malware and unauthorized software prevention

**Control requirement**: The entity implements controls to prevent or detect and act upon the introduction of unauthorized or malicious software.

**How HeartSuite satisfies this**:

This is the primary use case of HeartSuite Core Secure. The implementation is structural, not signature-based:

**Default-deny execution**: In Lockdown, the HeartSuite kernel refuses to execute any program not in the allowlist. A file downloaded to `/tmp` — a reverse shell, a credential dumper, a dropper — cannot execute. It has no allowlist entry. The kernel refuses the `execve()` call regardless of file permissions, user privilege, or whether the file was detected by any scanner.

**Interpreted code coverage**: Python, Perl, and PHP scripts are covered by Secure Script Launchers. Each script gets its own allowlist entry, separate from the interpreter. The Python interpreter may be on the allowlist; a malicious `.py` file dropped at `/tmp/attack.py` is not — in Lockdown, it is blocked before the interpreter processes it.

**Reduced kernel features attackers can reach**: Features commonly exploited by rootkits and malware to escalate privilege or hide activity are not compiled into the HeartSuite kernel:

- eBPF (`CONFIG_BPF_SYSCALL` not present — no BPF-based process hiding)
- FUSE (`CONFIG_FUSE_FS` not present — no FUSE-based filesystem redirection)
- Overlay filesystem (not present — no overlay-based directory shadowing)
- Unprivileged user namespaces (disabled — primary path for privilege escalation without credentials)
- AppArmor/SMACK/Landlock (not present — no LSM pivot path)

**Module loading restriction**: In Lockdown, `kmod`, `modprobe`, and `insmod` have no allowlist entries by default and cannot execute. Module-based rootkits cannot be installed because the module loaders cannot run. Where kmod is required for hardware drivers, its file access permissions can be restricted to specific `.ko` paths, preventing it from loading unauthorized modules.

**Post-compromise file recovery**: When an approved program is compromised and encrypts or corrupts files (e.g., ransomware running inside an approved process), HeartSuite's per-write backup preserves every version. Recovery starts from the moment before the damage began, not the last scheduled backup window. Under Lockdown, the kernel blocks all programs from accessing the backup directory — backups cannot be destroyed even by an attacker running as root.

**Alert on new blocked programs**: In Lockdown, any program path that appears in the denial log and has never appeared in any prior log session triggers an alert to all configured channels immediately.

**Evidence artifacts**:

- Alert log showing blocked execution attempts in Lockdown
- Dashboard Programs queue showing items blocked and denied
- Kernel configuration file (`/.hs/sys/` kernel config) showing compiled-out features
- CVE status table from Kernel Security Transparency page showing features not compiled in
- Backup configuration and version history showing per-write versioning

---

## CC7 — System operations

### CC7.1 — Detection of vulnerabilities and threats

**Control requirement**: The entity uses detection and monitoring procedures to identify (1) changes to configurations that introduce vulnerabilities; (2) susceptibility to new vulnerabilities; (3) security events indicating potential or actual threats.

**How HeartSuite satisfies this**:

**Vulnerability surface reduction**: HeartSuite reduces the kernel features attackers can reach by removing them at compile time. The Kernel Security Transparency page documents every relevant CVE against the HeartSuite kernel, with per-CVE "Score on HeartSuite" ratings showing the actual risk after HeartSuite's structural mitigations. CVEs affecting kernel features not compiled into HeartSuite receive a Score on HeartSuite of 0.0 — the vulnerable feature is not present in the HeartSuite kernel by design.

**Configuration change detection**: Under Lockdown, the allowlist is sealed and cannot be changed. Any attempt to modify allowlist files, HeartSuite configuration, or system integrity files (shared libraries, systemd units, SSH config) is blocked at the kernel level and can be detected via the "Critical file version created outside maintenance window" alert, which fires when a new backup version is created for files under `/etc/`, `/bin/`, `/usr/bin/`, `/sbin/`, `/lib/`, or `/usr/lib/` while Lockdown is active.

**Threat detection in operation**:

| Threat signal | HeartSuite detection mechanism |
|--------------|-------------------------------|
| New malware execution attempt | Block alert: "Previously unseen program blocked" |
| C2 callback or data exfiltration | Block alert: "Network burst to new destinations" |
| File modification attempt in protected paths | Block alert: "Critical file version created outside maintenance" |
| Mode/state changes (Setup ↔ Lockdown) | Immediate alert on all channels on every state change |
| New allowlist pushed while Lockdown active | Immediate alert on all channels |

**Integration with vulnerability management**: HeartSuite is explicitly designed to complement — not replace — vulnerability scanners (Tenable Nessus, Qualys VMDR, Rapid7 InsightVM). HeartSuite reduces the blast radius of an unpatched vulnerability; the scanner maps what needs patching. Both controls are needed for SOC 2.

**Evidence artifacts**:

- Alert channel configuration (email, syslog, webhook)
- Alert log showing state-change alerts
- Syslog forwarding configuration to SIEM (rsyslog rule in `/etc/rsyslog.d/heartsuite.conf`)
- CVE status table showing HeartSuite's kernel vulnerability posture
- Vulnerability scanner reports (separate tool — HeartSuite does not provide this)

---

### CC7.2 — System monitoring for anomalies and indicators of compromise

**Control requirement**: The entity monitors system components and the operation of those components for anomalies that are indicative of malicious acts, natural disasters, and errors affecting the entity's ability to meet its objectives.

**How HeartSuite satisfies this**:

**Continuous protection state monitoring**:

The HeartSuite Dashboard displays a full-width, high-contrast protection state indicator showing the current system state at all times:

| State | Indicator |
|-------|-----------|
| Setup Mode | SETUP MODE — logging only, nothing is blocked |
| Lockdown (no immutable seal) | LOCKDOWN — immutable seal not applied |
| Lockdown + sealed | Blank (silence means safety) |
| Non-HS kernel | NON-HS KERNEL — no blocking, logging, or backups |

**Status JSON polling surface**: `~/.cache/heartsuite/status.json` is updated every 60 seconds. Ansible, Nagios, Zabbix, and similar tools can read this file via SSH pull for automated health checks. No additional configuration required.

**Syslog integration**: When syslog is enabled, all alerts are written to the system log via `/dev/log` using the `heartsuite-alert` ident, `LOG_AUTH` facility, and `LOG_WARNING` severity. These can be forwarded to any SIEM via an rsyslog output rule:

```
# /etc/rsyslog.d/heartsuite.conf
if $programname == 'heartsuite-alert' then @@siem-host:514
```

**Webhook integration**: Every alert is POSTed immediately as a JSON payload to the configured webhook endpoint. Example payload structure:

```json
{
  "node_id":    "prod-web-03",
  "event_type": "new_program_blocked",
  "timestamp":  "2026-03-31T14:22:00Z",
  "mode":       "Lockdown",
  "lockdown":   false,
  "paths":      ["/tmp/dropper", "/tmp/payload"],
  "count":      2
}
```

This payload can drive PagerDuty, OpsGenie, Slack, or any incident management tool.

**Log retention**: The on-device activity log (`/.hs/sys/HS_log.txt`) is cleared on every maintenance cycle and auto-cleared when all review queues drain in Setup Mode. The UI audit log (`/var/log/heartsuite/ui.log`) is size-capped at approximately 8 MB with no time-based retention. For SOC 2 Type II evidence spanning a 6- or 12-month audit period, syslog forwarding to a customer-operated SIEM is required — on-device logs alone do not support audit-period-length retention.

**Evidence artifacts**:

- Syslog forwarding rule in `/etc/rsyslog.d/heartsuite.conf`
- Sample alert payloads from webhook endpoint
- `~/.cache/heartsuite/status.json` showing current system state
- SIEM alert records covering the audit period (customer-operated SIEM required for Type II evidence)
- Verification: `journalctl -t heartsuite-alert --since "1 hour ago"` showing alert activity

---

### CC7.3 — Evaluation of security events

**Control requirement**: The entity evaluates security events to determine whether they could or have resulted in a failure of the entity to meet its objectives, and, if so, takes actions to prevent or address such failures.

**How HeartSuite satisfies this**:

HeartSuite classifies security events into two tiers:

**Immediate alerts (administrative state changes)** — these fire on all channels with no delay:

- Mode switch (Setup Mode ↔ Lockdown)
- Lockdown activation or deactivation
- New allowlist file pushed while Lockdown is active

**Threshold-filtered alerts (operational blocks)** — these apply noise reduction before delivery, while syslog and webhook receive them immediately:

- Previously unseen program blocked (appears in denial log for the first time)
- Network burst to new destinations (single program, multiple new destinations, 2-hour window)
- Critical file version created outside maintenance window

**What is never alerted** (documented in the product to prevent alert fatigue):

- Anything in Setup Mode
- Repeated blocks of a program-destination pair already seen in the current session
- File version activity under `/tmp/`, `/var/tmp/`, or `/dev/shm/`

In Lockdown, the Dashboard's review queues shift from approval mode to read-only investigation mode. Denied items appear in the queues. Use `[n]` to navigate denied items. Each denied item shows the program, path, and attempt count — the same metadata used during approval.

**Evidence artifacts**:

- Alert Settings configuration screenshot showing configured channels
- Alert log from a known test event (using the Test Email function)
- Dashboard Lockdown queue showing denied items and investigation workflow
- SIEM correlation rules that consume the HeartSuite alert feed (customer-operated SIEM required for audit-period-length evidence)

---

### CC7.4 — Incident response

**Control requirement**: The entity responds to identified security incidents by executing a defined incident response program.

**How HeartSuite satisfies this**:

HeartSuite provides technical controls for the detection and containment phases of incident response. It does not provide a full incident response program — that is an organizational control. HeartSuite's role in incident response:

**Containment (structural)**:

- Under Lockdown, a compromised program cannot launch new programs, cannot exceed its file access permissions, cannot connect to unapproved network destinations, and cannot modify the allowlist or system configuration
- These constraints apply automatically — they do not require responder action during the incident
- Nothing the attacker ran survives a reboot (allowlist modifications are in-memory only; the on-disk allowlist is immutable)

**Investigation**:

- Dashboard Lockdown queue shows all denied items (blocked programs, file accesses, network connections) with timestamps and paths
- `journalctl -t heartsuite-alert` provides a timestamped log of all alerts
- File version history in Dashboard Backup shows what changed and when, supporting forensic timeline reconstruction

**Allowlist update during active incident**:

- If a compromised program must be removed from the allowlist, a maintenance window is required (Option 1: switch to Setup Mode, or Option 2: boot Non-HS kernel for Lockdown recovery)
- Maintenance presents a safety checklist (network isolation, daemon shutdown, SSH restriction) before allowing mode changes

**Recovery**:

- File Backup allows restoring any file to any prior version, including versions from before a compromise began
- Timeline view allows batch restore of all files modified on a given date — the appropriate tool for ransomware recovery

**Scope**: HeartSuite does not provide a customer-facing incident response policy template. An IR policy covering escalation contacts, communication plan, SLAs, and regulatory notification is an organizational control that must be supplied by the customer. HeartSuite's technical containment and investigation capabilities serve as the evidence base for that policy.

**Evidence artifacts**:

- Incident response policy document (organizational — customer-supplied)
- Alert logs from the incident under investigation
- Maintenance window log showing the date and steps of allowlist update
- Backup restore log from `hs-version-manager` or Dashboard Backup showing recovery actions

---

### CC7.5 — Recovery from security incidents

**Control requirement**: The entity identifies, develops, and implements activities to recover from identified security incidents and communicates those activities.

**How HeartSuite satisfies this**:

**Per-write versioned backups**:

HeartSuite creates a backup version of every file write in protected directories. Unlike scheduled snapshot tools, there is no backup window — if a file is encrypted or corrupted at 3:47 AM, the version from 3:46 AM exists. This is the gap that ransomware exploits in schedule-based backup tools (and the gap CVE-2024-40711 for Veeam Backup & Replication exploited by targeting the backup agent itself).

Under Lockdown, backup files are protected by the kernel itself — no program, including root, can read or overwrite them. The backup agent itself is not a running process and cannot be killed; the protection is structural.

**Recovery workflow**:

| Recovery scenario | HeartSuite tool |
|------------------|----------------|
| Single file corrupted | Dashboard Backup → File-first browse → select version → restore |
| Ransomware: many files modified same day | Dashboard Backup → Timeline view → filter by date → batch restore |
| Restore from CLI/automation | `hs-version-manager restore <path> --version <timestamp>` |
| List available versions | `hs-version-manager list <path>` |

**System recovery after HeartSuite kernel failure**:

If the HeartSuite kernel fails to load, the startup script isolates the primary network interface and removes all immutable flags. The system is then without HeartSuite protection and without network access. Recovery requires booting to the Non-HS kernel from physical or serial-console access.

**Scope**: Backup files are versioned filesystem copies — there is no encryption at the HeartSuite layer. If backup confidentiality at rest is required, disk-level encryption (dm-crypt/LUKS) must be configured at the OS level by the customer. An alert fires when backup transitions from enabled to disabled, and when any previously-covered directory is removed from coverage.

**Evidence artifacts**:

- Backup configuration showing protected directories
- Test restore log demonstrating successful file recovery
- Backup directory listing showing version history for a protected file
- Recovery procedure documentation (this document and the product's Maintenance guide)

---

## CC8 — Change management

### CC8.1 — Controls for changes to infrastructure and software

**Control requirement**: The entity authorizes, designs, develops or acquires, configures, documents, tests, approves, and implements changes to infrastructure, data, software, and procedures to meet its change management objectives.

**How HeartSuite satisfies this**:

**All changes require a maintenance window**:

Any change to system configuration, installed software, or network access patterns requires switching to Setup Mode first. This is enforced by the kernel — in Lockdown, package installations fail because `dpkg` cannot create temporary directories that the kernel blocks. Software updates cannot be installed silently while Lockdown is active.

The required change management flow:

1. Open a maintenance window from the Dashboard (Maintenance `[t]`)
2. Complete the safety checklist (network isolation, daemon shutdown, SSH restriction)
3. Confirm mode switch (type `YES`)
4. Make changes — install packages, update configuration, apply updates
5. Review new activity in the Dashboard queues (new programs, file accesses, network destinations)
6. Approve new entries explicitly before re-engaging Lockdown

**Update integrity verification**:

HeartSuite updates are delivered as a single self-extracting bundle (`heartsuite-install.sh`). Before running the installer, the SHA-256 checksum must be verified against the published value:

```bash
sha256sum -c heartsuite-install.sh.sha256
```

The installer aborts if run on the active HeartSuite kernel, requiring the two-reboot update sequence that prevents unapproved code from replacing the kernel while it is running.

**Allowlist as change record**:

The allowlist is the authoritative record of every program, file access, and network connection that has been reviewed and approved. Every entry was created by an administrator pressing `[a]` to approve a specific item. The allowlist itself, stored in `/.hs/sys/`, is immutable under Lockdown.

**Scope**: Update integrity relies on SHA-256 checksum verification — there is no GPG or PGP signature authenticating the bundle's origin against a HeartSuite-controlled signing key. The checksum verifies the file arrived intact; supply-chain authentication depends on retrieving the bundle and checksum over HTTPS from the HeartSuite distribution endpoint. Each server manages its own allowlist independently; there is no centralized allowlist distribution or push mechanism. In fleet deployments, allowlist changes must be applied per server.

**Evidence artifacts**:

- Maintenance window log showing dates of mode changes
- Update installation log at `/var/log/heartsuite/install.log`
- SHA-256 verification output from update procedure
- Allowlist showing programs, file accesses, and network destinations approved for each maintenance cycle
- Dashboard queue review records showing items approved during each maintenance window

---

## A1 — Availability

### A1.2 — Environmental threats and system components

**Control requirement**: The entity protects against or mitigates environmental threats that could impair the availability of the system.

**How HeartSuite satisfies this**:

**Ransomware resilience**: The primary availability threat to production servers is ransomware. HeartSuite addresses this at two layers:

1. **Prevention layer**: In Lockdown, programs not on the allowlist cannot execute — a ransomware binary dropped on the server cannot run.
2. **Recovery layer**: If ransomware runs inside an approved process (e.g., malware that hijacks a legitimate application), per-write backups preserve all file versions. Under Lockdown, the kernel protects backup files from the compromised process.

**Malware persistence prevention**: Nothing an attacker installs survives a reboot. Cron jobs, systemd units, and shell profile backdoors are sealed under Lockdown. A rebooted system returns to the state at Lockdown activation.

**Maintenance safety checklist**: Before any mode change, the Dashboard presents a checklist that flags network exposure, active daemons, and SSH configuration. This reduces the risk of an attacker exploiting the maintenance window (the period when blocking is temporarily suspended).

**Scope**: HeartSuite does not prevent denial-of-service (DoS) at the application or network layer. Root can `kill -9` approved services or panic the kernel. Availability hardening against DoS requires a separate control. An alert fires when backup is disabled or a covered directory is removed from coverage. HeartSuite's ransomware prevention and per-write recovery remain in place regardless.

**Evidence artifacts**:

- Backup configuration showing protected directories and version history
- Alert log showing ransomware-related blocked execution attempts
- Maintenance window log showing safety checklist completion

---

## C1 — Confidentiality

### C1.1 — Protection of confidential information

**Control requirement**: The entity identifies and maintains confidential information to meet the entity's objectives related to confidentiality.

**How HeartSuite satisfies this**:

**File access containment**: Every program can only read the files in its file access allowlist. A compromised application cannot read credentials, private keys, or confidential data that it was never approved to access during Setup Mode. This applies regardless of user privilege.

**Exfiltration prevention**: Even if a program can read confidential data within its file access allowlist, it cannot send that data to an unapproved destination. The network allowlist restricts each program to specific IPs. A program with no approved outbound destinations has no exfiltration path at all.

**Scope**: An attacker who reaches root on the running system can read disk content with direct kernel-level access. Confidentiality *during* a live breach session is the role of disk encryption (dm-crypt/LUKS), not HeartSuite Lockdown. Backup files are versioned filesystem copies with no encryption at the HeartSuite layer; disk-level encryption covers backup files if applied at the OS level. HeartSuite limits what data can be *exfiltrated*, not what data can be *read* from a running kernel session.

**Evidence artifacts**:

- File access allowlist showing that programs are scoped to their required paths
- Network allowlist showing outbound destinations per program
- Disk encryption configuration (separate control — customer-supplied)

---

## Summary table

| SOC 2 criterion | HeartSuite coverage | Evidence type |
|-----------------|---------------------|---------------|
| CC6.1 Logical access | Program/file/network allowlist; kernel-level blocking in Lockdown | Allowlist export, Dashboard screenshot |
| CC6.3 Role separation | Not implemented — flat root access; organizational control required | Customer `sudoers` policy, PAM records |
| CC6.6 Infrastructure access | Lockdown seals 5 categories (`chattr +i`); Non-HS kernel requires physical/serial presence | Sealed file inventory, Lockdown activation log |
| CC6.7 Transmission protection | Per-program outbound allowlist in Lockdown; HTTPS-only webhook; no inbound controls | Network allowlist, webhook config |
| CC6.8 Malware prevention | Default-deny execution in Lockdown; Secure Script Launchers; compiled-out rootkit features; per-write backup | Block alert log, CVE table, backup config |
| CC7.1 Threat detection | Block alerts (new program, network burst, critical file); SIEM syslog integration | Alert configuration, syslog rule, alert log |
| CC7.2 System monitoring | Protection state indicator; status.json; syslog/webhook push; on-device logs cleared on maintenance | SIEM records required for Type II audit period |
| CC7.3 Security event evaluation | Alert classification (immediate vs. threshold); Lockdown queue for investigation | Alert logs, denied-item queue, SIEM records |
| CC7.4 Incident response | Structural containment; investigation queue; file restore; no customer IR runbook template | Maintenance log, restore records, customer IR policy |
| CC7.5 Recovery | Per-write versioned backup under kernel protection; alerts on backup-disabled and coverage-reduced transitions; no encryption at HeartSuite layer | Backup config, version history, restore log |
| CC8.1 Change management | Maintenance window required; SHA-256 update verification (no GPG); per-server allowlist only | Maintenance log, install log, allowlist |
| A1.2 Availability protection | Ransomware blocking in Lockdown + per-write recovery; malware persistence prevention | Backup config, alert log, maintenance checklist |
| C1.1 Confidentiality | File access scoping; outbound exfiltration prevention; no backup encryption at HeartSuite layer | File/network allowlist, disk encryption config |

---

Last Updated: 2026-05-28
