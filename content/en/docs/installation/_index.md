---
title: "Obtaining and Installing HeartSuite Root Lock"
weight: 20
description: "Download and installation steps for HeartSuite Root Lock."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "download"]
toc: true
type: docs
menu:
  main:
    identifier: "installation"
    weight: 20
---

**Overview**: HeartSuite Root Lock installation follows one of two paths depending on your deployment method. Both paths end at the Dashboard, where Phase 1 (System Verification) confirms that the system is ready for allowlisting.

## Cloud Path

Launch a pre-configured cloud instance (e.g., AWS AMI, GCP image). The HeartSuite Root Lock kernel is already installed and the Dashboard confirms Phase 1 is complete on first boot and appears immediately — skip ahead to the allowlisting queues.

## Local Path

Run a single install command, then reboot multiple times to build the initial allowlist of startup and shutdown programs. This path involves:

1. [Obtaining HeartSuite Root Lock](obtaining-heartsuite/) — Run the install command.
2. [Installation Part 1](installation-part1/) — Run the installer and reboot to load the kernel.
3. [Installation Part 2](installation-part2/) — Complete the System Setup steps to allowlist startup and shutdown programs.

After the final reboot cycle, the Dashboard appears and displays the Suggested Next Step to guide you into Phase 2 (Program Allowlisting).
