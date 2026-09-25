---
title: "What has to be true before a scanner row can wait?"
linkTitle: "When a scanner row can wait"
date: 2026-09-25
slug: when-a-scanner-row-can-wait
draft: false
description: "A scanner row can leave the active queue when Lockdown already stops the next step, and only if your policy already allows an expiring exception. The patch date stays. No share of the queue is measured."
author: "Ron Hessing"
tags: ["root-lock", "lockdown", "patching", "scanners"]
toc: true
---

The scanner puts a short clock on a high score. Read the next step on that host.

When the next step is a program with no allowlist entry, a file that program was not granted, or a destination that program was not granted, you file that step in the scanner you already run. You set the expiry to the window your own policy already names for work it does not rank critical. The morning the rule expires, the finding is eligible to be urgent again.

Root Lock by HeartSuite does not file that rule, and it does not close the ticket. The date in your policy or your contract stays the patch date. You still patch.

Three things have to already be true before a boss can treat that filing as a reason to buy.

## The contract already allows an exception

A named approver on your side accepts a written exception, and the exception expires. Root Lock is not a party to that contract and does not file the rule.

Where the scorecard is criticals closed in seven days, and the rule has no exception clause, the filing gives the analyst a comment to write and the boss no cover. A written seven-day install rule stays seven days.

PCI DSS critical patches, under your own ranking, are due within one month of release. A compensating control filed after that month does not repair the miss. The [Council's FAQ](https://www.pcisecuritystandards.org/faq/articles/Frequently_Asked_Question/Can-a-compensating-control-be-used-for-requirements-with-a-periodic-or-defined-frequency-where-an-entity-did-not-perform-the-activity-within-the-required-timeframe/) uses a critical patch that missed its window as the example. A named approver and an expiry are not lines on the report template. They sit on the exception ticket your policy already requires.

For work your policy does not rank critical, 60 days and 90 days are that policy's window when the policy already names them. They are not a Root Lock schedule.

## The row is that class on this host

The same CVE can wait on one machine and stay this week's work on the next. The difference is what that program was already granted.

Under Lockdown, the step that can leave the active queue is one of these:

- a program with no allowlist entry
- a file that program was not granted
- a destination that program was not granted

These stay on the patch date:

- a bug that finishes on data the program already reads, on a file it was granted, or on a destination already permitted
- injection inside an allowlisted process
- denial of service
- a kernel CVE whose code is in the kernel that boots
- a finding your policy ranks critical, including one known to be exploited
- the vulnerable application's own files

In the 6.18 kernel, io_uring, FUSE, user namespaces, OverlayFS, nftables, and KVM are present, so CVEs in that code stay on the patch date. They drop off only when that code is absent from the kernel you boot. The BPF syscall is off. Record that row as not affected. Do not use the not-affected reason for a real CVE whose next step Lockdown stops.

A program that already has an allowlist entry can be started. The test is a program with no entry.

No count says what share of a real queue is the class that can wait. Known-exploited findings, and code that is in the kernel you boot, stay on the patch date even when the next step has no allowlist entry.

The allowlist names the file's location. It does not hash the file. Leave Lockdown from a physical or serial console and pick **Maintenance: unseal and return to Root Lock** at the boot menu. That boot lifts the seal. Relock is the reboot back to Lockdown.

## Someone can show the control was operating

The exception needs evidence from the dates on the rule. That history is not one file Root Lock ships.

The status file at `~/.cache/heartsuite/status.json` is rewritten about every minute. Ansible, Nagios, and Zabbix can read the current state there. The file does not keep the window. The approval log at `/var/log/heartsuite/allowlist-audit.log` records allowlist approvals, with the user id and the terminal. It does not record refusals. It is not the exhibit.

The line you attach is a syslog record with identifier `heartsuite`. Denial lines are there when Fleet Syslog is on, under Alert Settings on the Fleet tab. With that switch off, there is no heartsuite line to attach. Save the search for the dates on the rule and keep it with the rule. The filing steps are on [Scanner deadlines](https://docs.heartsecsuite.com/rootlock/maintenance/scanner-deadlines/). The syslog setup is on [SIEM and Fleet Integration](https://docs.heartsecsuite.com/rootlock/alerts/siem-integration/).

## The write grants are still wide

Harvests of Debian and Ubuntu guests already show hundreds of write grants and dozens of write directories on a host. A converged host has not been counted. If that width holds after the list is narrowed, "only the files that program was granted" is a weak reason to leave a finding for later, and fewer rows are the class that can wait.

That count comes before any classifier and before any scanner client. Root Lock does not classify the CVE. You type the reason into the scanner you already run.

## What you can defend in the meeting

Bring a short list from your own queue. Name the rows, the next step, and the window your policy already has. File them in Tenable or Qualys with an expiry. The finding returns the morning the rule expires.

Tenable Accept hides the row from the active views until that date and does not change VPR. A Qualys risk acceptance takes the row off remediation after a scan, and the expiry puts it back. A comment by itself does not pause the ticket clock. The person who clicks is often not the approver.

A boss turns that list into money only by counting their own off-hours emergencies of that shape. One planning case put the optimistic result at about $715,000 a year, net, at 1,000 hosts, and only if half of those emergencies could wait, handled on each machine at the console. That half was assumed. It was not counted. A shop that rebakes one image and redeploys does not have that console cost. Until you have the count from your own queue, the figure stays a scenario. It is not a saving, and it is not a price.
