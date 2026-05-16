---
title: Getting Started
description: Choose your setup path and begin installation.
categories: ["Essentials"]
tags: ["heartsuite", "linux", "installation", "quickstart"]
weight: 15
toc: true
type: docs
---

**Overview**: HeartSuite Core Secure runs on two paths — Cloud (pre-installed instance, Dashboard appears on first login) and Local (manual installation with multiple reboots). Both converge at the Dashboard after Phase 1.

## Before you begin

Check [Before You Begin](before-you-begin/) for system requirements and prerequisites, then follow your path below.

## Cloud Path

Launch a pre-installed HeartSuite Core Secure cloud instance (AWS AMI, GCP image). No download or kernel installation required — boot directly into Setup Mode and the Dashboard appears on first login. Follow the Suggested Next Step to begin Phase 2.

## Local Path

Install HeartSuite Core Secure on bare-metal or a custom VM:

1. **[Obtaining HeartSuite Core Secure](../installation/obtaining-heartsuite/)** — download the installer from heartsecsuite.com.
2. **[Installation Part 1](../installation/installation-part1/)** — verify the download, run the installer, and reboot into the HeartSuite Core Secure kernel.
3. **[Installation Part 2](../installation/installation-part2/)** — complete the System Setup through multiple reboot cycles until the Dashboard confirms Phase 1 is complete.
4. **[Verifying Installation](../verification/)** — confirm Phase 1 is complete in the Dashboard.

Once Phase 1 is complete, both paths merge — the Dashboard shows your current phase and the Suggested Next Step directs you to begin allowlisting.
