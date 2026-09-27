---
title: "Introduction and Overview"
weight: 10
description: "Overview of Root Lock by HeartSuite, setup process, and system requirements."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "setup"]
type: docs
aliases:
  - /docs/introduction/
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

In Lockdown, anything not on the allowlist is blocked before it can act. By design, remote root has no intended path to change the sealed allowlist while the machine is running. Unsealing means booting the maintenance kernel from a physical or serial console. sshd is stopped when Lockdown seals, unless you chose to leave it running before the seal, and SSH cannot lift the seal. After the unseal, SSH is how you work in Setup Mode. [Lockdown](../lockdown/) covers activation. [Circumvention and recovery](how-it-compares/#circumvention-and-recovery) covers residual risk.

## In this section

- [Root Lock Overview](heartsuite-overview/) — Core features, how it protects against malware, and the setup checklist.
- [The Setup Journey](setup-overview/) — Initial setup, then the Dashboard checklist from installation to Lockdown, Cloud Path and Local Path, and how the Dashboard guides you.
- [System Requirements](system-requirements/) — Compatible systems, kernel versions, and prerequisites.
- [Deployment Scenarios](deployment-scenarios/) — Environments and workloads where Root Lock fits best, plus notes on incompatible stacks.
- [How Root Lock Compares](how-it-compares/) — What Root Lock replaces, what it complements, and how it can be circumvented.
- [Security as Economics](security-as-economics/) — Which scanner findings can wait for the standard change window, and what that does to attacker cost.

For detailed installation steps, see [Installation](../installation/). [Getting Started](../getting-started/) covers Cloud Path and Local Path. On a single host they converge at the Dashboard after initial setup. Both paths install one machine at a time; to apply allowlist policy across many hosts from Ansible, Terraform, or GitOps, see [Central Policy](../alerts/central-policy-management/).
