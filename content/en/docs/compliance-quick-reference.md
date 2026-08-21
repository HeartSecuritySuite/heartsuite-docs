---
title: "Compliance questions, answered on one page"
linkTitle: "Compliance Quick Reference"
weight: 111
description: "Direct answers for sales, briefings, and customer GRC preparation, with links to the NIST, ISO 27001, and SOC 2 maps."
categories: ["Reference"]
tags: ["compliance", "NIST", "ISO 27001", "quick reference"]
type: docs
---

Detailed control mappings are in the [Compliance Reference: NIST CSF & ISO 27001](../heartsuite-compliance-nist-iso27001/) and [SOC 2 Control Mapping](../soc2/) documents. This page gives direct answers to the questions that come up most often.

---

**What does Root Lock by HeartSuite enforce?**

Three gates: execution (default-deny binary allowlist), file access (per-program path restrictions), and network (per-program outbound IPv4/IPv6 allowlist). All three apply including to programs running as root.

---

**What does Lockdown seal?**

Five categories, using `chattr +i`: Root Lock configuration and kernel image directory; system integrity (`/usr/lib/`, systemd units, SSH config, sudo policy); authentication files (`/etc/passwd`, `/etc/shadow`, `/etc/group`); scheduled tasks and login scripts (cron/anacron, root profiles); and maintenance tools (editors made non-executable; `rm`/`cp`/`mv` replaced with restricted copies).

File backup snapshots are a separate kernel write-protection of `/.hs/b/`, not a sixth `chattr` category. Under Lockdown, no program except Root Lock backup tooling can write or delete those versions, including root.

These are the paths sealed by default. During maintenance on the maintenance kernel, temporary "write" grants may be shown for some of them so tools can function; the grants disappear once you return to Lockdown. See [Lockdown](../lockdown/) for the full list and behaviour.

---

**What is Root Lock's primary NIST CSF function?**

**Protect**. It makes partial contributions to Identify (software inventory via the allowlisting workflow), Detect (denial-event logging and alerting), and Recover (per-write file versioning). It does not cover Respond.

---

**Which ISO 27001:2022 Annex A controls can a customer SoA cite as technical contributions?**

A.8 technological controls, especially A.8.2, A.8.3, A.8.7, A.8.9, A.8.13, A.8.15, and A.8.19. Cite them as contributions on the customer's Statement of Applicability. A.5.15 is the customer's access **policy**; the kernel can enforce that policy once it exists. ICT supply chain is **A.5.21**. **A.5.23** is cloud-use governance.

---

**What is explicitly not covered?**

- A.6 — all People Controls (personnel screening, training, separation of duties)
- A.7 — Physical Controls (Root Lock *depends on* physical or serial-console security; it does not provide it)
- Threat intelligence, SIEM, anomaly detection, RBAC within the Dashboard, vulnerability scanning, data encryption, NTP synchronisation, offsite backup

---

**What is the cloud serial-console bypass risk?**

Root Lock installs `agetty` autologin on `/dev/ttyS0`. Cloud providers' out-of-band serial consoles (AWS EC2 Serial Console / Get system log, Linode LISH, Hetzner console, GCP serial port, Azure Serial Console, DigitalOcean Console, etc.) give the same bypass path as a keyboard.

From the serial console you can `cat /var/log/heartsuite/install.log` (installer), `cat /var/log/heartsuite/initial-setup-latest.log`, `journalctl -t heartsuite`, and similar. Restricting serial console access is a customer-side cloud IAM responsibility.

---

**What are the logging retention limits?**

`/.hs/sys/HS_log.txt` is a temporary denial buffer. The Dashboard clears it in Setup Mode when the review queues are empty and Secure Script Launchers is not still pending. A maintenance reboot also clears it. At about 32 MiB the file is rotated in place.

`/var/log/heartsuite/ui.log` is capped at about 8 MB. Approvals go to `/var/log/heartsuite/allowlist-audit.log`. Long-term SIEM evidence is the journal ident `heartsuite`, after you enable Syslog on Alert Settings → Fleet. Protected enforcement state lives in `/.hs/sys/` (not standard logs). These files are visible on the serial console.

---

**What audit logging and SIEM integration does Root Lock provide?**

Every allowlist approval (programs, file paths, network destinations) is written to `/var/log/heartsuite/allowlist-audit.log` with timestamp, uid, and tty.

When Fleet Syslog is enabled, denial lines and aggregated alerts are written to the journal under ident `heartsuite` for Splunk, Elastic, Datadog, QRadar, and similar platforms. Successful allowlisted work is not logged. `ui.log` is the rotating application log. Lockdown advisories are verdict-driven and provenance-gated for high-signal auditability.

---

**What is the Dashboard access control model?**

No RBAC. Every Linux root user has identical access to all Dashboard functions. There is no operator/administrator distinction and no extra authentication layer inside Root Lock.

Every allowlist approval is written to `/var/log/heartsuite/allowlist-audit.log` with timestamp, uid, and tty. Attributing those sessions to named people requires customer-side controls: `sudoers` policy, a privileged access management tool, or bastion host session recording.

---

**What is the network allowlist limitation?**

Literal IPv4/IPv6 addresses only — no CIDR notation, no DNS-based rules. Inbound connection filtering is out of scope; a customer-side OS packet filter or cloud security groups are the required complementary control.

---

**What is the signing and integrity status of update bundles?**

Installer bundles: SHA-256 checksum only. There is no GPG or PGP signature verifying the bundle's origin against a HeartSuite-controlled signing key. Authenticity depends on retrieving the bundle over HTTPS from the HeartSuite distribution endpoint.

Machine-readable artifacts at [`/advisories/`](/advisories/index.json): CONFIG-gate SBOM, OSV, and CycloneDX. SPDX dual-format and GPG/cosign signing are not generally available. See [Supply Chain and Advisory Feeds](../kernel-hardening/supply-chain-and-advisories/).
