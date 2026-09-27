---
title: "What has to be true before a scanner row can wait?"
linkTitle: "When a scanner row can wait"
date: 2026-09-25
slug: when-a-scanner-row-can-wait
draft: false
description: "Under Lockdown, a critical scanner row can wait for the standard change window when the exploit's next step is one Root Lock refuses, and only when your policy already allows an expiring exception. The patch date stays."
author: "Ron Hessing"
tags: ["root-lock", "lockdown", "patching", "scanners"]
toc: true
---

Take a path-traversal bug in a web server, the kind of flaw behind Apache's CVE-2021-41773. A crafted request makes the server open a file outside its web root and send it back. The scanner scores it critical and starts a short clock on two hosts.

On the first host, the attacker wants `/etc/passwd` and the server's private keys. Under Lockdown, the web server's allowlist entry names the files it may read, and neither is on it, so the kernel refuses the open. The traversal works as a URL trick and fails as a file operation. On the second host, the attacker wants the application's database credentials, and the web server already reads that file every time it starts. Nothing refuses that read.

Same CVE, same score. On the first host the row can wait for the standard change window. On the second it is this week's work. The difference is what that program was already granted — and three more things have to be true before the wait is defensible.

## The contract already allows an exception

The wait is an exception your own policy grants. A named approver on your side accepts it in writing, and it expires. You file it as a rule in the scanner you already run, with the expiry set to the window your policy already names for work it does not rank critical — often 60 or 90 days. The morning the rule expires, the finding is urgent again. The patch date in your policy or contract stays where it was; the exception changes the scanner's queue, and you still patch.

That only works where the policy has an exception clause. If the scorecard is criticals closed in seven days with no exception path, a written seven-day install rule stays seven days, and the filing gives the analyst a comment to write and nothing more.

Timing matters too. PCI DSS critical patches, under your own ranking, are due within one month of release, and a compensating control filed after that month does not repair the miss. The [Council's FAQ](https://www.pcisecuritystandards.org/faq/articles/Frequently_Asked_Question/Can-a-compensating-control-be-used-for-requirements-with-a-periodic-or-defined-frequency-where-an-entity-did-not-perform-the-activity-within-the-required-timeframe/) uses exactly that case — a critical patch that missed its window — as its example. File the exception inside the window, on the exception ticket your policy already requires, with the approver and the expiry on it.

## The row is that class on this host

A row can wait when the attacker's next step after the exploit is one Lockdown refuses:

- running a program with no allowlist entry — the allowlist matches the path, so a copy of an allowed binary at a new path has no entry
- opening a file that program was not granted
- connecting to a destination that program was not granted

The rest stay on the patch date, because the attack completes inside what the program is already allowed to do:

- a bug that finishes on data the program already reads, on a file it was granted, or at a destination already permitted — the second host above
- a next step that starts a program that already has an allowlist entry
- injection inside an allowlisted process
- denial of service
- the vulnerable application's own files
- a kernel CVE whose code is in the kernel that boots

Two rules override the class. A finding your policy ranks critical stays on the patch date, and so does a finding on the [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities) list — even when the next step has no allowlist entry. CVE-2021-41773 itself is on that list, so on a real queue it stays on the patch date on both hosts. The example above shows the test; the list decides first.

Kernel rows follow the code, not the version string. In the 6.18 kernel, io_uring, FUSE, user namespaces, OverlayFS, nftables, and KVM are present, so their CVEs stay on the patch date. The BPF syscall is off, so a BPF syscall CVE is a row you record as not affected. Keep that reason for code that is absent. A real CVE whose next step Lockdown refuses is a compensating control with an expiry, because the vulnerable code is still there.

## Someone can show the control was operating

The exception needs evidence from the dates on the rule, and the record that carries it is syslog. With Fleet Syslog on — Alert Settings, Fleet tab — Lockdown denials arrive as lines with identifier `heartsuite`. Save a search for the dates on the rule and keep it with the rule. Turn the switch on before the window opens; a window with the switch off has no `heartsuite` lines to attach.

The two local files answer different questions. The status file at `~/.cache/heartsuite/status.json` is rewritten about every minute, so Ansible, Nagios, and Zabbix can read the current state, and a monitor that polls it keeps the history of `lockdown` across the window. The approval log at `/var/log/heartsuite/allowlist-audit.log` records who approved each allowlist entry, with the user id and the terminal — the attribution for changes, where syslog is the record of refusals.

The deferral also holds only while the host stays in Lockdown. Leaving Lockdown takes a physical or serial console and the boot menu pick **Maintenance: unseal and return to Root Lock**, which returns the host to Setup Mode, where the kernel logs and stops blocking. Relock is the reboot back to Lockdown. Plan maintenance on these hosts with the open rows in mind.

The filing steps for each scanner are on [Scanner deadlines](https://docs.heartsecsuite.com/rootlock/maintenance/scanner-deadlines/). The syslog setup is on [SIEM and Fleet Integration](https://docs.heartsecsuite.com/rootlock/alerts/siem-integration/).

## How far the argument reaches

The case is only as strong as the grants. A program with wide write grants makes "a file that program was not granted" a weaker reason, and fewer of its rows are the class that can wait. Narrow the list after Setup Mode, and the reason gets stronger on every row that program owns.

The judgment stays yours. Root Lock does not classify the CVE or file the rule, you read the next step, and you type the reason into the scanner you already run. What Root Lock contributes is the refusal itself: under Lockdown, the attacker's next unapproved program, file, or destination is refused on every one of those hosts until the patch lands.

## What you can defend in the meeting

Bring a short list from your own queue:

- the rows, and for each one the next step Lockdown refuses
- the window your policy already names for that work
- the approver who signs the exception
- the saved `heartsuite` syslog search for those dates

File them in Tenable or Qualys with an expiry. Tenable Accept hides the row from the active views until that date and leaves VPR as scored. A Qualys risk acceptance takes the row off remediation after a scan, and the expiry puts it back. Either way the finding returns the morning the rule expires, and a comment on its own does not pause the ticket clock — the exception does. The person who clicks is often not the approver, so put the approver's name on the rule.

Whether this saves money depends on your own count: how many off-hours emergencies in your queue were this class. Count them before you price the argument.
