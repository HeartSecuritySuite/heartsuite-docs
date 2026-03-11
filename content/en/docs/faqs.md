

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

A: HeartSuite uses Program Whitelist (APOs) to prevent unauthorized program execution and restrict file/network access, unlike signature-based or behavior prediction tools that attackers often bypass.

{{< /details >}}

{{< details summary="How is HeartSuite itself protected from attacks? How do I know that HeartSuite won't be targeted or compromised?" >}}

A: Lockdown prevents changes to whitelist entrys and settings—once active, it requires rebooting to an alternate kernel for any modifications, ensuring tamper-proof protection.

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

A: Yes, HeartSuite allows remote access like SSH—whitelist necessary programs and IPs.

{{< /details >}}

## Installation

{{< details summary="Once I’ve installed HeartSuite, can a program access files without adding the directories to the whitelist entry?" >}}

A: No, you must add directories or files using `hs-whitelist-manager` (Program Whitelist is an older term for whitelist entries).

{{< /details >}}

{{< details summary="Why do I need to reboot multiple times during installation?" >}}

A: To load the modified kernel and generate logs for auto-whitelisting essential programs—failure to do so can cause hangs.

{{< /details >}}

{{< details summary="If the reboot after Part 1 fails, what should I do?" >}}

A: Check GRUB settings (e.g., uncomment GRUB_DISABLE_LINUX_UUID for VMs), verify installation logs, and try recovery mode.

{{< /details >}}

{{< details summary="The setup script doesn't show success after many runs—what next?" >}}

A: Manually whitelist missing programs using `hs-whitelist-manager`, check logs for errors, and ensure root access.

{{< /details >}}

## Whitelisting

{{< details summary="Why does HeartSuite block a program I just whitelisted?" >}}

A: You may need to add file, directory, or network permissions. Check logs after running the program for denied actions.

{{< /details >}}

{{< details summary="Can I whitelist directories instead of files?" >}}

A: Yes, for broad access—use `-d` in `hs-whitelist-manager`. Directories are often safer than individual files.

{{< /details >}}

{{< details summary="How do I activate Secure Mode?" >}}

A: Secure Mode is an older term for Secure mode—use `hs-mode-switch` off after full whitelisting to activate.

{{< /details >}}

{{< details summary="How do I add network access for a program?" >}}

A: Use `-n IP` with `hs-whitelist-manager` to whitelist specific IPs—HeartSuite blocks all remote connections by default.

{{< /details >}}

## Modes and Security

{{< details summary="When should I switch to Secure mode?" >}}

A: After fully whitelisting essential programs to avoid boot hangs. Use Setup mode for testing and adding permissions.

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

A: Run `dmesg | grep HEARTSUITE` for activation and mode messages.

{{< /details >}}

{{< details summary="The system hangs—what's first?" >}}

A: Reboot into recovery or alternate kernel, switch to Setup mode if possible, and review logs for denied actions.

{{< /details >}}

{{< details summary="How to clear HeartSuite logs?" >}}

A: As root: `/hs/sys/empty_HS_log.sh`.

{{< /details >}}

For support, visit [heartsecsuite.com](https://heartsecsuite.com).