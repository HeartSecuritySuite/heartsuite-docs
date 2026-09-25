---
title: "Security as Economics"
linkTitle: "Security as Economics"
weight: 6
description: "A high scanner score can wait for the standard change window when Lockdown already stops the next step. Attacker cost, operating cost, and alert volume."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "economics", "roi", "edr", "selinux", "zafran", "ctem", "patching", "alerts"]
type: docs
aliases:
  - /docs/introduction/security-as-economics/
toc: true
---

**Overview**: Defeating a host control has a cost, and so does operating one. Root Lock by HeartSuite does not scan, score, or guess — in Lockdown the allowlist entry exists or it does not. A high scanner score can wait for the standard change window when the next step is a program with no allowlist entry, a file that program was not granted, or a destination it was not granted.

## Patching urgency

The scanner starts a short clock on a high score. Read the next step. When it is a program with no allowlist entry, a file the program was not granted, or a destination the program was not granted, Lockdown stops that step, and the patch goes in at the standard change window.

Where your policy sets that window at 60 days or 90 days for work it does not rank critical, file the exception with the expiry set to that window. The expiry on the scanner rule is what takes the row off the active queue, and what changes the tool's score, report, and remediation queue until the rule expires. The date in your policy or contract stays the remediation SLA.

A bug that can finish on data the program already reads, on a file it was granted, or on a destination already permitted keeps the policy date. So does a kernel CVE whose code is in the Root Lock kernel you boot, and any finding your policy treats as immediate, including one known to be exploited. See [Scanner deadlines](../../maintenance/scanner-deadlines/).

For a compiled-out kernel CVE, the Root Lock kernel stays as shipped. Record that status from [Kernel Security Transparency](../../security/) on the rule. `apt` and `dnf` install the OS packages.

A cheaper commodity zero-day runs a program, touches files, and phones home. Lockdown bounds those three. A zero-day inside an allowlisted program reads the files on its allowlist.

## What defeating it costs

No security control is unconditionally unbreakable. The right question is not "can this be defeated?" but "what does defeating it cost the attacker — and what does operating it cost the defender?"

**No false positives in blocking.** In Lockdown, Root Lock does not scan, score, or guess. A program either has an allowlist entry for the action it is attempting, or it does not.

Permitted actions pass. Unpermitted actions are blocked. Every blocking decision is exact — not a detection estimate.

**The boundary holds regardless of privilege.** A process running as root can only reach the files its allowlist entry permits. Credentials, configuration, and data outside that slice are unreachable regardless of privilege. Network destinations outside the allowlist are unreachable the same way.

Under Lockdown the allowlist itself is sealed. Root cannot edit it the way agents or LSM policy can be stopped or set permissive. The question is no longer whether the agent is still running. It is whether Setup Mode approved too much, and whether someone at the console can unseal it.

Each additional step the attacker takes requires a new custom exploit targeted at the specific program and allowlist slice they are confined to. The cost compounds. At some point the attack is no longer worth finishing.

**Cost to implement.** A finite window: run the programs you want to allow, review and approve through the Dashboard queues, engage Lockdown. Most customers complete it during a standard change window.

## Operational cost

**Alert reduction.** An attack that cannot progress past the kernel gate does not generate a SIEM or EDR alert. A binary that cannot execute never triggers a process-execution event. An outbound connection refused at the kernel never appears in NDR telemetry as a beacon or data-loss event.

This is not alert filtering — the event never occurs. The alert classes this eliminates carry the highest triage cost: unauthorized execution, unauthorized exfiltration, and novel outbound destinations.

**Maintenance.** No signature updates. No rule libraries. No agent fleet. The allowlist changes when software legitimately changes — new binaries, updated dependencies, changed network destinations — in a maintenance window on your schedule.

The more frequently software changes, the more frequently those windows are needed. For software that updates daily — package managers pulling live repositories, or applications shipping a new binary on each release — a maintenance window is required each time.

That is low overhead on monthly or quarterly patch schedules; at daily cadence it compounds. Root Lock fits well where the software stack is stable or follows a defined update process.

## ROI compared

**SELinux and AppArmor.** LSM policy is a sustained engineering cost: SELinux refpolicy domain authoring, AppArmor profile maintenance, permissive-mode exceptions that accumulate under operational pressure, and policy audits before each OS upgrade. Each policy file is hand-authored and must be updated when software changes.

Root Lock records what programs actually do during Setup Mode and presents it for approval. The difference compounds over years: one observation-driven setup session versus ongoing policy authorship and drift management.

**Zafran and risk-prioritization tools.** Zafran, Nucleus, Vulcan Cyber, and similar tools correlate CVEs against your deployed controls to identify which patches are actually urgent. They do not enforce anything at runtime.

Root Lock reduces the urgency of items these tools surface when the exploit needs a program with no allowlist entry, a file the program was not granted, or a destination the program was not granted. That patch can ride the standard change window. The two compose: the tool can rank those CVEs behind findings that finish inside the grant, because the allowlist is what the kernel enforces and the files and destinations on it are the ones you approved.

**Linux EDR.** CrowdStrike Falcon, SentinelOne, and Microsoft Defender for Endpoint generate alerts that require analyst triage. The attack classes Root Lock prevents — unauthorized binary execution, file access outside approved scope, outbound connections to unapproved destinations — never reach the EDR because the attack cannot progress past the kernel gate.

Fewer alerts is not filtering; it is that the attack class is structurally absent from the host. EDR's telemetry, behavioural analytics, and incident response capabilities remain valid for what Root Lock does not cover. The honest position: Root Lock changes what the EDR has to process, not whether you run one.

**Cost to buy.** Root Lock replaces the preventive-enforcement layer of several overlapping tools, leaving detection and response capabilities intact. What that means in practice for each category:

- **Commercial eBPF enforcement tools** (Sysdig Secure, commercial Falco, Cilium Tetragon) — Root Lock removes the BPF syscall by design. On-host eBPF tooling is not a fit. Their preventive role is covered by the allowlist. Budget line removed; stronger prevention gained.
- **gVisor** — if you are running it solely to protect workloads from root-level compromise inside a container or VM, Root Lock is a direct replacement as the guest kernel. No second userspace kernel layer.
- **The blocking dimension of Linux EDR** (CrowdStrike Falcon, SentinelOne, MDE) — prevention is replaced; telemetry, behavioural analytics, and SOC console are not. Some vendors offer lighter-tier pricing for telemetry-only deployments.
- **AppArmor and SELinux** — no licensing cost, but the policy-authoring overhead is real; see the SELinux comparison above.

Whether the licensing savings cover the Root Lock subscription depends on your current stack. The operational consolidation — no signature updates, no rule libraries, no agent fleet — is consistent regardless.

**CTEM programs** — Continuous Threat Exposure Management — cover exposure discovery, prioritisation, and validation across a whole estate: continuously mapping what an attacker could reach and ranking what to fix first. That scope fits large organisations managing complex, heterogeneous environments. For most deployments it is broader than the problem and carries corresponding cost.

Root Lock addresses one specific problem: the OS design assumption that grants every running program the file and network rights of the user who launched it. Removing that assumption at the kernel level does not require a continuous discovery and ranking program.

**The CISO case.** An attacker who already has root cannot go past the programs, files, and IPs already approved. The blast radius is bounded before anything runs. It is not detected after the fact. It is not cleaned up after the fact.

That changes the economics of every attack that reaches the host. It does not eliminate breach risk. It makes moving to the next machine, exfiltration, and privilege escalation substantially more expensive to execute — before detection has a chance to respond.
