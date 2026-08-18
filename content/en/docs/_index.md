---
title: "Root Lock by HeartSuite Documentation"
linkTitle: "Documentation"
weight: 10
description: "Complete guide for installing and configuring Root Lock by HeartSuite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "security", "overview", "guide"]
toc: true
type: docs
---

---

*Root Lock by HeartSuite | Humans in Command*

---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel, per program, including as root.

Root Lock supports two paths: 

**Cloud** (pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers — the Dashboard appears on first login) and **Local** (manual installation with a guided setup across several reboots). Both paths converge at the Dashboard after initial setup (System Verification). Logs from the process are visible via the provider serial console.

Root Lock supports two setup paths. Both arrive at the Dashboard after initial setup.

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers. The Dashboard appears on first login.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Manual installation with a guided setup across several reboots.
{{< /choice-card >}}
{{< /choice-pane >}}

Root Lock fits production servers, regulated workstations, build and CI infrastructure, and AI agent sandboxes. Hosts that run Docker, containerd, Podman, or local eBPF tooling need the maintenance kernel. See [Deployment Scenarios](introduction/deployment-scenarios/).

## Introduction and concepts

- [Introduction and Overview](introduction/) — Overview, setup process, Dashboard guidance, and requirements.
- [Deployment Scenarios](introduction/deployment-scenarios/) — Where Root Lock fits best, and where it doesn't.
- [How Root Lock Compares](introduction/how-it-compares/) — What Root Lock replaces (Falco, AppArmor, gVisor, EDR on the enforcement dimension), what it complements (SIEM, NDR, VA), and how it can be circumvented.
- [Allowlisting Programs](allowlisting/) — How to approve programs and their file and network permissions using the review queues.
- [Mode Switching and Lockdown](mode-switching/) — Setup Mode and Lockdown.

## Get started

Start with [Quick Start](getting-started/) — it covers both paths (Cloud and Local) and links each step in order: prerequisites, download, install, verify, and allowlist.

The pages below are the individual steps, linked from Quick Start:

- [Obtaining and Installing Root Lock](installation/) — Download and setup steps (Local Path).
- [Verifying Installation](verification/) — Confirm initial setup is complete in the Dashboard.

## Use and manage

- [Network and Remote Access](network/) — Configure network permissions.
- [Script Launchers](script-launchers/) — Secure interpreted script execution.
- [Alert Settings](alerts/) — Set up push notifications for blocks and state changes.
- [SIEM and Fleet Integration](alerts/siem-integration/) — Connect to Splunk, Elastic, PagerDuty, and other tools at fleet scale (syslog, webhook, status JSON).
- [Central Policy Management and External Control](alerts/central-policy-management/) — Drive allowlist policy from Ansible, Terraform, ServiceNow, GitOps, and custom automation.
- [Maintenance](maintenance/) — Protecting during maintenance, file backup and versioning, and cache adjustment.

## Troubleshoot and reference

- [Troubleshooting and Logs](troubleshooting/) — Common issues and solutions.
- [FAQs](faqs/) — Answers to frequent questions.
- [Kernel Security Transparency](security/) — CVE status and Not Affected rationale for the Root Lock kernel.
- [Kernel Hardening](kernel-hardening/) — Objective measurements, procurement guidance, and the [Enterprise Adoption Guide](kernel-hardening/enterprise-adoption-guide/) for regulated environments.
- [Appendices](appendices/) — List of included tools.

## Subscription and support

- [Subscription](licensing/) — Activate your subscription for Lockdown.
- For updates or help, visit [heartsecsuite.com](https://heartsecsuite.com).

## Ready to get started?

**Already have a subscription?** Follow the [Quick Start](getting-started/) — the Dashboard guides you from there.

**Evaluating?** Cloud instances and the Local Path package are available at [heartsecsuite.com](https://heartsecsuite.com).

## Also in this documentation

- [HeartSuite Joint File System (HJFS)](../hjfs/) — Prototype. Per-program file isolation on a standard unmodified kernel.
- [Root Lock Firewall](../firewall/) — Prototype. Inbound and host-path filter for a closed HeartSuite appliance.

---

*About this Documentation*: Covers Root Lock v1.6.4.
