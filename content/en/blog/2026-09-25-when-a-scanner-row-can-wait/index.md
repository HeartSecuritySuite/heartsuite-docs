---
title: "Which critical CVEs can wait for the patch window?"
linkTitle: "When a scanner row can wait"
date: 2026-09-25
slug: when-a-scanner-row-can-wait
draft: false
description: "Not every scanner critical needs an off-hours patch. How to tell which CVEs can wait for your change window with a compensating control, and which can't."
author: "Ron Hessing"
tags: ["root-lock", "lockdown", "patching", "scanners", "vulnerability-management", "cve", "compensating-control"]
toc: true
---

It is 11 p.m. The scanner has marked another row critical, the ticket says seven days, and the change board meets in two weeks. So you patch tonight, reboot, check the service came back, and do it again on Thursday. You are not the only one who finds this absurd. A sysadmin on r/sysadmin in May 2025 described a two-week deadline for highs and criticals "regardless if it actually affects us," against a two-week change lead time, "so never meet the sla." A developer on r/github in March 2026 went through 89 "critical" alerts and judged 83 of them impossible in their setup, and the reply underneath said it best: "everything screams critical so nothing feels critical anymore." [CSO Online reported in May 2026](https://www.csoonline.com/article/4169623/why-patching-slas-should-be-the-floor-not-the-strategy.html) that teams "keep closing easy criticals to keep the dashboard green."

The numbers say the same. Across vendor telemetry, a typical organization has the capacity to close about one in ten open findings a month ([Cyentia Institute with Kenna Security, 2023](https://www.cyentia.com/the-hidden-complexity-of-vulnerability-remediation/)). In [PDQ's State of Sysadmin 2026](https://www.pdq.com/blog/state-of-system-administration-2026/) survey of 1,034 administrators, 51% name timely patching among the tasks that take too much time, and 52% say they are constantly playing catch-up with technology changes. [Hackuity's 2025 survey](https://www.hackuity.io/blog/nearly-half-of-security-teams-struggling-to-cope-with-growing-volume-of-vulnerabilities) of 200 security leaders found 46% say CVE volume is straining the team and 38% report burnout.

{{< stat-row >}}
{{< stat number="1 in 10" tone="info" label="A typical organization has the capacity to close about one in ten open findings a month." source="Cyentia Institute with Kenna Security, 2023" url="https://www.cyentia.com/the-hidden-complexity-of-vulnerability-remediation/" >}}
{{< stat number="51%" tone="teal" label="of sysadmins name timely patching among the tasks that take too much time." source="PDQ State of Sysadmin 2026, n=1,034" url="https://www.pdq.com/blog/state-of-system-administration-2026/" >}}
{{< stat number="38%" tone="warning" label="of security leaders say CVE volume has led to burnout on the team." source="Hackuity, 2025, n=200" url="https://www.hackuity.io/blog/nearly-half-of-security-teams-struggling-to-cope-with-growing-volume-of-vulnerabilities" >}}
{{< /stat-row >}}

Here is what changes under Lockdown. For many of those rows, the attacker's next step after the exploit is running a program, opening a file, or reaching an address this host does not allow, and the Root Lock kernel refuses that step. That row does not need tonight. It moves to your next change window with a signed exception, an expiry, and syslog proof that the refusal was working the whole time. The rows that are truly urgent — known-exploited, or finishing inside what the program is already allowed to do — you still patch on their date. There are fewer of them, and you know which ones they are.

{{% alert title="The short version" color="success" %}}
- **Moves to the change window:** a critical row whose next step after the exploit — a new program, a file, or a destination — is one Lockdown refuses on that host.
- **Still patched on its date:** known-exploited (KEV) rows, anything your policy ranks critical, and bugs that finish inside what the program is already allowed to do.
- **What you keep:** a signed exception with an expiry, syslog proof the refusal was working, and fewer nights on the pager.
{{% /alert %}}

## Why a CVSS critical isn't always urgent

A CVSS base score is the worst case for the bug, and FIRST, which maintains CVSS, says the base score measures severity, not risk. About 6% of published CVEs have ever been seen exploited ([Jacobs et al., 2023](https://arxiv.org/abs/2302.14172)), and CISA's Known Exploited Vulnerabilities list holds roughly 0.5% of them ([FIRST EPSS FAQ](https://www.first.org/epss/faq)). The kernel's own CVE team says many kernel CVEs are not relevant to a given system, because each system uses a small part of the tree ([kernel CVE documentation](https://docs.kernel.org/process/cve.html)).

{{< stat-row >}}
{{< stat number="~6%" tone="info" label="of published CVEs have ever been seen exploited." source="Jacobs et al., 2023" url="https://arxiv.org/abs/2302.14172" >}}
{{< stat number="~0.5%" tone="teal" label="of published CVEs are on CISA's Known Exploited Vulnerabilities list." source="FIRST EPSS FAQ" url="https://www.first.org/epss/faq" >}}
{{< stat number="14 days" tone="warning" label="typical gap in 2026 from a new bug's publication to its KEV listing — why KEV rows keep their date." source="Barracuda, July 2026" url="https://blog.barracuda.com/2026/07/24/KEV-gap-how-fast-do-exploited-bugs-get-flagged" >}}
{{< /stat-row >}}

Those are rates across every published CVE, not a verdict on the row in front of you. The critical label says how bad a bug could be somewhere. It does not say what an attacker can do next on this host — and that is the question Lockdown answers.

## Which critical CVEs can wait for the change window

Take a path-traversal bug in a web server, the kind of flaw behind Apache's CVE-2021-41773. A crafted request makes the server open a file outside its web root and send it back. The scanner scores it critical and starts a short clock on two hosts.

On the first host, the attacker wants `/etc/passwd` and the server's private keys. Under Lockdown, the web server's allowlist entry names the files it may read, and neither is on it, so the kernel refuses the open. The traversal works as a URL trick and fails as a file operation. On the second host, the attacker wants the application's database credentials, and the web server already reads that file every time it starts. Nothing refuses that read.

Same CVE, same score. On the first host the row can wait for the standard change window. On the second it is this week's work. The difference is what that program was already granted.

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

Two rules override the class. A finding your policy ranks critical stays on the patch date, and so does a finding on the [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities) list — even when the next step has no allowlist entry. CVE-2021-41773 itself is on that list, so on a real queue it stays on the patch date on both hosts. The example above shows the test; the list decides first. The list also moves fast: for recent bugs, [Barracuda's July 2026 review](https://blog.barracuda.com/2026/07/24/KEV-gap-how-fast-do-exploited-bugs-get-flagged) of KEV additions since 2023 found the typical gap from publication to listing grew from 6 days in 2023 to 14 in 2026, so a quarterly window misses that tail by design. FedRAMP's 2026 [vulnerability rules](https://fedramp.gov/2026/reference/vulnerability-detection-and-response/) say the same from the other side: a fully mitigated vulnerability still exists until it is remediated, and its KEV due date stands.

Kernel rows follow the code, not the version string. The BPF syscall is off, so a BPF syscall CVE is a row you record as not affected. Keep that reason for code that is absent. A real CVE whose next step Lockdown refuses is a compensating control with an expiry, because the vulnerable code is still there.

## Filing a compensating control exception

The wait is an exception your own policy grants. A named approver on your side accepts it in writing, and it expires. You file it as a rule in the scanner you already run, with the expiry set to the window your policy already names for work it does not rank critical — often 60 or 90 days. The morning the rule expires, the finding is urgent again. The patch date in your policy or contract stays where it was; the exception changes the scanner's queue, and you still patch — in daylight, in the window, with the rest of the batch. The breaches people cite are patches that existed and were not installed — Equifax and CVE-2017-5638, WannaCry and MS17-010 — which is why the exception carries an expiry instead of replacing the patch.

That only works where the policy has an exception clause. If the scorecard is criticals closed in seven days with no exception path, a written seven-day install rule stays seven days, and the filing gives the analyst a comment to write and nothing more.

Timing matters too. PCI DSS critical patches, under your own ranking, are due within one month of release, and a compensating control filed after that month does not repair the miss. The [Council's FAQ](https://www.pcisecuritystandards.org/faq/articles/Frequently_Asked_Question/Can-a-compensating-control-be-used-for-requirements-with-a-periodic-or-defined-frequency-where-an-entity-did-not-perform-the-activity-within-the-required-timeframe/) uses exactly that case — a critical patch that missed its window — as its example. File the exception inside the window, on the exception ticket your policy already requires, with the approver and the expiry on it.

## Evidence for the auditor

The exception needs evidence from the dates on the rule, and the record that carries it is syslog. With Fleet Syslog on — Alert Settings, Fleet tab — Lockdown denials arrive as lines with identifier `heartsuite`. Save a search for the dates on the rule and keep it with the rule. Turn the switch on before the window opens; a window with the switch off has no `heartsuite` lines to attach.

The two local files answer different questions. The status file at `~/.cache/heartsuite/status.json` is rewritten about every minute, so Ansible, Nagios, and Zabbix can read the current state, and a monitor that polls it keeps the history of `lockdown` across the window. The approval log at `/var/log/heartsuite/allowlist-audit.log` records who approved each allowlist entry, with the user id and the terminal — the attribution for changes, where syslog is the record of refusals.

The deferral also holds only while the host stays in Lockdown. Leaving Lockdown takes a physical or serial console and the boot menu pick **Maintenance: unseal and return to Root Lock**, which returns the host to Setup Mode, where the kernel logs and stops blocking. Relock is the reboot back to Lockdown. Plan maintenance on these hosts with the open rows in mind.

## Filing it in Tenable or Qualys

Bring a short list from your own queue:

- the rows, and for each one the next step Lockdown refuses
- the window your policy already names for that work
- the approver who signs the exception
- the saved `heartsuite` syslog search for those dates

File them in Tenable or Qualys with an expiry. Tenable Accept hides the row from the active views until that date and leaves VPR as scored. A Qualys risk acceptance takes the row off remediation after a scan, and the expiry puts it back. Either way the finding returns the morning the rule expires, and a comment on its own does not pause the ticket clock — the exception does. The person who clicks is often not the approver, so put the approver's name on the rule.

The filing steps for each scanner are on [Scanner deadlines](https://docs.heartsecsuite.com/rootlock/maintenance/scanner-deadlines/). The syslog setup is on [SIEM and Fleet Integration](https://docs.heartsecsuite.com/rootlock/alerts/siem-integration/).

## How far it reaches

The case is as strong as the grants. A program with wide write grants makes "a file that program was not granted" a weaker reason, and fewer of its rows are the class that can wait. Narrow the list after Setup Mode, and the reason gets stronger on every row that program owns — each grant you remove moves more of that program's rows out of the night and into the window.

The judgment stays yours. Root Lock does not classify the CVE or file the rule; you read the next step, and you type the reason into the scanner you already run. What Root Lock contributes is the refusal itself: under Lockdown, the attacker's next unapproved program, file, or destination is refused on every one of those hosts until the patch lands.

## What emergency patching costs at 100 and 1,000 servers

{{< stat-row >}}
{{< stat number="$445k" tone="success" label="left over each year after paying for Root Lock — busy shop, 1,000 hosts." source="Hour-based estimate, inputs below" >}}
{{< stat number="2.6–2.9×" tone="success" label="back on every subscription dollar in the busy shop, paid in nights nobody is paged." source="Hour-based estimate, inputs below" >}}
{{< stat number="10×" tone="teal" label="the subscription, once about 30 off-hours rounds a year are rows Lockdown lets wait." source="Hour-based estimate, inputs below" >}}
{{< /stat-row >}}

No published study prices an emergency patch cycle, so the figures below are built from hours, and each input is an estimate you replace with your own. An off-hours emergency costs about six hours before any host is touched — triage, emergency change approval, a rushed staging test, and the notice to the business — then about an hour per host to install, reboot, and check, at an overtime rate, plus four hours for each host where the rushed change fails. The same patch folded into a window you already scheduled costs about 0.4 hours per host and none of the fixed six.

At $75 an hour and the published subscription floor of $270 per host a year, two shops show the range. In each cell, the first figure is the yearly extra cost of off-hours work avoided when rows whose next step Lockdown refuses wait for the window. The second is what is left after paying for Root Lock: the subscription, plus the console unseal Lockdown requires before scheduled maintenance on hosts you update in place.

| Estate | Busy shop: 18 emergencies a year, half of them this class, 80% of hosts on each | Disciplined shop: 6 emergencies a year, a quarter this class, already patches monthly |
|---|---|---|
| 100 hosts | about $89,000 of off-hours work avoided; about **$50,000 left over** | about $7,000 avoided; Root Lock costs about $35,000 more than it saves |
| 1,000 hosts | about $838,000 of off-hours work avoided; about **$445,000 left over** | about $60,000 avoided; Root Lock costs about $358,000 more than it saves |

In the busy shop, every subscription dollar comes back about two and a half to three times, paid in nights nobody is paged. At 1,000 hosts that is about $445,000 a year after Root Lock is paid for. The return grows with the pager: at about 30 off-hours rounds a year of this class, the saving passes ten times the subscription. In the disciplined shop, the scheduled window already absorbs that work, so what you buy is the refusal — every host holding its allowlist until the patch lands — rather than a smaller overtime bill. Hosts rebuilt from an image never need the unseal, so on an image-based fleet Root Lock's added time is one more stage in the image build, and more of each avoided night stays in the saving.

The deciding inputs are your own. Four questions replace the estimates:

- In the last 12 months, how many times was someone paged off-hours to patch a Linux CVE before the next window, and how many hosts did each page touch?
- How many of those were this class — the next step a program, file, or destination Lockdown refuses — and not on the KEV list?
- Is your scheduled patching automated end to end, or does someone install and check each host by hand?
- What is the fully loaded hourly cost of the person paged, and is off-hours work paid as overtime or absorbed into salary? If it is absorbed, drop the overtime rate and the case shrinks.

If the answer to the first question is "never", you already run the disciplined shop, and what Root Lock adds on those hosts is the refusal itself.
