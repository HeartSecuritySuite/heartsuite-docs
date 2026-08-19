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

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel, per program, including as root.

In Lockdown, anything not on the allowlist is blocked before it can act. Root cannot change the allowlist while the machine is running. [Lockdown](../mode-switching/) covers activation.

## In this section

- [Root Lock Overview](heartsuite-overview/) — Core features, how it protects against malware, and the setup checklist.
- [The Setup Journey](setup-overview/) — Initial setup, then the Dashboard checklist from installation to Lockdown, the Cloud and Local paths, and how the Dashboard guides you.
- [System Requirements](system-requirements/) — Compatible systems, kernel versions, and prerequisites.
- [Deployment Scenarios](deployment-scenarios/) — Environments and workloads where Root Lock fits best, plus notes on incompatible stacks.
- [How Root Lock Compares](how-it-compares/) — What Root Lock replaces, what it complements, and how it can be circumvented.

For detailed installation steps, see [Installation](../installation/). [Getting Started](../getting-started/) covers Cloud Path and Local Path. Both converge at the Dashboard after initial setup.
