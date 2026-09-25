---
title: "The remediation SLA and the exception expiry are different dates"
linkTitle: "Scanner deadlines"
weight: 7
description: "Your remediation SLA is the patch date in your policy or contract. The exception expiry is a different date, on the rule you file in the scanner."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "scanner"]
type: docs
aliases:
  - /docs/maintenance/scanner-deadlines/
toc: true
---

**Overview**: Your remediation SLA is the patch date in your policy or contract. The exception expiry is a different date, on the rule you file in the scanner. That rule changes the tool's score, its report, and its remediation queue until it expires. Under Lockdown, Root Lock by HeartSuite confines an allowlisted program to its allowlist. A bug in that program reads the files on its allowlist.

## When your policy allows an exception

You file one rule in the scanner you already run, on the asset group, tag, or range. The reason, the comment, and the expiry are on that rule. Where the tool asks, record the approver and the review date there too. A written seven-day install rule stays seven days. An exception exists when that rule allows one.

Turn on Fleet syslog before the dates on the rule, so identifier `heartsuite` is already in the SIEM. On the Fleet tab in Alert Settings, the switch is **Send alerts to /dev/log (LOG_AUTH facility)**. Keep journald on persistent storage (`Storage=persistent`). See [SIEM Integration](../../alerts/siem-integration/).

1. In that SIEM, save a search on identifier `heartsuite` for the exception's dates. Keep the export with the rule.
2. The search returns denials and alerts. Allowlisted work is absent from the count.
3. Where a monitor already polls `status.json`, use that monitor's history for `lockdown` and `daemon_ok` across the same dates. Root Lock rewrites `~/.cache/heartsuite/status.json` every 60 seconds (root daemon: `/root/.cache/heartsuite/status.json`).
4. On one host, when the shipper is down, `journalctl -t heartsuite --since` and `--until` cover the exception dates.

## Record the reason in that scanner

Each link is that tool's own article. Menu labels come from that tool. They can move. A 30-day or 90-day field in the article is the exception expiry. The remediation SLA stays the date in the policy or contract.

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

An ignore in these tools changes that tool's report. The remediation SLA stays the date in the policy or contract.

| Scanner | What you record | Documentation |
|---|---|---|
| Snyk | Not vulnerable, Ignore temporarily, or Until fix is available. A security policy can mark won't fix or not vulnerable. | [Ignore issues](https://docs.snyk.io/scan-fix-and-prevent/fix/prioritize-issues-for-fixing/ignore-issues) and [Security policy actions](https://docs.snyk.io/scan-fix-and-prevent/prevent/policies/security-policies/security-policy-actions) |
| Trivy | An ignore file. The statement is free text. | [Filtering](https://trivy.dev/docs/latest/configuration/filtering/) |
| Grype | An ignore rule, or a VEX status on that finding. | [Filter scan results](https://oss.anchore.com/docs/guides/vulnerability/filter-results/) |

[How Root Lock Compares](../../introduction/how-it-compares/) names Wiz and Orca with the host scanners above. Neither publishes a public exception article.

## Backports, tailoring, and intrusion prevention

You file the exception in the scanner. These documents cover a backported fix, OpenSCAP tailoring, or intrusion prevention.

| Source | What it is | Documentation |
|---|---|---|
| Red Hat | OVAL definitions so a scanner can treat a backported fix as already patched. | [Backporting Security Fixes](https://access.redhat.com/security/updates/backporting) and [Red Hat and OVAL compatibility](https://access.redhat.com/articles/221883) |
| OpenSCAP | Tailoring removes a rule from a profile before the scan. | [OpenSCAP User Manual, Tailoring](https://static.open-scap.org/openscap-1.4.1/oscap_user_manual.html) |
| Trend Micro Deep Security | Intrusion Prevention can block exploit traffic until the vendor patch is released, tested, and deployed. The vendor patch lands on the remediation SLA. | [About Intrusion Prevention](https://help.deepsecurity.trendmicro.com/aws/intrusion-prevention.html) |

## Findings that stay on the remediation SLA

These stay on the remediation SLA. Lockdown leaves each one there. You file an exception for one of these from your own policy:

- In-process bugs, on data the program already reads
- Kernel CVEs
- Injection inside an allowlisted process
- Denial of service
- An already-permitted destination
- The vulnerable app's own files

In the scanner comment, describe a dropped binary, a new destination, or a process that already has root and obeys the allowlist.

Matching uses the path. Two copies with the same bytes at different paths are different entries. In Setup Mode the kernel logs but stops blocking until you return to Lockdown. See [Protecting During Maintenance](../protecting-during-maintenance/).

Kernel version-string false positives follow [CVE Hygiene for Scanners](../../kernel-hardening/cve-hygiene-for-scanners/).
