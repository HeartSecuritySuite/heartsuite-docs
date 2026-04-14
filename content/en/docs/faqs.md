---
title: "FAQs"
weight: 105
description: "Common questions and answers for HeartSuite."
categories: ["Support"]
tags: ["heartsuite", "linux", "questions", "help", "beginner", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky"]
toc: true
type: docs
---

{{% pageinfo color="info" %}}
Quick answers to common setup, usage, and troubleshooting questions. For detailed guides, see the full documentation.
{{% /pageinfo %}}

## General

{{< details summary="How is HeartSuite different from other anti-malware solutions?" >}}

A: HeartSuite enforces security at the kernel level — not through signatures, behavior prediction, or eBPF filters that attackers routinely bypass. The HeartSuite kernel blocks any program execution, file access, or network connection that has not been explicitly approved through the Dashboard's review process. Because enforcement happens inside the kernel itself, it cannot be circumvented by any program or user, including root.

{{< /details >}}

{{< details summary="Why is kernel-level enforcement better than eBPF or agent-based security?" >}}

A: Many security products — including Falco, Cilium Tetragon, and CrowdStrike Falcon on Linux — rely on eBPF filters or user-space agents that run alongside programs. Malware with sufficient privileges can disable, bypass, or unload them. HeartSuite's enforcement is compiled into the kernel itself. There is no agent to kill, no filter to detach, and no module to unload. If the HeartSuite kernel is running, enforcement is active. This is the difference between a lock on the door and a guard standing next to it.

{{< /details >}}

{{< details summary="How is HeartSuite itself protected from attacks? How do I know that HeartSuite won't be targeted or compromised?" >}}

A: Lockdown makes all allowlist entries and configuration files immutable at the filesystem level, then disables the ability to change immutability flags at the kernel level. This means not even root can modify, delete, or add allowlist entries while Lockdown is active — the kernel itself prevents it. To make changes, the Dashboard's Maintenance screen (`[t]`) guides you through a 3-step process that includes booting the Non-HS kernel to remove the immutable flags. The Dashboard confirms Lockdown status after every reboot.

{{< /details >}}

{{< details summary="What are the system requirements for HeartSuite?" >}}

A: Debian 11, 12, or 13; any Ubuntu-derived distribution; Alpine Linux; or RPM-based distributions (RHEL, Fedora, CentOS, Rocky Linux, AlmaLinux, SUSE, openSUSE) — all on x86 architecture. HeartSuite ships with two HeartSuite kernel versions: 5.19 and 6.18.

{{< /details >}}

{{< details summary="How can I download HeartSuite?" >}}

A: Download the tar file from heartsecsuite.com -- wget is disabled, so use the website form.

{{< /details >}}

{{< details summary="Is technical support available for HeartSuite customers?" >}}

A: Yes. Email support@heartsecsuite.com or visit the tech support page on [heartsecsuite.com](https://heartsecsuite.com). We're happy to help.

{{< /details >}}

{{< details summary="How do I report a bug or security issue?" >}}

A: For bugs, open an issue on GitHub using the [Bug Report template](https://github.com/HeartSecuritySuite/heartsuite-core-secure/issues/new?template=bug-report.md). Include your HeartSuite version, kernel version, the Safety Banner state shown on your Dashboard, and steps to reproduce. For security vulnerabilities, do not use a public issue — email support@heartsecsuite.com for responsible disclosure.

{{< /details >}}

{{< details summary="Can HeartSuite automatically backup files?" >}}

A: Yes. Every time a file in a configured directory is modified, HeartSuite automatically creates a new versioned backup with a timestamp and file size. Only HeartSuite can access the backups — no other program, including malware running as root, can read or destroy them. Versions are never automatically deleted. Use the Dashboard's Backup screen (`[b]`) to add or remove directories, browse version history, and restore any previous version of a file.

{{< /details >}}

{{< details summary="Will HeartSuite flood me with alerts?" >}}

A: No. Most security products generate high volumes of alerts because they flag suspicious patterns — leading to alert fatigue where real threats get lost in the noise. HeartSuite only alerts on genuinely unauthorized activity: a program attempting to execute without approval, or an outbound connection to an unapproved destination. Events are deduplicated and batched in 5-minute windows, with an hourly cap on email alerts. In Secure Mode with a complete allowlist, alerts are rare — because the allowlist already covers all legitimate activity. Configure alerts through the Dashboard's Alert Settings screen (`[e]`) (email, syslog, or webhook).

{{< /details >}}

{{< details summary="What are the limitations of the 'free trial'?" >}}

A: Secure Mode and Lockdown require a subscription. Setup Mode provides insights for decisions without full protection.

{{< /details >}}

{{< details summary="I work remotely a lot; can I still access a HeartSuite server remotely?" >}}

A: Yes, HeartSuite allows remote access like SSH -- allowlist necessary programs and IPs.

{{< /details >}}

{{< details summary="What is the Dashboard?" >}}

A: The Dashboard is the primary interface for managing HeartSuite. It shows your current mode (Setup or Secure), progress through each setup phase, pending or denied event counts, and a Suggested Next Step that tells you exactly what to do next. The Safety Banner at the top confirms the current protection state at a glance. The Dashboard appears automatically on first login.

{{< /details >}}

{{< details summary="How does HeartSuite guide me through setup?" >}}

A: The Dashboard walks you through seven phases, from verifying your installation to activating full protection. Each phase focuses on one task — approving programs (`[p]`), configuring script launchers (`[l]`), approving file access (`[f]`), approving internet access (`[i]`), and setting up alerts (`[e]`). The Dashboard tracks your progress and always shows the next step. Secure Mode (full enforcement) unlocks only after all prior phases are complete.

{{< /details >}}

## Installation

{{< details summary="Once I've installed HeartSuite, can a program access files without adding the directories to the allowlist entry?" >}}

A: No. In Secure Mode, a program can only access files and directories that have been explicitly approved through the Dashboard's File Access review queue. After allowlisting a program's execution in Phase 2, you approve its file access in Phase 4 — the Dashboard shows every file the program attempted to read or write.

{{< /details >}}

{{< details summary="Why do I need to reboot multiple times during installation?" >}}

A: The HeartSuite kernel must be loaded during the installation process. Each reboot allows `hs-os-boot-setup` to capture and allowlist additional startup and shutdown programs. Skipping reboots can leave essential programs unapproved, which would cause the system to hang in Secure Mode.

{{< /details >}}

{{< details summary="If the reboot after Part 1 fails, what should I do?" >}}

A: Check GRUB settings (e.g., uncomment GRUB_DISABLE_LINUX_UUID for VMs), verify installation logs, and try recovery mode.

{{< /details >}}

{{< details summary="hs-os-boot-setup doesn't show success after many runs—what next?" >}}

A: Check the Dashboard's Suggested Next Step — it will indicate what remains. Ensure you are running as root and that you have rebooted between each run of `hs-os-boot-setup`.

{{< /details >}}

## Allowlisting

{{< details summary="A new program is being blocked in Secure Mode — what should I do?" >}}

A: In Secure Mode, any program not on the allowlist is blocked. This typically happens after installing new software or a system update that introduces programs HeartSuite has not seen before. To resolve it, select the Maintenance screen (`[t]`) from the Dashboard — it guides you through switching to Setup Mode, where the new program appears as a pending event. Approve it from the review queues, then return to Secure Mode.

{{< /details >}}

{{< details summary="Can I allowlist directories instead of files?" >}}

A: Yes. When the Dashboard's File Access review queue presents grouped events from the same directory, you can approve directory-level access rather than approving each file individually. For example, if Python reads 200 files from `/usr/lib/python3/`, the review queue groups them and lets you approve access to the entire directory at once.

{{< /details >}}

{{< details summary="How do I activate Secure Mode?" >}}

A: The Dashboard unlocks Secure Mode when all prior phases are complete and shows it as the Suggested Next Step. Activation requires typing `YES` (case-sensitive) to confirm.

{{< /details >}}

{{< details summary="How do I add network access for a program?" >}}

A: HeartSuite blocks all outbound connections by default. When a program attempts a connection, the event appears in the Dashboard's Internet Access review queue with the destination IP, reverse DNS, and program metadata. Approve the connection from there.

{{< /details >}}

## Modes and Security

{{< details summary="When should I switch to Secure Mode?" >}}

A: After the Dashboard shows all review phases complete. Take your time in Setup Mode — allow several days to a week for systemd timers, cron jobs, and infrequent services to appear in the review queues. The Dashboard's System Info Strip shows how long Setup Mode has been active (e.g., "Setup Mode — active for 3d 7h"), so you can easily track your observation period. Switching too early will block programs that have not been approved.

{{< /details >}}

{{< details summary="What is Lockdown, and when to use it?" >}}

A: Lockdown makes all allowlist entries and configuration files immutable (`chattr +i`), then disables the ability to change immutability flags at the kernel level. No user or program — including root — can modify, delete, or add allowlist entries while Lockdown is active. Use it in production after confirming all programs work correctly in Secure Mode.

{{< /details >}}

{{< details summary="How do I activate Lockdown?" >}}

A: Once Secure Mode is active and verified, activate Lockdown from the Dashboard. This requires typing `YES` (case-sensitive) to confirm.

{{< /details >}}

{{< details summary="How do I make configuration changes after entering Lockdown?" >}}

A: Select the Maintenance screen (`[t]`) from the Dashboard. It detects that Lockdown is active and guides you through a 3-step process: booting the Non-HS kernel to remove immutable flags (`[u]`), making your changes, then rebooting back to the HeartSuite kernel to review new activity and return to Secure Mode. The Dashboard resumes at the correct step after each reboot.

{{< /details >}}

{{< details summary="How do I maintain or update in Secure Mode?" >}}

A: Select the Maintenance screen (`[t]`) from the Dashboard. It detects whether Lockdown is active and guides you through the correct path — either a simple switch to Setup Mode, or a guided 3-step process across two reboots if Lockdown requires the Non-HS kernel. The Dashboard handles all steps including a pre-maintenance safety checklist.

{{< /details >}}

## Troubleshooting

{{< details summary="How do I check if HeartSuite is active?" >}}

A: The Dashboard's Safety Banner at the top of the screen immediately shows whether HeartSuite is active and what mode it is in. The Dashboard appears automatically on login.

{{< /details >}}

{{< details summary="The system hangs—what's first?" >}}

A: Reboot into a Non-HS kernel (select it from GRUB). The Dashboard resumes automatically on the Non-HS kernel and guides you through the maintenance steps. Once back on the HeartSuite kernel, the Dashboard will show any pending events that caused the hang.

{{< /details >}}

{{< details summary="How to clear HeartSuite logs?" >}}

A: The Dashboard automatically clears the activity log when all review queues are empty — no manual action is required.

{{< /details >}}

For support, visit [heartsecsuite.com](https://heartsecsuite.com) or email support@heartsecsuite.com.
