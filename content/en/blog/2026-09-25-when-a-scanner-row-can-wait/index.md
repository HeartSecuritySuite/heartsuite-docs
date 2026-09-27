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

## Why the queue never empties

Most teams cannot close findings as fast as scanners open them. Across vendor telemetry, the typical organization closes about one in ten open findings a month and top performers about one in four (Cyentia Institute with Kenna Security, 2023). In PDQ's State of Sysadmin 2026 survey of 1,034 administrators, 51% say timely patching takes too much time and 52% say they are constantly playing catch-up. Hackuity's 2025 survey of 200 security leaders found 46% say CVE volume is straining the team and 38% report burnout.

The critical label does not sort that pile. A CVSS base score is the worst case for the bug, and FIRST, which maintains CVSS, says the base score measures severity, not risk. About 6% of published CVEs have ever been seen exploited ([Jacobs et al., 2023](https://arxiv.org/abs/2302.14172)), and CISA's Known Exploited Vulnerabilities list holds roughly 0.5% of them ([FIRST EPSS FAQ](https://www.first.org/epss/faq)). Those are rates across every published CVE, not a verdict on the row in front of you — that row still needs a reason on this host, and the rest of this post is how you write it.

## The contract already allows an exception

The wait is an exception your own policy grants. A named approver on your side accepts it in writing, and it expires. You file it as a rule in the scanner you already run, with the expiry set to the window your policy already names for work it does not rank critical — often 60 or 90 days. The morning the rule expires, the finding is urgent again. The patch date in your policy or contract stays where it was; the exception changes the scanner's queue, and you still patch. The breaches people cite are patches that existed and were not installed. Equifax and CVE-2017-5638, WannaCry and MS17-010 which is why the exception carries an expiry instead of replacing the patch.

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

Two rules override the class. A finding your policy ranks critical stays on the patch date, and so does a finding on the [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities) list — even when the next step has no allowlist entry. CVE-2021-41773 itself is on that list, so on a real queue it stays on the patch date on both hosts. The example above shows the test; the list decides first. The list also moves fast: for recent bugs, Barracuda's July 2026 review of KEV additions since 2023 found a median of 6 to 14 days from publication to listing, so a quarterly window misses that tail by design. FedRAMP's 2026 [vulnerability rules](https://fedramp.gov/2026/reference/vulnerability-detection-and-response/) say the same from the other side: a fully mitigated vulnerability still exists until it is remediated, and its KEV due date stands.

The kernel's own CVE team says many kernel CVEs are not relevant to a given system, because each system uses a small part of the tree ([kernel CVE documentation](https://docs.kernel.org/process/cve.html)). Kernel rows follow the code, not the version string. The BPF syscall is off, so a BPF syscall CVE is a row you record as not affected. Keep that reason for code that is absent. A real CVE whose next step Lockdown refuses is a compensating control with an expiry, because the vulnerable code is still there.

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

## What the off-hours version costs

No published study prices an emergency patch cycle, so the figures below are built from hours, and each input is an estimate you replace with your own. An off-hours emergency costs about six hours before any host is touched — triage, emergency change approval, a rushed staging test, and the notice to the business — then about an hour per host to install, reboot, and check, at an overtime rate, plus four hours for each host where the rushed change fails. The same patch folded into a window you already scheduled costs about 0.4 hours per host and none of the fixed six.

At $75 an hour, two shops show the range. The first column is the yearly cost of rushing rows whose next step Lockdown would have refused. The net subtracts the time Root Lock itself adds: the console unseal Lockdown requires before scheduled maintenance on hosts you update in place.

| Estate | Busy shop: 18 emergencies a year, half of them this class, 80% of hosts on each | Disciplined shop: 6 emergencies a year, a quarter this class, already patches monthly |
|---|---|---|
| 100 hosts | about $89,000 rushed; about **+$77,000** net | about $7,000 rushed; about **−$8,000** net |
| 1,000 hosts | about $838,000 rushed; about **+$715,000** net | about $60,000 rushed; about **−$88,000** net |

In the busy shop at 1,000 hosts, more than $700,000 a year goes to off-hours work on rows that could have waited for the window. In the disciplined shop, the scheduled window already absorbs most of that work, and Root Lock's maintenance costs more than the deferral saves — there the case for Root Lock is the refusal, not the budget. Hosts rebuilt from an image never need the unseal, so on an image-based fleet the added cost is one more stage in the image build.

The deciding inputs are your own. Four questions replace the estimates:

- In the last 12 months, how many times was someone paged off-hours to patch a Linux CVE before the next window, and how many hosts did each page touch?
- How many of those were this class — the next step a program, file, or destination Lockdown refuses — and not on the KEV list?
- Is your scheduled patching automated end to end, or does someone install and check each host by hand?
- What is the fully loaded hourly cost of the person paged, and is off-hours work paid as overtime or absorbed into salary? If it is absorbed, drop the overtime rate and the case shrinks.

If the answer to the first question is "never", this is not a budget argument for you, and the reason to run Root Lock on those hosts is the refusal itself.
