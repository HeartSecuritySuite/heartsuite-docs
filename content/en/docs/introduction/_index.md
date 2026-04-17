---
title: "Introduction and Overview"
weight: 10
description: "Overview of HeartSuite Core Secure, setup process, and system requirements."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "setup", "beginner"]
type: docs
toc: true
menu:
  main:
    identifier: "introduction"
    weight: 15
---

**Overview**: HeartSuite Core Secure enforces a default-deny policy — each program must be explicitly approved to execute, to access files, and to make network connections. Any program not on the allowlist, including malware, is blocked at the kernel level before it can execute. The Dashboard guides you through a 7-phase journey from installation to Secure Mode, always showing your current progress and the suggested next step.

## Key Topics

- [HeartSuite Core Secure Overview](heartsuite-overview/) — Core features, how it protects against malware, and the 7-phase model.
- [Setup Overview](setup-overview/) — The setup process, modes (Setup vs. Secure), and how the Dashboard guides you.
- [System Requirements](system-requirements/) — Compatible systems, kernel versions, and prerequisites.
- [Deployment Scenarios](deployment-scenarios/) — Environments and workloads where HeartSuite Core Secure fits best, plus notes on incompatible stacks.
- [How HeartSuite Core Secure Compares](how-it-compares/) — What HeartSuite Core Secure replaces, what it complements, and how it can be circumvented.

For detailed installation steps, see [Installation](../installation/). HeartSuite Core Secure supports both Cloud (pre-installed) and Local (manual install) paths — both converge at the Dashboard after Phase 1 (System Verification).
