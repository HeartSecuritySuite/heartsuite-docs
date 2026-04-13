

---
title: "FAQs"
weight: 105
description: "Common questions and answers for HeartSuite."
categories: ["Support"]
tags: ["heartsuite", "linux", "questions", "help", "beginner"]
toc: true
type: docs
---

# Frequently Asked Questions

{{% pageinfo color="info" %}}
Quick answers to common setup, usage, and troubleshooting questions. For detailed guides, see the full documentation.
{{% /pageinfo %}}

## General

{{< details summary="How is HeartSuite different from other anti-malware solutions?" >}}

A: HeartSuite uses an allowlist to prevent unauthorized program execution and restrict file/network access through its review tools on the dashboard, unlike signature-based or behavior prediction tools that attackers often bypass.

{{< /details >}}

{{< details summary="How is HeartSuite itself protected from attacks? How do I know that HeartSuite won't be targeted or compromised?" >}}

A: Lockdown protects the integrity of allowlist entries and settings—once active, it requires rebooting to an alternate kernel for any modifications, ensuring tamper-proof protection. The dashboard shows your current status after every reboot.

{{< /details >}}

{{< details summary="What are the system requirements for HeartSuite?" >}}

A: Debian 11 or Ubuntu-compatible Linux on x86 architecture. A modified Linux 5.19.6 kernel is included.

{{< /details >}}

{{< details summary="How can I download HeartSuite?" >}}

A: Download the tar file from heartsecsuite.com—wget is disabled, so use the website form.

{{< /details >}}

{{< details summary="Is technical support available for HeartSuite customers?" >}}

A: Yes, visit the tech support page on heartsecsuite.com for details.

{{< /details >}}

{{< details summary="Can HeartSuite automatically backup files?" >}}

A: Yes, it backs up files in configured directories (e.g., /home) on changes—use `hs-backup-config-manager` to manage.

{{< /details >}}

{{< details summary="What are the limitations of the 'free trial'?" >}}

A: Security (Secure) Mode and Lockdown require a license. Monitor (Setup) Mode provides insights for decisions without full protection.

{{< /details >}}

{{< details summary="I work remotely a lot; can I still access a HeartSuite server remotely?" >}}

A: Yes, HeartSuite allows remote access like SSH—allowlist necessary programs and IPs.

{{< /details >}}

## Installation

{{< details summary="Once I’ve installed HeartSuite, can a program access files without adding the directories to the allowlist entry?" >}}

A: No, you must add directories or files using the dedicated review tools (for programs, files, or network) from the dashboard.

{{< /details >}}

{{< details summary="Why do I need to reboot multiple times during installation?" >}}

A: To load the modified kernel as part of the setup process—failure to do so can cause hangs.

{{< /details >}}

{{< details summary="If the reboot after Part 1 fails, what should I do?" >}}

A: Check GRUB settings (e.g., uncomment GRUB_DISABLE_LINUX_UUID for VMs), verify installation logs, and try recovery mode.

{{< /details >}}

{{< details summary="The setup script doesn't show success after many runs—what next?" >}}

A: Review and approve using the program review tool (or equivalent) from the dashboard, ensure root access, and follow the next step it suggests.

{{< /details >}}

## Allowlisting

{{< details summary="Why does HeartSuite block a program I just allowlisted?" >}}

A: You may need to add file, directory, or network permissions. Use the review tools from the dashboard after running the program for pending events.

{{< /details >}}

{{< details summary="Can I allowlist directories instead of files?" >}}

A: Yes, for broad access—use the appropriate review queue from the Dashboard. Directories are often safer than individual files.

{{< /details >}}

{{< details summary="How do I activate Secure Mode?" >}}

A: Use hs-activate-secure-mode (via the dashboard) after completing allowlisting in the process.

{{< /details >}}

{{< details summary="How do I add network access for a program?" >}}

A: Use the network review tool from the dashboard to allowlist specific IPs—HeartSuite blocks all remote connections by default.

{{< /details >}}

## Modes and Security

{{< details summary="When should I switch to Secure mode?" >}}

A: After completing all reviews in the process to avoid boot hangs. Use Setup Mode for testing and adding permissions.

{{< /details >}}

{{< details summary="What is lockdown, and when to use it?" >}}

A: Lockdown freezes settings in Secure mode for tamper-proofing. Use in production after confirming everything works.

{{< /details >}}

{{< details summary="How do I activate Lockdown?" >}}

A: Run the `HS_lockdown.sh` script after confirming Secure mode works.

{{< /details >}}

{{< details summary="How do I make configuration changes after entering Lockdown mode?" >}}

A: Reboot to an alternate kernel (disables lockdown), make changes, then reactivate Secure and Lockdown.

{{< /details >}}

{{< details summary="How do I maintain or update in Secure mode?" >}}

A: Boot alternate kernel to disable lockdown, make changes, then switch back to Secure and relock.

{{< /details >}}

## Troubleshooting

{{< details summary="How do I check if HeartSuite is active?" >}}

A: Access `hs-dashboard` for immediate verification of activation, current mode (Setup or Secure), and status.

{{< /details >}}

{{< details summary="The system hangs—what's first?" >}}

A: Reboot into recovery or alternate kernel, switch to Setup Mode if possible, and use the dashboard review tools for pending events.

{{< /details >}}

{{< details summary="How to clear HeartSuite logs?" >}}

A: Follow the dashboard guidance for log management.

{{< /details >}}

For support, visit [heartsecsuite.com](https://heartsecsuite.com).