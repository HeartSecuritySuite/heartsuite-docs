---
title: "Introduction and Overview"
weight: 10
description: "Overview of Root Lock by HeartSuite, setup process, and system requirements."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "setup"]
type: docs
toc: true
menu:
  main:
    identifier: "introduction"
    weight: 15
---

---

*Root Lock by HeartSuite | Humans in Command*

---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel level — per program, not per user. In Lockdown, any program not on the allowlist — including malware running as root — is blocked before it can execute. The immutable seal refuses any change to the allowlist while running, including by root. Undoing Lockdown requires a reboot with physical access. See [Mode Switching and Lockdown](../mode-switching/) for the mechanism. The Dashboard guides you through a 7-phase journey from installation to Lockdown, always showing your current progress and the Suggested Next Step.

## In this section

- [Root Lock by HeartSuite Overview](heartsuite-overview/) — Core features, how it protects against malware, and the 7 phases.
- [The Setup Journey](setup-overview/) — The seven phases from installation to Lockdown, the Cloud and Local paths, and how the Dashboard guides you.
- [System Requirements](system-requirements/) — Compatible systems, kernel versions, and prerequisites.
- [Deployment Scenarios](deployment-scenarios/) — Environments and workloads where Root Lock by HeartSuite fits best, plus notes on incompatible stacks.
- [How Root Lock by HeartSuite Compares](how-it-compares/) — What Root Lock by HeartSuite replaces, what it complements, and how it can be circumvented.

For detailed installation steps, see [Installation](../installation/). Root Lock by HeartSuite supports both Cloud (pre-installed) and Local (manual install) paths — both converge at the Dashboard after Phase 1 (System Verification).
