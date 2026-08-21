---
title: "Does this replace EDR? And other FAQs"
linkTitle: "FAQs"
weight: 105
description: "How Root Lock differs from anti-malware, who it is for, AI agents, containers, and what happens when something is blocked."
categories: ["Support"]
tags: ["heartsuite", "linux", "questions", "help", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "openclaw", "nemoclaw", "claude-code", "codex"]
toc: true
type: docs
---

## General

{{< details summary="How is Root Lock by HeartSuite different from other anti-malware solutions?" >}}

A: Every attack does three things: run a program, access files, make a network connection. Root Lock controls all three per program, not per user.

Unlike anti-malware tools that look for signatures or suspicious behavior, every execution, file access, and network connection must be approved through the Dashboard review queues. In Lockdown, anything not approved is blocked.

There is no agent to kill and no module to unload. Enforcement is compiled into the kernel. An attacker who already has remote root cannot turn Lockdown off or edit the sealed allowlist. Changing it takes physical or serial-console access. SSH is not enough.

See [How Root Lock Compares](introduction/how-it-compares/#circumvention-and-recovery).

{{< /details >}}

{{< details summary="Who is Root Lock for?" >}}

A: Root Lock fits systems where the same programs do the same jobs, day after day — production servers with defined stacks, closed appliances and embedded devices, regulated workstations, build and CI infrastructure, and AI agent sandboxes inside per-task virtual machines.

Containers fit as OCI images built and run on a separate host, with Root Lock protecting the fixed-workload hosts around them — see the [container reference architecture](introduction/deployment-scenarios/#container-hosts).

Running a shared-kernel container runtime (Docker, containerd, Podman) directly on a Root Lock kernel host is not a fit by design. The kernel omits overlay filesystems and user namespaces because those are how attackers hide, shadow directories, and reach root.

Hosts that run eBPF-based tools like Falco, Cilium, or Tetragon are not a fit for the same reason: the BPF syscall is omitted. See [Deployment Scenarios](introduction/deployment-scenarios/) for the full breakdown.

{{< /details >}}

{{< details summary="Can I use the same allowlist across a fleet or Kubernetes cluster?" >}}

A: Same allowlist **across a fleet of similar hosts**: yes. Each host runs the Root Lock kernel with the allowlist installed locally. There is no HeartSuite central policy server. Your automation (Ansible, Terraform + GitOps, Puppet, scripts) distributes the files.

Install on each host is still Cloud Path or Local Path. Ansible does not replace Cloud Path or Local Path; it runs them and then applies policy.

**Kubernetes:** only for long-lived, fixed pod sets established **before** Lockdown. Dynamic scheduling, HPA scale-out, and new mounts after Lockdown are not a fit. See [Deployment Scenarios](introduction/deployment-scenarios/) and [Containers and microVMs](introduction/containers-and-microvms/).

Event correlation stays in your SIEM. Policy reconciliation stays in Git/CM. Compliance reporting stays in your GRC tool. See [Central Policy Management](alerts/central-policy-management/).

{{< /details >}}

{{< details summary="How does Root Lock compare to Falco, AppArmor, SELinux, gVisor, or Linux EDR?" >}}

A: Falco is a **detection** engine. AppArmor, SELinux, gVisor, and Linux EDR each do a different job. Root Lock is host-local **prevention** (allowlist + Lockdown).

An attacker who already has remote root can still kill a Falco agent, unload an eBPF program, or set SELinux permissive. Under Lockdown, remote root has no intended path to lift the Root Lock seal. That is the comparison on the disable path.

See [How Root Lock Compares](introduction/how-it-compares/) for a side-by-side table. Recovery takes physical or serial-console access: keyboard and monitor, serial port, or cloud serial console. For SELinux specifically, see the next question.

{{< /details >}}

{{< details summary="How does Root Lock compare to SELinux specifically?" >}}

A: SELinux is a strong MAC framework — it confines processes using labels, enforces type-based file access controls, and limits capability use across the system. For organizations that maintain SELinux policy (refpolicy or targeted), it provides fine-grained control that Root Lock does not replicate. SELinux's domain transitions and per-service profiles are deliberate capabilities, not gaps.

The limitation is the trust boundary. Root with the right capability can set SELinux to permissive mode, reload a relaxed policy, or edit policy files directly. If the system is compromised before SELinux policy is fully hardened, the attacker has the same access as any root process and can dismantle the policy from there.

Root Lock anchors blocking in the kernel. Under Lockdown, root cannot lift the allowlist seal. The files are immutable (`chattr +i`). The kernel refuses the write. Changing the allowlist takes booting the maintenance kernel from a keyboard and monitor, a serial port, or your cloud provider's serial console. SSH is not enough.

The two are not mutually exclusive. SELinux's domain transitions and distribution-shipped per-application profiles add policy depth Root Lock does not provide; Root Lock adds the sealed boundary SELinux does not. See [How Root Lock Compares](introduction/how-it-compares/) for the full side-by-side.

{{< /details >}}

{{< details summary="What software can I remove or stop paying for if I run Root Lock?" >}}

A: Root Lock replaces the preventive-enforcement layer of the following tool categories. Whether you can remove a tool entirely depends on whether you were running it purely for prevention, or also for telemetry and response.

**What Root Lock can replace (narrowly):**

- **Commercial eBPF enforcement tools** (Sysdig Secure, commercial Falco, Cilium Tetragon): the allowlist covers blocking, and the BPF syscall is omitted by design — it is how attackers hide, reach root, and bypass host controls. These tools cannot run on the Root Lock kernel anyway. OSS Falco carries no licensing cost but does carry ongoing rule-tuning overhead that goes away.
- **gVisor**: if used solely to protect workloads from root-level compromise inside a VM or microVM, Root Lock is a direct replacement as the guest kernel.
- **AppArmor / SELinux**: no licensing cost, but the policy-authoring and drift-management overhead is replaced by observation-driven allowlist setup. See [Security as Economics](introduction/security-as-economics/) for the full comparison.
- **The blocking dimension of Linux EDR** (CrowdStrike Falcon, SentinelOne, MDE): prevention is replaced. Telemetry, behavioural analytics, and SOC console are not. Some vendors offer lighter-tier pricing once the workload prevention layer moves to Root Lock.

**Cannot remove:**

- **SIEM, NDR, vulnerability scanners, and HIDS/FIM** — these answer questions Root Lock does not: fleet correlation, traffic analysis, compliance reporting, and patch prioritisation. See "Does Root Lock replace my SIEM, NDR, or vulnerability scanner?" below.

{{< /details >}}

{{< details summary="Does Root Lock replace my SIEM, NDR, or vulnerability scanner?" >}}

A: No. Root Lock blocks on each host individually. It does not correlate events across a fleet, ingest external data, or produce fleet-wide compliance reports on its own.

The same allowlist can still be distributed by your automation; see "Can I use the same allowlist across a fleet or Kubernetes cluster?" above.

SIEM (Splunk, Sentinel, Elastic), NDR (Darktrace, ExtraHop), vulnerability management (Nessus, Qualys, Wiz), and HIDS/FIM (OSSEC, Wazuh, AIDE) answer fleet-wide, telemetry, and compliance questions that Root Lock does not. Run them alongside. Root Lock's syslog streams, JSONL approval log, status.json, and webhook are designed inputs for those tools.

See [How Root Lock Compares](introduction/how-it-compares/) and [Central Policy Management and External Control](alerts/central-policy-management/).

{{< /details >}}

{{< details summary="Why is kernel-level enforcement better than eBPF or agent-based security?" >}}

A: Many security tools — including Falco, Cilium Tetragon, and CrowdStrike Falcon on Linux — rely on eBPF filters or user-space agents running as processes in the same OS as the programs they are meant to protect. Malware with sufficient privileges can disable, bypass, or unload them.

Root Lock compiles blocking into the kernel itself. There is no agent to kill, no filter to detach, and no module to unload. If the Root Lock kernel is running, blocking is active.

This is the difference between a lock on the door and a guard standing next to it.

{{< /details >}}

{{< details summary="How is Root Lock itself protected from attacks? How do I know that Root Lock won't be targeted or compromised?" >}}

A: Lockdown makes allowlist entries and configuration files immutable at the filesystem, then disables changing immutability flags in the kernel. Under Lockdown, root cannot add, delete, or change allowlist entries. The kernel refuses the write.

To make changes, open Maintenance (`[m]`). After the seal is applied, reboot from a physical or serial console and select **Maintenance: unseal and return to Root Lock**. The seal lifts automatically and you return to Setup Mode on the Root Lock kernel. The Dashboard confirms Lockdown status after every reboot.

{{< /details >}}

{{< details summary="What are the system requirements for Root Lock?" >}}

A: x86 (64-bit) Linux. **Validated** in release testing: Debian 12/13, Ubuntu 24.04, Rocky 9.7, Fedora 41, CentOS Stream 9, Alpine 3.21. **Supported** without a specific gate run: Debian 11, Ubuntu-derived, Alpine 3.x. **RPM enterprise** (RHEL, AlmaLinux, SLES): RHEL-compatible — validate on your subscribed minor before production. Root Lock ships two Root Lock kernel lines: **6.18** (primary) and **5.19** (legacy). Full matrix: [Distro Compatibility](kernel-hardening/distro-compatibility-matrix/).

{{< /details >}}

{{< details summary="How can I download Root Lock?" >}}

A: Download the tar file from heartsecsuite.com — the download form is on the website; direct wget links are not provided.

{{< /details >}}

{{< details summary="Is technical support available for Root Lock customers?" >}}

A: Yes. Email support@heartsecsuite.com or visit the tech support page on [heartsecsuite.com](https://heartsecsuite.com).

{{< /details >}}

{{< details summary="How do I report a bug or security issue?" >}}

A: For product bugs, email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) with your Root Lock version, kernel version (`uname -r`), the protection state shown at the top of your Dashboard, and steps to reproduce. For documentation corrections, open an issue on [heartsuite-docs](https://github.com/HeartSecuritySuite/heartsuite-docs/issues). For security vulnerabilities, email support@heartsecsuite.com for responsible disclosure — do not use public issue trackers.

{{< /details >}}

{{< details summary="Can Root Lock automatically backup files?" >}}

A: Yes. Every time a file in a configured directory is modified, Root Lock creates a versioned backup with a timestamp and file size. Versions are never automatically deleted.

Under Lockdown, the kernel blocks any program (including root) from reaching the backup files. A compromised approved program cannot destroy previous versions.

Use Backup (`[b]`) to add or remove directories, browse version history, and restore any previous version.

{{< /details >}}

{{< details summary="Will Root Lock flood me with alerts?" >}}

A: No. Most security tools flag suspicious patterns and generate high volumes of alerts. Real threats get lost in the noise.

Root Lock only alerts on unauthorized activity: a program attempting to execute without approval, or an outbound connection to an unapproved destination. Email groups those blocks in a 5-minute window and caps at three block emails per hour, then sends a digest. Syslog and webhook emit each alert immediately.

In Lockdown with a complete allowlist, alerts are rare — the allowlist already covers legitimate activity. Configure alerts through Alert Settings (`[e]`) (email, syslog, or webhook).

{{< /details >}}

{{< details summary="What does the free trial include?" >}}

A: Lockdown requires an active subscription, all review queues to be cleared, and alert settings to be configured. Setup Mode logs activity without blocking — you can observe your workload, but blocking is not active. The Dashboard presents a precondition checklist before activation.

{{< /details >}}

{{< details summary="I work remotely a lot; can I still access a Root Lock server remotely?" >}}

A: Yes. Approve the SSH server to execute and to read the files it needs, the same as any other program. Installer seeds commonly already cover `sshd`.

Internet Access (`[i]`) is outbound destinations only. Adding the address you connect *from* there does not grant inbound SSH.

Root Lock still has SSH posture controls:

- **Lockdown** — Harden SSH (`[h]`) when an authorized key is already present (key-only login, direct root login off). Inbound permits (`[o]` / `[a]`) record which source addresses may reach sshd while sealed. `[r]` / `[j]` choose whether SSH stays up under Lockdown.
- **Maintenance** — console-only (network down), a restricted SSH route, or leave SSH open. You can limit SSH to specific source addresses, or press `[n]` to leave it open to anyone (not recommended). See [Protecting During Maintenance](maintenance/protecting-during-maintenance/).

sshd's own config, an OS packet filter, and cloud security groups still apply. If you SSH *from* the Root Lock host *to* other hosts, those destination IPs appear in Internet Access for the SSH client. See [Network and Remote Access](network/).

{{< /details >}}

{{< details summary="What is the Dashboard?" >}}

A: The Dashboard is how you manage Root Lock. It shows your current mode (Setup or Lockdown), checklist progress, pending or denied counts, and a Suggested Next Step.

The indicator at the top confirms the current protection state. The Dashboard appears automatically on first login.

{{< /details >}}

{{< details summary="How does Root Lock guide me through setup?" >}}

A: A checklist walks you through the work: approving programs (`[p]`), approving file access (`[f]`), approving internet access (`[i]`), configuring script launchers (`[s]`), and setting up alerts (`[e]`).

The Dashboard tracks progress and always shows the next step. Lockdown unlocks only after the prior checklist items are complete.

{{< /details >}}

## Installation

{{< details summary="Will installing the Root Lock kernel break my existing software?" >}}

A: The Root Lock kernel is installed alongside your existing kernel via GRUB — it does not replace it. You can boot back to the maintenance kernel at any time from the GRUB menu, and the Dashboard remains accessible on both. The Root Lock kernel is based on mainline LTS Linux (5.19 or 6.18), not a fork.

Setup Mode reveals compatibility issues before Lockdown enforces anything. During Setup Mode the kernel logs all activity without blocking — programs that would fail in Lockdown appear in the Dashboard review queues. You see what is affected before anything is blocked.

The removed features — eBPF, FUSE, overlay filesystems, unprivileged user namespaces — are how attackers hide, shadow directories, and reach root. Most production server workloads do not depend on them. The Root Lock kernel is built without them by design.

All feature removals are documented in [System Requirements → Software Compatibility Notes](introduction/system-requirements/#software-compatibility-notes). Software not listed in that table will run without modification.

{{< /details >}}

{{< details summary="Once I've installed Root Lock, can a program access files without adding the directories to the allowlist entry?" >}}

A: No. In Lockdown, a program can only access files and directories that have been explicitly approved through the File Access review queue.

After you approve a program's execution, you approve its file access separately. The Dashboard shows every file the program read or wrote during Setup Mode.

{{< /details >}}

{{< details summary="Why do I need to reboot multiple times during installation?" >}}

A: The Root Lock kernel must be loaded during installation. Unattended initial setup records startup and shutdown programs that appeared in the previous boot and reboots as needed.

Multiple passes are needed because shutdown programs appear on the second boot, and timer-driven processes on later ones. The Dashboard appears when that chain is complete. There is no System Setup screen.

{{< /details >}}

{{< details summary="If the reboot after Part 1 fails, what should I do?" >}}

A: Check GRUB settings (e.g., uncomment GRUB_DISABLE_LINUX_UUID for VMs), verify installation logs, and try recovery mode.

{{< /details >}}

{{< details summary="The Dashboard has not appeared after install — what next?" >}}

A: Initial setup is still running. It is unattended: the host reboots on its own between passes. Watch the serial console for the finishing-install banner, or `cat /var/log/heartsuite/install.log`. The Dashboard appears when initial setup is complete. There is no System Setup screen and no `[a]` to press.

{{< /details >}}

## Allowlisting

{{< details summary="A new program is being blocked in Lockdown — what should I do?" >}}

A: In Lockdown, any program not on the allowlist is blocked. This typically happens after installing new software or a system update.

Select Maintenance (`[m]`) from the Dashboard. It guides you through switching to Setup Mode, where the new program appears in the review queue. Approve it from there, then re-engage Lockdown.

{{< /details >}}

{{< details summary="Can I allowlist directories instead of files?" >}}

A: Yes. When the File Access review queue presents grouped accesses from the same directory, you can approve directory-level access rather than each file individually.

For example, if Python reads 200 files from `/usr/lib/python3/`, the review queue groups them and lets you approve access to the entire directory at once.

{{< /details >}}

{{< details summary="How do I activate Lockdown?" >}}

A: The Dashboard unlocks Lockdown when the prior checklist items are complete and shows it as the Suggested Next Step. Activation requires typing `YES` (case-sensitive) to confirm.

{{< /details >}}

{{< details summary="How do I add network access for a program?" >}}

A: Every outbound destination must be approved per program. When a program connects during Setup Mode, it appears in the Internet Access queue (`[i]`) with its destination IPs and any reverse-DNS or CDN label the Dashboard resolved.

Approve network access from there. Approving an IP for one program does not approve it for another. In Lockdown, any destination not on that program's list is refused at the kernel. Inbound ports and client source IPs are out of scope — see [Network and Remote Access](network/).

{{< /details >}}

## Modes and security

{{< details summary="When should I activate Lockdown?" >}}

A: After the Dashboard shows the review checklist complete. Take your time in Setup Mode — allow several days to a week for systemd timers, cron jobs, and infrequent services to appear in the review queues.

The status line at the bottom of the Dashboard shows how long Setup Mode has been active (e.g., "Setup Mode — active for 3d 7h"). Switching too early will block programs that have not been approved.

{{< /details >}}

{{< details summary="What is Lockdown, and when to use it?" >}}

A: Lockdown makes all allowlist entries and configuration files immutable (`chattr +i`), then disables the ability to change immutability flags at the kernel level. Under Lockdown, root cannot add, delete, or change allowlist entries.

Use it in production after confirming programs work correctly under Lockdown.

{{< /details >}}

{{< details summary="How do I apply the immutable seal after Lockdown?" >}}

A: The seal is applied as part of Lockdown activation (see the "How do I activate Lockdown?" entry above). Once confirmed and rebooted, Lockdown + sealed is active automatically on every Root Lock kernel boot.

{{< /details >}}

{{< details summary="How do I make configuration changes after entering Lockdown?" >}}

A: Select Maintenance (`[m]`) from the Dashboard. If the seal is not applied, type `YES` and reboot once into Setup Mode on the Root Lock kernel. If the seal is applied, reboot from a physical or serial console and select **Maintenance: unseal and return to Root Lock**. The seal lifts automatically and you land in Setup Mode. Review new activity in the queues, then re-engage Lockdown (`[l]`).

{{< /details >}}

{{< details summary="How do I maintain or update in Lockdown?" >}}

A: Maintenance (`[m]`) detects whether the immutable seal is active and opens the matching path — a `YES` switch to Setup Mode on the Root Lock kernel, or the console GRUB entry **Maintenance: unseal and return to Root Lock** when the seal is applied.

A product update will not overwrite Root Lock while that kernel is booted. Setup Mode is still the Root Lock kernel. If Lockdown is applied, unseal first. From a terminal in Setup Mode, run `bash heartsuite-install.sh` and type `YES` for one stock boot. The default stays Root Lock. See [Updating Root Lock](maintenance/updating-heartsuite/).

{{< /details >}}

## Troubleshooting

{{< details summary="How do I check if Root Lock is active?" >}}

A: The indicator at the top of the Dashboard immediately shows whether Root Lock is active and what mode it is in. The Dashboard appears automatically on login.

{{< /details >}}

{{< details summary="The system hangs—what's first?" >}}

A: From a physical or serial console, reboot and select **Maintenance: unseal and return to Root Lock**. The Dashboard is not launched on the maintenance kernel. Express return brings you back to the Root Lock kernel in Setup Mode, where the Dashboard shows any pending items that caused the hang.

{{< /details >}}

{{< details summary="How to clear Root Lock logs?" >}}

A: The Dashboard automatically clears the activity log (`/.hs/sys/HS_log.txt`) when all review queues are empty and Secure Script Launchers is not still pending. A maintenance reboot also clears it. There is no `hs-clear-logs` command. `ui.log`, the JSONL approval log, and the journal are not cleared by that path.

{{< /details >}}

For support email support@heartsecsuite.com.
