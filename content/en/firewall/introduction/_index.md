---
title: "Inbound default-accept is the other Unix inheritance"
linkTitle: "Introduction"
weight: 10
description: "Root Lock allowlists per-program outbound. Root Lock Firewall is the host-path stateful filter for a closed appliance."
categories: ["Essentials"]
tags: ["firewall", "overview", "concepts", "prototype"]
type: docs
toc: true
---

---

*Root Lock Firewall | Prototype*

---

**Overview**: A listening service on a Linux host accepts inbound connections unless a packet filter refuses them. Root Lock Firewall is that filter on a closed HeartSuite appliance: observe real traffic, approve a finite allowlist, seal it.

Root Lock controls outbound destinations per program, at the kernel, using literal IP addresses. The two products address different layers and are designed to be used together on the appliance image.

## In this section

- [The security problem Root Lock Firewall solves](security-problem/) — Why inbound default-accept is a different OS assumption from Root Lock's outbound allowlist.
- [Root Lock Firewall overview](firewall-overview/) — Closed appliance, stateful inspection, observation through Firewall Lockdown, and what stays with Root Lock.
- [Walkthrough](walkthrough/) — The intended Dashboard journey from first boot to a sealed ruleset.
- [Protection limits](limits/) — Where the packet boundary holds, and what to use alongside it.
