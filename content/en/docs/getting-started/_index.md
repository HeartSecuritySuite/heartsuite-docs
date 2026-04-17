---
title: Getting Started
description: Quick guide to install and start using HeartSuite Core Secure.
categories: ["Essentials"]
tags: ["heartsuite", "linux", "installation", "quickstart"]
weight: 2
toc: true
type: docs
---

**Overview**: HeartSuite Core Secure runs on two paths — Cloud (pre-installed instance, Dashboard appears on first login) and Local (manual installation with multiple reboots). Both converge at the Dashboard after Phase 1.

## The 7-Phase Model

HeartSuite Core Secure guides you through seven phases:

1. **System Verification** — confirm HeartSuite Core Secure is active and in Setup Mode
2. **Program Allowlisting** — approve the programs your system needs
3. **Script Launchers** (if applicable) — configure Secure Script Launchers for interpreted scripts
4. **File Access Allowlisting** — approve file read and write access
5. **Internet Access Allowlisting** — approve internet destinations
6. **Alert Configuration** — set up at least one notification channel
7. **Secure Mode** — locked until phases 2-6 are complete

The Dashboard displays your current phase, pending counts, and a Suggested Next Step at all times.

## Cloud Path Quick Start

Users launching a pre-installed HeartSuite Core Secure cloud instance (AWS AMI, GCP image) boot directly into Setup Mode.

1. Launch your cloud instance and log in.

2. The Dashboard appears automatically on first login with a welcome message:

   ```text
   HeartSuite Core Secure is active.
   Current mode: Setup Mode — activity is logged, nothing is blocked.
   Suggested: Review 1 pending program → [p] Programs
   ```

3. The Dashboard confirms Phase 1 is complete — no manual steps required.

4. Follow the Suggested Next Step on the Dashboard to begin Phase 2: Program Allowlisting.

## Local Path Quick Start

Users installing HeartSuite Core Secure on bare-metal or custom VMs follow a longer installation sequence before reaching the Dashboard.

### Download and Install

1. Download the tar file from [heartsecsuite.com](https://heartsecsuite.com).

2. Extract and run the installer (as root):

   ```bash
   tar xvf 6.18-HeartSuite-1.6.4.tar -m
   sudo bash heartsuite-install-bundle.sh
   ```

3. Reboot, then select the HeartSuite Core Secure kernel from the GRUB menu:

   ```bash
   reboot
   ```

   At GRUB: **Advanced options for Debian GNU/Linux** → **Linux 5.19.6-HeartSuite-1.0**

   If the GRUB menu does not show the HeartSuite Core Secure kernel, run `update-grub` and reboot again. See [Installation](../installation/) for details.

### OS Boot Setup

4. After booting into the HeartSuite Core Secure kernel, the Dashboard appears on the console automatically. The **System Setup** screen opens.

   Press `[a]` to run the setup step. HeartSuite Core Secure reboots the system when the step completes — select the HeartSuite Core Secure kernel from GRUB each time and repeat until the setup screen shows **Setup Complete** (usually 3–5 cycles). This builds the initial allowlist for startup programs, preventing boot issues when Secure Mode is activated later.

### Verify and Proceed

5. Once the System Setup screen confirms completion, the Dashboard shows your current phase. From here, the Cloud Path and Local Path merge — follow the Suggested Next Step to begin allowlisting.

## Switching to Secure Mode

When phases 2-6 are complete, the Dashboard unlocks Phase 7 and shows Secure Mode activation as the Suggested Next Step. Activation requires typing `YES` (case-sensitive) to confirm. After confirmation, the Dashboard offers two reboot options:

- `[r]` **Reboot** — enforcement active, configuration remains editable
- `[l]` **Reboot + Lockdown** — enforcement active, configuration sealed with filesystem immutability

Both are valid configurations depending on your threat model. If the system does not boot correctly, reboot into the Non-HS kernel — the Dashboard resumes there and guides you through recovery.

## Next Steps

- For full allowlisting guidance: [Allowlisting](../allowlisting/)
- For alert configuration (Phase 6): [Alert Configuration](../alerts/)
- For Lockdown after Secure Mode: [Mode Switching](../mode-switching/#lockdown-securing-your-system-in-secure-mode)
- For troubleshooting: [Troubleshooting](../troubleshooting/)
