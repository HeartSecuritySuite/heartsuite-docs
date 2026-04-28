---
title: "HeartSuite Core Secure"
linkTitle: "Documentation"
weight: 10
description: "Complete guide for installing and configuring HeartSuite Core Secure."
---

**Overview**: Every attack does three things: run a program, access files, make a network connection. HeartSuite Core Secure enforces default-deny on all three at the kernel level — per program, not per user. In Secure Mode, anything not on the allowlist — including malware running as root — is blocked before it can act. Lockdown seals the allowlist — the kernel refuses any change to it while running, including by root. Undoing Lockdown requires a reboot with physical access. See [Mode Switching and Lockdown](docs/mode-switching/) for the mechanism. The Dashboard guides you through a 7-phase setup journey, from system verification to Secure Mode activation.

HeartSuite Core Secure supports two paths: **Cloud** (pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers — the Dashboard appears on first login) and **Local** (manual installation with a guided setup across several reboots). Both paths converge at the Dashboard after Phase 1 (System Verification).

## Learn About HeartSuite Core Secure

- [Introduction and Overview](docs/introduction/) — Overview, setup process, Dashboard guidance, and requirements.
- [Deployment Scenarios](docs/introduction/deployment-scenarios/) — Where HeartSuite Core Secure fits best, and where it doesn't.
- [How HeartSuite Core Secure Compares](docs/introduction/how-it-compares/) — What HeartSuite Core Secure replaces (Falco, AppArmor, gVisor, EDR on the enforcement dimension), what it complements (SIEM, NDR, VA), and how it can be circumvented.
- [Allowlisting Programs](docs/allowlisting/) — How to approve programs and their file and network permissions using the review queues.
- [Mode Switching and Lockdown](docs/mode-switching/) — Setup Mode, Secure Mode, and Lockdown.

## Get Started

- [Quick Start](docs/getting-started/) — Install, allowlist, and switch modes.
- [Obtaining and Installing](docs/installation/) — Download and setup steps.
- [Verifying Installation](docs/verification/) — Confirm activation and basic configuration via the Dashboard.

## Use and Manage

- [Network and Remote Access](docs/network/) — Configure network permissions.
- [Script Launchers](docs/script-launchers/) — Secure interpreted script execution.
- [Alert Settings](docs/alerts/) — Set up push notifications for blocks and state changes (Phase 6, required for Secure Mode).
- [Maintenance](docs/maintenance/) — Protecting during maintenance, file backup and versioning, and cache adjustment.

## Troubleshoot and Reference

- [Troubleshooting and Logs](docs/troubleshooting/) — Common issues and solutions.
- [FAQs](docs/faqs/) — Answers to frequent questions.
- [Appendices](docs/appendices/) — List of included tools.
- [Subscription](docs/licensing/) — Activate your subscription for Secure Mode.

For support email support@heartsecsuite.com.
