---
title: "Root Lock by HeartSuite"
linkTitle: "Documentation"
weight: 10
description: "Complete guide for installing and configuring Root Lock by HeartSuite."
---

---

*Root Lock by HeartSuite | Humans in Command*

---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel level — per program, not per user. In Lockdown, anything not on the allowlist — including malware running as root — is blocked before it can act. Lockdown seals the allowlist — the kernel refuses any change to it while running, including by root. Undoing Lockdown requires a reboot with physical access. See [Mode Switching and Lockdown](docs/mode-switching/) for the mechanism. The Dashboard guides you through a 7-phase setup journey, from system verification to Lockdown activation.

Root Lock by HeartSuite supports two paths: **Cloud** (pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers — the Dashboard appears on first login) and **Local** (manual installation with a guided setup across several reboots). Both paths converge at the Dashboard after Phase 1 (System Verification).

## Learn About Root Lock by HeartSuite

- [Roadmap](docs/roadmap/) — Development timeline and upcoming features.
- [Introduction and Overview](docs/introduction/) — Overview, setup process, Dashboard guidance, and requirements.
- [Deployment Scenarios](docs/introduction/deployment-scenarios/) — Where Root Lock by HeartSuite fits best, and where it doesn't.
- [How Root Lock by HeartSuite Compares](docs/introduction/how-it-compares/) — What Root Lock by HeartSuite replaces (Falco, AppArmor, gVisor, EDR on the enforcement dimension), what it complements (SIEM, NDR, VA), and how it can be circumvented.
- [Allowlisting Programs](docs/allowlisting/) — How to approve programs and their file and network permissions using the review queues.
- [Mode Switching and Lockdown](docs/mode-switching/) — Setup Mode and Lockdown.

## Get Started

- [Quick Start](docs/getting-started/) — Install, allowlist, and switch modes.
- [Obtaining and Installing](docs/installation/) — Download and setup steps.
- [Verifying Installation](docs/verification/) — Confirm activation and basic configuration via the Dashboard.

## Use and Manage

- [Network and Remote Access](docs/network/) — Configure network permissions.
- [Script Launchers](docs/script-launchers/) — Secure interpreted script execution.
- [Alert Settings](docs/alerts/) — Set up push notifications for blocks and state changes (Phase 6, required for Lockdown).
- [SIEM and Fleet Integration](docs/alerts/siem-integration/) — Connect to Splunk, Elastic, and other central tools at fleet scale via syslog, webhook, and status JSON.
- [Central Policy Management and External Control](docs/alerts/central-policy-management/) — Drive policy from Ansible, Terraform, ServiceNow, GitOps repositories, and custom automation. HeartSuite is designed to be driven by your existing control planes.
- [Maintenance](docs/maintenance/) — Protecting during maintenance, file backup and versioning, and cache adjustment.

## Troubleshoot and Reference

- [Troubleshooting and Logs](docs/troubleshooting/) — Common issues and solutions.
- [FAQs](docs/faqs/) — Answers to frequent questions.
- [Appendices](docs/appendices/) — List of included tools.
- [Subscription](docs/licensing/) — Activate your subscription for Lockdown.

## Also in This Documentation

- [HeartSuite Joint File System (HJFS)](hjfs/) — Prototype filesystem-based security layer. Enforces path-level access control on standard kernels where the HS kernel is not available.

For support email support@heartsecsuite.com.
