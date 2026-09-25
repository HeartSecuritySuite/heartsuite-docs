---
title: "File the scanner exception on its own date"
linkTitle: "Scanner deadlines"
weight: 7
description: "Which findings can leave the active queue for the standard change window, and how to file that exception in the scanner you already run."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "scanner"]
type: docs
aliases:
  - /docs/maintenance/scanner-deadlines/
toc: true
---

**Overview**: A critical row is this week's work when the bug can finish with what the program already has. When the next step is a program with no allowlist entry, a file the program was not granted, or a destination the program was not granted, that row can leave the active queue for the standard change window. You file one rule in the scanner you already run. The expiry on that rule changes the tool's score, its report, and its remediation queue. The date your policy or contract names for the patch does not move.

## What leaves the active queue

Use the reason in the table below, not a false-positive reason, when the next step is something Lockdown already stops:

- The next step is a program with no allowlist entry
- The next step is a file the program was not granted
- The next step is a destination the program was not granted

In the comment, name that step: a dropped binary, a new destination, or a process that already has root and obeys the allowlist. Where your policy sets the standard change window at 60 days or 90 days for work it does not rank critical, set the expiry to that window. A known-exploited finding stays on the patch date. So does anything the policy ranks critical. The list is [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities).

A kernel CVE is a false positive on this host only when that code is absent from the kernel you boot. Use that scanner's false-positive or not-affected reason, and record the gate on the rule. The Root Lock kernel stays as shipped, and `apt` and `dnf` install the OS packages. The BPF syscall is off. io_uring, FUSE, user namespaces, OverlayFS, nftables, and KVM are in the 6.18 kernel, so those CVEs stay on the patch date. The catalog is [Kernel Security Transparency](../../security/).

## When your policy allows an exception

File the rule on the asset group, tag, or range those hosts already belong to. Put the reason and the comment on the rule, and set the expiry there. If the screen asks for an approver or a review date, record those on the same rule. A written seven-day install rule stays seven days — the exception is the scanner rule that allows a longer wait.

If those hosts already ship syslog, save a search on identifier `heartsuite` for the dates on the rule and keep it with the rule — the search shows denials and alerts. A monitor that already polls `status.json` covers the same dates in its history for `lockdown` and `daemon_ok`. On one host, when the shipper is down, `journalctl -t heartsuite --since` and `--until` cover those dates. See [SIEM Integration](../../alerts/siem-integration/).

## Record the reason in that scanner

Each link is that tool's own article, and the menu labels come from the article — they can move. A 30-day or 90-day field in the article is the exception expiry. The patch date in your policy or contract stays the remediation SLA.

| Scanner | Reason | What changes | Documentation |
|---|---|---|---|
| Rapid7 InsightVM | Compensating Control | Drops the finding from that tool's risk score and from its reports. Expiry is an optional date. | [Working with vulnerability exceptions](https://docs.rapid7.com/insightvm/working-with-vulnerability-exceptions) |
| Tenable Security Center | Accept Risk | Hides the finding from a search that excludes Accepted Risk. Comment is free text. Expiry is a date you select. | [Manage Accept Risk Rules](https://docs.tenable.com/security-center/Content/manage-accept-risk-rules.htm) |
| Tenable Security Center | Recast Risk | Writes a new severity onto matching findings. Expiry is a date you select. | [Manage Recast Risk Rules](https://docs.tenable.com/security-center/Content/manage-recast-risk-rules.htm) |
| Tenable Vulnerability Management | Accept, or Recast | Accept hides the finding. VPR, AES, and CES stay as scored. Recast changes the visible severity. A rule can omit the expiry. | [Recast](https://docs.tenable.com/vulnerability-management/Content/recast/recast-intro.htm) |
| Tenable Nessus | Plugin rule | Hides a plugin in that scanner's results, or changes its severity. An expiration date is one of the fields. | [Plugin Rules](https://docs.tenable.com/nessus/Content/PluginRules.htm) |
| Qualys VMDR | Ignore | Ignore takes the finding off the actionable-issue list in that tool. | [Want to ignore a vulnerability?](https://docs.qualys.com/en/vmdr/latest/knowledgebase/win_ignore_vulnerability.htm) |
| Microsoft Defender Vulnerability Management | Third party control, or Alternate mitigation | The exception takes the finding out of remediation work in that tool. Those two reasons can lower the exposure score on a recommendation exception. You set the duration when you create the exception. A longer window is a new exception. | [Exception reasons](https://learn.microsoft.com/en-us/defender-vulnerability-management/tvm-exception-overview) and [Create an exception](https://learn.microsoft.com/en-us/defender-vulnerability-management/tvm-exception) |
| Greenbone | Override | Changes the shown severity when the report filter Apply Overrides is on. Active is on, off, or a number of days. | [Using Overrides and False Positives](https://docs.greenbone.net/GSM-Manual/gos-25.0/en/reports.html#using-overrides-and-false-positives) |

## Image and dependency scanners

An ignore in these tools changes that tool's report. Package installs follow the date in your policy or contract.

| Scanner | What you record | Documentation |
|---|---|---|
| Snyk | Not vulnerable, Ignore temporarily, or Until fix is available. A security policy can mark won't fix or not vulnerable. | [Ignore issues](https://docs.snyk.io/scan-fix-and-prevent/fix/prioritize-issues-for-fixing/ignore-issues) and [Security policy actions](https://docs.snyk.io/scan-fix-and-prevent/prevent/policies/security-policies/security-policy-actions) |
| Trivy | An ignore file. The statement is free text. | [Filtering](https://trivy.dev/docs/latest/configuration/filtering/) |
| Grype | An ignore rule, or a VEX status on that finding. | [Filter scan results](https://oss.anchore.com/docs/guides/vulnerability/filter-results/) |

[How Root Lock Compares](../../introduction/how-it-compares/) names Wiz and Orca with the host scanners above. Neither publishes a public exception article.

## Backports, tailoring, and intrusion prevention

These documents cover a backported fix, OpenSCAP tailoring, or intrusion prevention beside the scanner rule.

| Source | What it is | Documentation |
|---|---|---|
| Red Hat | OVAL definitions so a scanner can treat a backported fix as already patched. | [Backporting Security Fixes](https://access.redhat.com/security/updates/backporting) and [Red Hat and OVAL compatibility](https://access.redhat.com/articles/221883) |
| OpenSCAP | Tailoring removes a rule from a profile before the scan. | [OpenSCAP User Manual, Tailoring](https://static.open-scap.org/openscap-1.4.1/oscap_user_manual.html) |
| Trend Micro Deep Security | Intrusion Prevention can block exploit traffic until the vendor patch is released, tested, and deployed. The vendor patch lands on the remediation SLA. | [About Intrusion Prevention](https://help.deepsecurity.trendmicro.com/aws/intrusion-prevention.html) |

## Findings that stay on the patch date

These keep the patch date in your policy or contract. Lockdown does not clear them, and an exception for one of them is a rule you file from your own policy:

- In-process bugs, on data the program already reads
- Kernel CVEs whose code is in the kernel you boot
- Injection inside an allowlisted process
- Denial of service
- An already-permitted destination
- The vulnerable app's own files
- A known-exploited finding

The kernel matches the path, so two copies with the same bytes at different paths are different entries. In Setup Mode the kernel logs but stops blocking until you return to Lockdown. See [Protecting During Maintenance](../protecting-during-maintenance/).

Kernel version-string false positives follow [CVE Hygiene for Scanners](../../kernel-hardening/cve-hygiene-for-scanners/).
