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

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel level — per program, not per user. In Lockdown, malware running as root is blocked if it is not on the allowlist. The kernel blocks it before it can execute. Root cannot change the allowlist while the machine is running. Undoing Lockdown requires a reboot with physical access. See [Mode Switching and Lockdown](../mode-switching/) for the activation prep (per-panel actions/opt-outs including `[g]` tool restriction, read-only inventory) and mechanism. The Dashboard guides you through a 7-phase journey from installation to Lockdown, always showing your current progress and the Suggested Next Step.

## In this section

- [Root Lock Overview](heartsuite-overview/) — Core features, how it protects against malware, and the 7 phases.
- [The Setup Journey](setup-overview/) — The seven phases from installation to Lockdown, the Cloud and Local paths, and how the Dashboard guides you.
- [System Requirements](system-requirements/) — Compatible systems, kernel versions, and prerequisites.
- [Deployment Scenarios](deployment-scenarios/) — Environments and workloads where Root Lock fits best, plus notes on incompatible stacks.
- [How Root Lock Compares](how-it-compares/) — What Root Lock replaces, what it complements, and how it can be circumvented.

For detailed installation steps, see [Installation](../installation/). Root Lock supports both Cloud (pre-installed) and Local (manual install) paths — both converge at the Dashboard after Phase 1 (System Verification).
