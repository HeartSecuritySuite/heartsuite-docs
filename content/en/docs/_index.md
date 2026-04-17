---
title: "HeartSuite Core Secure Documentation"
linkTitle: "Documentation"
weight: 10
description: "Complete guide for installing and configuring HeartSuite Core Secure security suite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "security", "overview", "guide"]
toc: true
type: docs
---

**Overview**: HeartSuite Core Secure enforces a default-deny policy at the kernel level. Three things are controlled for every program on the system: whether it can execute, which files it can read or write, and which IP addresses it can connect to. Anything not on the allowlist — including malware running as root — is blocked before it can act. Lockdown seals the allowlist so that not even root can change it at runtime. The Dashboard guides you through a 7-phase setup journey, from system verification to Secure Mode activation.

HeartSuite Core Secure supports two paths: **Cloud** (pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers — the Dashboard appears on first login) and **Local** (manual installation with a guided setup across several reboots). Both paths converge at the Dashboard after Phase 1 (System Verification).

HeartSuite Core Secure is a strong fit for production servers, regulated workstations, build and CI infrastructure, and AI agent sandboxes. It is not a fit for container hosts that depend on OverlayFS, or for hosts where eBPF-based tooling must run locally.

## Introduction and Concepts

- [Introduction and Overview](introduction/) — Overview, setup process, Dashboard guidance, and requirements.
- [Deployment Scenarios](introduction/deployment-scenarios/) — Where HeartSuite Core Secure fits best, and where it doesn't.
- [How HeartSuite Core Secure Compares](introduction/how-it-compares/) — What HeartSuite Core Secure replaces (Falco, AppArmor, gVisor, EDR on the enforcement dimension), what it complements (SIEM, NDR, VA), and how it can be circumvented.
- [Allowlisting Programs](allowlisting/) — How to approve programs and their file and network permissions using the review queues.
- [Mode Switching and Lockdown](mode-switching/) — Setup Mode, Secure Mode, and Lockdown.

## Get Started

- [Quick Start](getting-started/) — Install, allowlist, and switch modes.
- [Obtaining and Installing HeartSuite Core Secure](installation/) — Download and setup steps.
- [Verifying Installation](verification/) — Confirm activation and basic configuration via the Dashboard.

## Use and Manage

- [Network and Remote Access](network/) — Configure network permissions.
- [Script Launchers](script-launchers/) — Secure interpreted script execution.
- [Alert Configuration](alerts/) — Set up push notifications for blocks and state changes (Phase 6, required for Secure Mode).
- [Maintenance](maintenance/) — Caches, backups, and configuration management.

## Troubleshoot and Reference

- [Troubleshooting and Logs](troubleshooting/) — Common issues and solutions.
- [FAQs](faqs/) — Answers to frequent questions.
- [Appendices](appendices/) — List of included tools.

## Subscription and Support

- [Subscription](licensing/) — Activate your subscription for Secure Mode.
- For updates or help, visit [heartsecsuite.com](https://heartsecsuite.com).

## Ready to get started?

**Already have a subscription?** Follow the [Quick Start](getting-started/) — the Dashboard guides you from there.

**Evaluating?** Cloud instances and the Local Path package are available at [heartsecsuite.com](https://heartsecsuite.com).

---

*About this Documentation*: Covers HeartSuite Core Secure v1.6.4.
