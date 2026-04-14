---
title: "Obtaining and Installing HeartSuite Core Secure"
weight: 20
description: "Download, installation steps, and preliminary setup for virtual machines."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "download", "beginner"]
toc: true
type: docs
menu:
  main:
    identifier: "installation"
---

**Overview**: HeartSuite Core Secure installation follows one of two paths depending on your deployment method. Both paths end at the Dashboard, where Phase 1 (System Verification) confirms that the system is ready for allowlisting.

## Cloud Path

Launch a pre-configured cloud instance (e.g., AWS AMI, GCP image). The HeartSuite Core Secure kernel is already installed and Phase 1 (System Verification) auto-completes on first boot. The Dashboard appears immediately — skip ahead to the allowlisting queues.

## Local Path

Download the HeartSuite Core Secure distribution, extract it, run the installer, and reboot multiple times to build the initial allowlist of startup and shutdown programs. This path involves:

1. [Obtaining HeartSuite Core Secure](obtaining-heartsuite/) — Download the distribution from the website.
2. [VM Preparation](vm-preparation/) — Configure GRUB settings for virtual machines on clouds.
3. [Installation Part 1](installation-part1/) — Extract, install, and reboot to load the kernel.
4. [Installation Part 2](installation-part2/) — Auto-allowlist startup programs with `hs-os-boot-setup`.

After the final reboot cycle, the Dashboard appears and displays the Suggested Next Step to guide you into Phase 2 (Program Allowlisting).
