---
title: "Compliance Quick Reference"
weight: 111
description: "One-page answers to the most common compliance questions about Root Lock by HeartSuite — for auditors, sales conversations, and internal briefings."
categories: ["Reference"]
tags: ["compliance", "NIST", "ISO 27001", "quick reference"]
type: docs
---

Detailed control mappings are in the [Compliance Reference: NIST CSF & ISO 27001](../heartsuite-compliance-nist-iso27001/) and [SOC 2 Control Mapping](../soc2/) documents. This page gives direct answers to the questions that come up most often.

---

**What does HeartSuite enforce?**

Three gates: execution (default-deny binary allowlist), file access (per-programme path restrictions), and network (per-programme outbound IPv4/IPv6 allowlist). All three override root privilege.

---

**What does Lockdown seal?**

Authentication files (`/etc/passwd`, `/etc/shadow`), SSH configuration, systemd units, sudo policy, cron/anacron, `/usr/lib/`, and HeartSuite's own configuration and kernel image directory — plus file backup snapshots (no programme, including root, can access them at runtime).

These are the paths sealed by default. During maintenance on the Non-HS kernel, temporary "write" grants may be shown for some of them so tools can function; the grants disappear once you return to Lockdown. See [Mode Switching and Lockdown](../mode-switching/) for the full list and behaviour.

---

**What is HeartSuite's primary NIST CSF function?**

**Protect**. It makes partial contributions to Identify (software inventory via the allowlisting workflow), Detect (denial-event logging and alerting), and Recover (per-write file versioning). It does not cover Respond.

---

**Which ISO 27001:2022 Annex A areas are primary strengths?**

A.8 (Technological Controls) — particularly A.8.2, A.8.3, A.8.7, A.8.9, A.8.13, A.8.15, A.8.19. Also A.5.15 and A.5.23 (partially).

---

**What is explicitly not covered?**

- A.6 — all People Controls (personnel screening, training, separation of duties)
- A.7 — Physical Controls (HeartSuite *depends on* physical security; it does not provide it)
- Threat intelligence, SIEM, anomaly detection, RBAC within the Dashboard, vulnerability scanning, data encryption, NTP synchronisation, offsite backup

---

**What is the cloud serial-console bypass risk?**

HeartSuite installs `agetty` autologin on `/dev/ttyS0`. Cloud providers' out-of-band serial consoles (AWS EC2 Serial Console, GCP serial port, Azure Serial Console, DigitalOcean Console) give the same bypass path as physical keyboard access. Restricting serial console access is a customer-side cloud IAM responsibility.

---

**What are the logging retention limits?**

`/.hs/sys/HS_log.txt` is cleared on each maintenance cycle. `/var/log/heartsuite/ui.log` is capped at approximately 8 MB with no time-based retention policy. There is no tamper-evident off-host log — a SIEM receiving the syslog alert feed is required for audit-period-length evidence (SOC 2 Type II, ISO 27001 surveillance).

---

**What is the Dashboard access control model?**

No RBAC. Every Linux root user has identical, unrestricted access to all Dashboard functions. There is no operator/administrator distinction and no per-user audit attribution within HeartSuite. Attributing actions to named individuals requires customer-side controls: `sudoers` policy, a privileged access management tool, or bastion host session recording.

---

**What is the network allowlist limitation?**

Literal IPv4/IPv6 addresses only — no CIDR notation, no DNS-based rules. Inbound connection filtering is out of scope; customer-side OS firewall (`iptables`, `nftables`) or cloud security groups are the required complementary control.

---

**What is the signing and integrity status of update bundles?**

SHA-256 checksum only. There is no GPG or PGP signature verifying the bundle's origin against a HeartSuite-controlled signing key. Authenticity depends on retrieving the bundle over HTTPS from the HeartSuite distribution endpoint.
