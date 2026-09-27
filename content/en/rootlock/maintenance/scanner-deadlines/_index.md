---
title: "Defer the scanner findings Lockdown already stops"
linkTitle: "Scanner deadlines"
weight: 7
description: "Which findings can wait for the standard change window under Lockdown, which stay on the patch date, and how to file the exception in the scanner you already run."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "scanner"]
type: docs
aliases:
  - /docs/maintenance/scanner-deadlines/
toc: true
---

**Overview**: Under Lockdown, some critical scanner findings can wait for your standard change window. Those are the findings where exploiting the bug only gets an attacker as far as a step Root Lock refuses: running a dropped binary, opening a file the vulnerable program was never granted, or connecting to a destination outside its network allowlist. A finding the attacker can complete inside the program's existing grants — reading files it already reads, sending to a destination it already reaches — stays this week's work. You record the deferral as one exception rule in the scanner you already run. That rule changes the scanner's score, report, and remediation queue until it expires. It does not change the patch date in your policy or contract.

## Which findings can wait

A finding can leave the active queue when the attacker's next step after the exploit is something Lockdown already stops:

- The next step is a program with no allowlist entry. The kernel matches the path, so a copy of an allowed binary at a new path is a new program with no entry.
- The next step is a file the program was not granted.
- The next step is a destination the program was not granted.

The vulnerable code is still on the host, so file these with a compensating-control or accepted-risk reason — the reason column in [Record the reason in that scanner](#record-the-reason-in-that-scanner) — and an expiry. A false-positive reason records that the vulnerability is absent, which is not true here, and the expiry is what brings the finding back for the patch.

In the comment, name the step Lockdown stops: a dropped binary, a new destination, or — for a privilege-escalation finding — a root process that still runs under the allowlist. Where your policy sets the standard change window at 60 or 90 days for work it does not rank critical, set the expiry to that window.

The deferral holds only while the host is in Lockdown. In Setup Mode the kernel logs but stops blocking until you return to Lockdown, so plan maintenance windows on these hosts with the open findings in mind. See [Protecting During Maintenance](../protecting-during-maintenance/).

## Which findings stay on the patch date

Two kinds of finding keep the patch date whatever the exploit's next step: a known-exploited finding on the [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities) list, and anything your policy ranks critical.

The rest stay because the attack completes inside what the program is already allowed to do, so there is no refused step for Lockdown to stop:

- In-process bugs, on data the program already reads
- Kernel CVEs whose code is in the kernel you boot
- Injection inside an allowlisted process
- Denial of service
- An already-permitted destination
- The vulnerable app's own files

An exception for one of these is a rule you file on your own policy's terms, not on Lockdown's. Lockdown still refuses the attacker's next unapproved program, file, or destination on those hosts, so the patch closes the bug and the allowlist bounds what the bug can reach before it lands.

## Kernel CVEs for code that is not in the kernel

The false-positive or not-affected reason is for one case: a kernel CVE whose code is absent from the kernel you boot. Record the config gate that leaves it out on the rule. The catalog of gates and the CVEs each one covers is [Kernel Security Transparency](../../security/).

On the 6.18 kernel, the BPF syscall is off. io_uring, FUSE, user namespaces, OverlayFS, nftables, and KVM are in that kernel, so their CVEs stay on the patch date. `apt` and `dnf` update the OS packages and leave the Root Lock kernel as shipped, so a package update does not change which kernel code is present.

A scanner that flags a kernel CVE from the version string alone follows [CVE Hygiene for Scanners](../../kernel-hardening/cve-hygiene-for-scanners/).

## File the exception

File the rule on the asset group, tag, or range those hosts already belong to, and put the reason, the comment, and the expiry on that rule. If the scanner asks for an approver or a review date, record those on the same rule.

The exception expiry and the remediation SLA are two different dates. The expiry is how long the scanner treats the finding as handled. The SLA is the patch date in your policy or contract, and the exception does not move it. A policy that requires installs within seven days still requires them within seven days — the exception rule is what records that this finding is allowed to wait longer.

## Keep evidence for the exception window

Keep a record with the rule that shows Lockdown held for the exception's dates:

- If those hosts already ship syslog, save a search on identifier `heartsuite` for those dates. It returns the denials and alerts.
- If a monitor already polls `status.json`, its history for `lockdown` and `daemon_ok` covers the same dates.
- On one host, when the shipper is down, `journalctl -t heartsuite --since` and `--until` cover those dates.

See [SIEM Integration](../../alerts/siem-integration/).

## Record the reason in that scanner

Each link goes to the vendor's own article. Menu labels come from that article and can change between releases. Where an article names a 30-day or 90-day field, that field is the exception expiry, not your remediation SLA.

| Scanner | Reason | What changes | Documentation |
|---|---|---|---|
| Rapid7 InsightVM | Compensating Control | Drops the finding from the risk score and from reports. Expiry is an optional date. | [Working with vulnerability exceptions](https://docs.rapid7.com/insightvm/working-with-vulnerability-exceptions) |
| Tenable Security Center | Accept Risk | Hides the finding from a search that excludes Accepted Risk. Comment is free text. Expiry is a date you select. | [Manage Accept Risk Rules](https://docs.tenable.com/security-center/Content/manage-accept-risk-rules.htm) |
| Tenable Security Center | Recast Risk | Writes a new severity onto matching findings. Expiry is a date you select. | [Manage Recast Risk Rules](https://docs.tenable.com/security-center/Content/manage-recast-risk-rules.htm) |
| Tenable Vulnerability Management | Accept, or Recast | Accept hides the finding. VPR, AES, and CES stay as scored. Recast changes the visible severity. A rule can omit the expiry. | [Recast](https://docs.tenable.com/vulnerability-management/Content/recast/recast-intro.htm) |
| Tenable Nessus | Plugin rule | Hides a plugin in the results, or changes its severity. An expiration date is one of the fields. | [Plugin Rules](https://docs.tenable.com/nessus/Content/PluginRules.htm) |
| Qualys VMDR | Ignore | Takes the finding off the actionable-issue list. | [Want to ignore a vulnerability?](https://docs.qualys.com/en/vmdr/latest/knowledgebase/win_ignore_vulnerability.htm) |
| Microsoft Defender Vulnerability Management | Third party control, or Alternate mitigation | Takes the finding out of remediation work. Those two reasons can lower the exposure score on a recommendation exception. You set the duration when you create the exception. A longer window is a new exception. | [Exception reasons](https://learn.microsoft.com/en-us/defender-vulnerability-management/tvm-exception-overview) and [Create an exception](https://learn.microsoft.com/en-us/defender-vulnerability-management/tvm-exception) |
| Greenbone | Override | Changes the shown severity when the report filter Apply Overrides is on. Active is on, off, or a number of days. | [Using Overrides and False Positives](https://docs.greenbone.net/GSM-Manual/gos-25.0/en/reports.html#using-overrides-and-false-positives) |

Wiz and Orca, which [How Root Lock Compares](../../introduction/how-it-compares/) names alongside these scanners, publish no public exception article, so they are not in the table.

## Image and dependency scanners

An ignore in these tools changes that tool's report, the same way an exception does in a host scanner.

| Scanner | What you record | Documentation |
|---|---|---|
| Snyk | Not vulnerable, Ignore temporarily, or Until fix is available. A security policy can mark won't fix or not vulnerable. | [Ignore issues](https://docs.snyk.io/scan-fix-and-prevent/fix/prioritize-issues-for-fixing/ignore-issues) and [Security policy actions](https://docs.snyk.io/scan-fix-and-prevent/prevent/policies/security-policies/security-policy-actions) |
| Trivy | An ignore file. The statement is free text. | [Filtering](https://trivy.dev/docs/latest/configuration/filtering/) |
| Grype | An ignore rule, or a VEX status on that finding. | [Filter scan results](https://oss.anchore.com/docs/guides/vulnerability/filter-results/) |

## Backports, tailoring, and intrusion prevention

These cover a backported fix, OpenSCAP tailoring, or intrusion prevention alongside the scanner rule.

| Source | What it is | Documentation |
|---|---|---|
| Red Hat | OVAL definitions so a scanner can treat a backported fix as already patched. | [Backporting Security Fixes](https://access.redhat.com/security/updates/backporting) and [Red Hat and OVAL compatibility](https://access.redhat.com/articles/221883) |
| OpenSCAP | Tailoring removes a rule from a profile before the scan. | [OpenSCAP User Manual, Tailoring](https://static.open-scap.org/openscap-1.4.1/oscap_user_manual.html) |
| Trend Micro Deep Security | Intrusion Prevention can block exploit traffic until the vendor patch is released, tested, and deployed. | [About Intrusion Prevention](https://help.deepsecurity.trendmicro.com/aws/intrusion-prevention.html) |
