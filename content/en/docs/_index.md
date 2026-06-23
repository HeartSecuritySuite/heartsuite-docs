---
title: "Root Lock by HeartSuite Documentation"
linkTitle: "Documentation"
weight: 10
description: "Complete guide for installing and configuring Root Lock by HeartSuite security suite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "security", "overview", "guide"]
toc: true
type: docs
---

---

*Root Lock by HeartSuite | Humans in Command*

---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel level — per program, not per user. In Lockdown, anything not on the allowlist — including malware running as root — is blocked before it can act. The immutable seal refuses any change to the allowlist while running, including by root. Undoing Lockdown requires a reboot with physical access. See [Mode Switching and Lockdown](mode-switching/) for the mechanism. The Dashboard guides you through a 7-phase setup journey, from system verification to Lockdown activation.

Root Lock by HeartSuite supports two paths: **Cloud** (pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers — the Dashboard appears on first login) and **Local** (manual installation with a guided setup across several reboots). Both paths converge at the Dashboard after Phase 1 (System Verification).

Root Lock by HeartSuite is a strong fit for production servers, regulated workstations, build and CI infrastructure, AI agent sandboxes, and container hosts. Hosts where eBPF-based tooling must run locally require a maintenance kernel (no Root Lock by HeartSuite loaded).

## Introduction and concepts

- [Introduction and Overview](introduction/) — Overview, setup process, Dashboard guidance, and requirements.
- [Deployment Scenarios](introduction/deployment-scenarios/) — Where Root Lock by HeartSuite fits best, and where it doesn't.
- [How Root Lock by HeartSuite Compares](introduction/how-it-compares/) — What Root Lock by HeartSuite replaces (Falco, AppArmor, gVisor, EDR on the enforcement dimension), what it complements (SIEM, NDR, VA), and how it can be circumvented.
- [Allowlisting Programs](allowlisting/) — How to approve programs and their file and network permissions using the review queues.
- [Mode Switching and Lockdown](mode-switching/) — Setup Mode and Lockdown.

## Get started

Start with [Quick Start](getting-started/) — it covers both paths (Cloud and Local) and links each step in order: prerequisites, download, install, verify, and allowlist.

The pages below are the individual steps, linked from Quick Start:

- [Obtaining and Installing Root Lock by HeartSuite](installation/) — Download and setup steps (Local Path).
- [Verifying Installation](verification/) — Confirm Phase 1 is complete in the Dashboard.

## Use and manage

- [Network and Remote Access](network/) — Configure network permissions.
- [Script Launchers](script-launchers/) — Secure interpreted script execution.
- [Alert Settings](alerts/) — Set up push notifications for blocks and state changes (Phase 6, required for Lockdown).
- [SIEM and Fleet Integration](alerts/siem-integration/) — Connect to Splunk, Elastic, PagerDuty, and other tools at fleet scale (syslog, webhook, status JSON). The recommended path for teams that do not want per-host TUI toil for routine monitoring.
- [Central Policy Management and External Control](alerts/central-policy-management/) — Drive allowlist policy from Ansible, Terraform, ServiceNow, GitOps, and custom automation. Consume status.json, JSONL approval logs, syslog streams, and webhooks for central visibility. The scale path for enterprises that own policy in their own control planes.
- [Maintenance](maintenance/) — Protecting during maintenance, file backup and versioning, and cache adjustment.

## Troubleshoot and reference

- [Troubleshooting and Logs](troubleshooting/) — Common issues and solutions.
- [FAQs](faqs/) — Answers to frequent questions.
- [Kernel Security Transparency](security/) — CVE status and Not Affected rationale for the Root Lock by HeartSuite kernel.
- [Kernel Hardening](kernel-hardening/) — Objective measurements, procurement guidance, and the [Enterprise Adoption Guide](kernel-hardening/enterprise-adoption-guide/) for regulated environments.
- [Appendices](appendices/) — List of included tools.

## Subscription and support

- [Subscription](licensing/) — Activate your subscription for Lockdown.
- For updates or help, visit [heartsecsuite.com](https://heartsecsuite.com).

## Ready to get started?

**Already have a subscription?** Follow the [Quick Start](getting-started/) — the Dashboard guides you from there.

**Evaluating?** Cloud instances and the Local Path package are available at [heartsecsuite.com](https://heartsecsuite.com).

## Also in this documentation

- [HeartSuite Joint File System (HJFS)](../hjfs/) — Prototype filesystem-based security layer. Enforces path-level access control on standard kernels where the Root Lock by HeartSuite kernel is not available.

---

*About this Documentation*: Covers Root Lock by HeartSuite v1.6.4.
