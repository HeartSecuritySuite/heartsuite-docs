---
title: "FAQs"
weight: 105
description: "Common questions and answers for HeartSuite Core Secure."
categories: ["Support"]
tags: ["heartsuite", "linux", "questions", "help", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky"]
toc: true
type: docs
---

## General

{{< details summary="How is HeartSuite Core Secure different from other anti-malware solutions?" >}}

A: Every attack does three things: run a program, access files, make a network connection. HeartSuite Core Secure controls all three per program — not per user, per program. Unlike anti-malware tools that look for signatures or suspicious behavior, HeartSuite Core Secure requires every execution, file access, and network connection to be explicitly approved through the Dashboard's review queues; in Lockdown, anything not approved is blocked. Because enforcement happens inside the kernel itself, it cannot be circumvented by any program or user, including root.

{{< /details >}}

{{< details summary="Who is HeartSuite Core Secure for?" >}}

A: HeartSuite Core Secure fits systems where the same programs do the same jobs, day after day — production servers with defined stacks, closed appliances and embedded devices, regulated workstations, build and CI infrastructure, and AI agent sandboxes inside per-task virtual machines. Container host support is available via the Container-host install for steady-state workloads (Docker, containerd, Kubernetes on EKS, GKE, AKS) — see [Deployment Scenarios](introduction/deployment-scenarios/) for the specifics. Currently it is not a fit for hosts that run eBPF-based observability tools like Falco, Cilium, or Tetragon. See [Deployment Scenarios](introduction/deployment-scenarios/) for the full breakdown.

{{< /details >}}

{{< details summary="Can I use the same allowlist across a fleet or Kubernetes cluster?" >}}

A: Yes. Each host runs the HeartSuite Core Secure kernel with the same allowlist installed locally — no central policy server, no cloud dependency. The same allowlist configuration can be distributed to any number of hosts. Production deployments run HeartSuite Core Secure across hundreds or thousands of nodes, all enforcing the same approved-programs policy. Fleet-wide event correlation and compliance reporting are handled by your SIEM alongside HeartSuite Core Secure — see [How HeartSuite Core Secure Compares](introduction/how-it-compares/).

{{< /details >}}

{{< details summary="How does HeartSuite Core Secure compare to Falco, AppArmor, SELinux, gVisor, or Linux EDR?" >}}

A: HeartSuite Core Secure replaces these tools on the preventive-enforcement dimension. Each of them can be disabled by an attacker who already has root — Falco agents can be killed, BPF programs unloaded, SELinux set permissive, AppArmor profiles detached, gVisor processes compromised, EDR drivers tampered with. HeartSuite Core Secure has no agent to kill and no module to unload, and under Lockdown even root cannot change the allowlist at runtime. See [How HeartSuite Core Secure Compares](introduction/how-it-compares/) for a side-by-side table including how each can be disabled and how HeartSuite Core Secure can itself be circumvented (physical presence — keyboard and monitor, serial port, or cloud serial console — only). For a detailed SELinux comparison, see "How does HeartSuite Core Secure compare to SELinux specifically?" below.

{{< /details >}}

{{< details summary="How does HeartSuite Core Secure compare to SELinux specifically?" >}}

A: SELinux is a strong MAC framework — it confines processes using labels, enforces type-based file access controls, and limits capability use across the system. For organizations that maintain SELinux policy (refpolicy or targeted), it provides fine-grained control that HeartSuite Core Secure does not replicate; SELinux's domain transitions and per-service profiles are deliberate capabilities, not gaps.

The limitation is the trust boundary. Root with the right capability can set SELinux to permissive mode, reload a relaxed policy, or edit policy files directly. If the system is compromised before SELinux policy is fully hardened, the attacker has the same access as any root process and can dismantle the policy from there.

HeartSuite Core Secure's distinction is where enforcement is anchored. Under Lockdown, the allowlist is sealed at the filesystem level (`chattr +i`) and the HS kernel refuses to lift that seal at runtime — by any process, including root. There is no remote path to disable enforcement; modifying the allowlist requires booting the Non-HS kernel, which requires physical presence — a keyboard and monitor, serial port, or your cloud provider's serial console.

The two are not mutually exclusive. SELinux's domain transitions and distribution-shipped per-application profiles add policy depth HeartSuite Core Secure does not provide; HeartSuite Core Secure adds the sealed boundary SELinux does not. See [How HeartSuite Core Secure Compares](introduction/how-it-compares/) for the full side-by-side.

{{< /details >}}

{{< details summary="What software can I remove or stop paying for if I run HeartSuite Core Secure?" >}}

A: HeartSuite Core Secure replaces the preventive-enforcement layer of the following tool categories. Whether you can remove a product entirely depends on whether you were running it purely for prevention, or also for telemetry and response.

**Can remove or reduce:**

- **Commercial eBPF enforcement tools** (Sysdig Secure, commercial Falco, Cilium Tetragon) — enforcement is covered by the allowlist, and the BPF syscall is absent from the HS kernel so these tools cannot run on it anyway. OSS Falco carries no licensing cost but does carry ongoing rule-tuning overhead that goes away.
- **gVisor** — if used solely to protect workloads from root-level compromise inside a VM or microVM, HeartSuite Core Secure is a direct replacement as the guest kernel.
- **AppArmor / SELinux** — no licensing cost, but the policy-authoring and drift-management overhead is replaced by observation-driven allowlist setup. See [Security as Economics](introduction/security-as-economics/) for the full comparison.
- **The blocking dimension of Linux EDR** (CrowdStrike Falcon, SentinelOne, MDE) — prevention is replaced. Telemetry, behavioural analytics, and SOC console are not. Some vendors offer lighter-tier pricing once the workload prevention layer moves to HeartSuite Core Secure.

**Cannot remove:**

- **SIEM, NDR, vulnerability scanners, and HIDS/FIM** — these answer questions HeartSuite Core Secure does not: fleet correlation, traffic analysis, compliance reporting, and patch prioritisation. See "Does HeartSuite Core Secure replace my SIEM, NDR, or vulnerability scanner?" below.

{{< /details >}}

{{< details summary="Does HeartSuite Core Secure replace my SIEM, NDR, or vulnerability scanner?" >}}

A: No. HeartSuite Core Secure enforces at the kernel level on each host individually — it does not correlate events across a fleet, ingest external data, or produce compliance reports across a fleet. (The same allowlist can be distributed to any number of hosts; see the FAQ below: "Can I use the same allowlist across a fleet or Kubernetes cluster?") SIEM (Splunk, Sentinel, Elastic), NDR (Darktrace, ExtraHop), vulnerability management (Nessus, Qualys, Wiz), and HIDS/FIM (OSSEC, Wazuh, AIDE) answer fleet-wide, telemetry, and compliance questions that HeartSuite Core Secure does not address. Run HeartSuite Core Secure alongside them — it reduces the volume of events those products have to reason about by making a class of attacks impossible rather than merely visible. HeartSuite Core Secure's activity log is a useful SIEM input. See [How HeartSuite Core Secure Compares](introduction/how-it-compares/).

{{< /details >}}

{{< details summary="Why is kernel-level enforcement better than eBPF or agent-based security?" >}}

A: Many security products — including Falco, Cilium Tetragon, and CrowdStrike Falcon on Linux — rely on eBPF filters or user-space agents running as processes within the same OS as the programs they are meant to protect. Malware with sufficient privileges can disable, bypass, or unload them. HeartSuite Core Secure's enforcement is compiled into the kernel itself. There is no agent to kill, no filter to detach, and no module to unload. If the HeartSuite Core Secure kernel is running, blocking is active. This is the difference between a lock on the door and a guard standing next to it.

{{< /details >}}

{{< details summary="How is HeartSuite Core Secure itself protected from attacks? How do I know that HeartSuite Core Secure won't be targeted or compromised?" >}}

A: Lockdown makes all allowlist entries and configuration files immutable at the filesystem level, then disables the ability to change immutability flags at the kernel level. This means not even root can modify, delete, or add allowlist entries while Lockdown is active — the kernel itself prevents it. To make changes, the Dashboard's Maintenance (`[t]`) guides you through a 3-step process that includes booting the Non-HS kernel to remove the immutable flags. The Dashboard confirms Lockdown status after every reboot.

{{< /details >}}

{{< details summary="What are the system requirements for HeartSuite Core Secure?" >}}

A: Debian 11, 12, or 13; any Ubuntu-derived distribution; or Alpine Linux — all on x86 architecture. RPM-based distributions (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE) are coming soon. HeartSuite Core Secure ships with two HeartSuite Core Secure kernel versions: 5.19 and 6.18.

{{< /details >}}

{{< details summary="How can I download HeartSuite Core Secure?" >}}

A: Download the tar file from heartsecsuite.com — the download form is on the website; direct wget links are not provided.

{{< /details >}}

{{< details summary="Is technical support available for HeartSuite Core Secure customers?" >}}

A: Yes. Email support@heartsecsuite.com or visit the tech support page on [heartsecsuite.com](https://heartsecsuite.com).

{{< /details >}}

{{< details summary="How do I report a bug or security issue?" >}}

A: For bugs, open an issue on GitHub using the [Bug Report template](https://github.com/HeartSecuritySuite/heartsuite-core-secure/issues/new?template=bug-report.md). Include your HeartSuite Core Secure version, kernel version, the protection state shown at the top of your Dashboard, and steps to reproduce. For security vulnerabilities, do not use a public issue — email support@heartsecsuite.com for responsible disclosure.

{{< /details >}}

{{< details summary="Can HeartSuite Core Secure automatically backup files?" >}}

A: Yes. Every time a file in a configured directory is modified, HeartSuite Core Secure automatically creates a new versioned backup with a timestamp and file size. Under Lockdown, the kernel itself blocks any program (including root) from reaching the backup files — so even if an attacker compromises an approved program, the previous versions remain intact. Versions are never automatically deleted. Use the Dashboard's Backup (`[b]`) to add or remove directories, browse version history, and restore any previous version of a file.

{{< /details >}}

{{< details summary="Will HeartSuite Core Secure flood me with alerts?" >}}

A: No. Most security products generate high volumes of alerts because they flag suspicious patterns — leading to alert fatigue where real threats get lost in the noise. HeartSuite Core Secure only alerts on genuinely unauthorized activity: a program attempting to execute without approval, or an outbound connection to an unapproved destination. Events are deduplicated and batched in 5-minute windows, with an hourly cap on email alerts. In Lockdown with a complete allowlist, alerts are rare — because the allowlist already covers all legitimate activity. Configure alerts through the Dashboard's Alert Settings (`[e]`) (email, syslog, or webhook).

{{< /details >}}

{{< details summary="What does the free trial include?" >}}

A: Lockdown requires an active subscription, all review queues to be cleared, and alert settings to be configured. Setup Mode logs activity without blocking — you can observe your workload, but blocking is not active. The Dashboard presents a precondition checklist before activation.

{{< /details >}}

{{< details summary="I work remotely a lot; can I still access a HeartSuite Core Secure server remotely?" >}}

A: Yes. Allowlist the SSH program and the IP addresses you connect from — remote access works the same as any other approved program.

{{< /details >}}

{{< details summary="What is the Dashboard?" >}}

A: The Dashboard is how you manage HeartSuite Core Secure. It shows your current mode (Setup or Lockdown), progress through each setup phase, pending or denied counts, and a Suggested Next Step that tells you exactly what to do next. The indicator at the top confirms the current protection state at a glance. The Dashboard appears automatically on first login.

{{< /details >}}

{{< details summary="How does HeartSuite Core Secure guide me through setup?" >}}

A: The Dashboard walks you through seven phases, from verifying your installation to activating full protection. Each phase focuses on one task — approving programs (`[p]`), configuring script launchers (`[l]`), approving file access (`[f]`), approving internet access (`[i]`), and setting up alerts (`[e]`). The Dashboard tracks your progress and always shows the next step. Lockdown unlocks only after all prior phases are complete.

{{< /details >}}

## Installation

{{< details summary="Will installing the HeartSuite Core Secure kernel break my existing software?" >}}

A: The HS kernel is installed alongside your existing kernel via GRUB — it does not replace it. You can boot back to the Non-HS kernel at any time from the GRUB menu, and the Dashboard remains accessible on both. The HS kernel is based on mainline LTS Linux (5.19 or 6.18), not a fork.

Setup Mode reveals compatibility issues before Lockdown enforces anything. During Setup Mode the system logs all activity without blocking — programs that would fail in Lockdown appear in the Dashboard review queues during the observation period. You see what is affected before anything is blocked.

All feature removals are intentional and documented in [System Requirements → Software Compatibility Notes](introduction/system-requirements/#software-compatibility-notes). Software not listed in that table will run without modification. The removed features — eBPF, FUSE, overlay filesystems, unprivileged user namespaces — are kernel features attackers use to escalate privilege or escape security restrictions; most production server workloads do not depend on them.

{{< /details >}}

{{< details summary="Once I've installed HeartSuite Core Secure, can a program access files without adding the directories to the allowlist entry?" >}}

A: No. In Lockdown, a program can only access files and directories that have been explicitly approved through the Dashboard's File Access review queue. After allowlisting a program's execution in Phase 2, you approve its file access in Phase 4 — the Dashboard shows every file the program attempted to read or write.

{{< /details >}}

{{< details summary="Why do I need to reboot multiple times during installation?" >}}

A: The HeartSuite Core Secure kernel must be loaded during the installation process. Each setup step — run via the System Setup — captures startup and shutdown programs that appeared in the previous boot. Multiple steps are needed because shutdown programs appear on the second boot, and timer-driven processes on later ones. Skipping steps can leave essential programs unapproved, which would cause the system to hang in Lockdown.

{{< /details >}}

{{< details summary="If the reboot after Part 1 fails, what should I do?" >}}

A: Check GRUB settings (e.g., uncomment GRUB_DISABLE_LINUX_UUID for VMs), verify installation logs, and try recovery mode.

{{< /details >}}

{{< details summary="The System Setup is not showing Setup Complete — what next?" >}}

A: Check the Dashboard's Suggested Next Step — it will indicate what remains. Press `[a]` from the System Setup to run the next step. The system reboots automatically after each step that finds new programs.

{{< /details >}}

## Allowlisting

{{< details summary="A new program is being blocked in Lockdown — what should I do?" >}}

A: In Lockdown, any program not on the allowlist is blocked. This typically happens after installing new software or a system update that introduces programs HeartSuite Core Secure has not seen before. To resolve it, select Maintenance (`[t]`) from the Dashboard — it guides you through switching to Setup Mode, where the new program appears in the review queue. Approve it from there, then re-engage Lockdown.

{{< /details >}}

{{< details summary="Can I allowlist directories instead of files?" >}}

A: Yes. When the Dashboard's File Access review queue presents grouped accesses from the same directory, you can approve directory-level access rather than approving each file individually. For example, if Python reads 200 files from `/usr/lib/python3/`, the review queue groups them and lets you approve access to the entire directory at once.

{{< /details >}}

{{< details summary="How do I activate Lockdown?" >}}

A: The Dashboard unlocks Lockdown when all prior phases are complete and shows it as the Suggested Next Step. Activation requires typing `YES` (case-sensitive) to confirm.

{{< /details >}}

{{< details summary="How do I add network access for a program?" >}}

A: HeartSuite Core Secure requires every outbound connection to be explicitly approved per program. When a program attempts a connection during Setup Mode, it appears in the Dashboard's Internet Access review queue with the destination IP, reverse DNS, and program metadata. Approve the connection from there. In Lockdown, any connection not on the allowlist is refused at the kernel.

{{< /details >}}

## Modes and security

{{< details summary="When should I activate Lockdown?" >}}

A: After the Dashboard shows all review phases complete. Take your time in Setup Mode — allow several days to a week for systemd timers, cron jobs, and infrequent services to appear in the review queues. The status line at the bottom of the Dashboard shows how long Setup Mode has been active (e.g., "Setup Mode — active for 3d 7h"), so you can easily track your observation period. Switching too early will block programs that have not been approved.

{{< /details >}}

{{< details summary="What is Lockdown, and when to use it?" >}}

A: Lockdown makes all allowlist entries and configuration files immutable (`chattr +i`), then disables the ability to change immutability flags at the kernel level. No user or program — including root — can modify, delete, or add allowlist entries while Lockdown is active. Use it in production after confirming all programs work correctly in Lockdown.

{{< /details >}}

{{< details summary="How do I activate Lockdown?" >}}

A: Once Lockdown is active and verified, apply the immutable seal from the Dashboard. This requires typing `YES` (case-sensitive) to confirm.

{{< /details >}}

{{< details summary="How do I make configuration changes after entering Lockdown?" >}}

A: Select the Maintenance (`[t]`) from the Dashboard. It detects that Lockdown is active and guides you through a 3-step process: booting the Non-HS kernel to remove immutable flags (`[u]`), making your changes, then rebooting back to the HeartSuite Core Secure kernel to review new activity and re-engage Lockdown. The Dashboard resumes at the correct step after each reboot.

{{< /details >}}

{{< details summary="How do I maintain or update in Lockdown?" >}}

A: Select the Maintenance (`[t]`) from the Dashboard. It detects whether Lockdown is active and guides you through the correct path — either a simple switch to Setup Mode, or a guided 3-step process across two reboots if Lockdown requires the Non-HS kernel. The Dashboard handles all steps including a pre-maintenance safety checklist.

{{< /details >}}

## Troubleshooting

{{< details summary="How do I check if HeartSuite Core Secure is active?" >}}

A: The indicator at the top of the screen immediately shows whether HeartSuite Core Secure is active and what mode it is in. The Dashboard appears automatically on login.

{{< /details >}}

{{< details summary="The system hangs—what's first?" >}}

A: Reboot into a Non-HS kernel (select it from GRUB). The Dashboard resumes automatically on the Non-HS kernel and guides you through the maintenance steps. Once back on the HeartSuite Core Secure kernel, the Dashboard will show any pending items that caused the hang.

{{< /details >}}

{{< details summary="How to clear HeartSuite Core Secure logs?" >}}

A: The Dashboard automatically clears the activity log when all review queues are empty — no manual action is required.

{{< /details >}}

For support email support@heartsecsuite.com.
