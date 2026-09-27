---
title: "HeartSuite Firewall"
linkTitle: "Firewall (Prototype)"
description: "A closed appliance that watches real traffic on this box, lets you approve a finite allowlist, and seals it. Prototype documentation."
categories: ["Essentials"]
tags: ["firewall", "appliance", "security", "prototype", "host-path"]
toc: true
type: docs
---

---

*HeartSuite Firewall | Prototype*

---

> **Prototype**: HeartSuite Firewall is under active development. Documentation reflects current design intent and is subject to change.

**Overview**: An inbound port that nobody approved is open by default. HeartSuite Firewall is the packet filter for traffic to and from a closed HeartSuite appliance: you observe real traffic, approve a finite allowlist, and seal it. The workload runs on the appliance image itself, and the filter judges packets by connection state.

[Root Lock by HeartSuite](../rootlock/) is the hardened operating system under the filter, so execution, file access, and per-program outbound destinations stay under Root Lock's control.

If execution control or per-program outbound allowlisting on an existing server is the requirement, stay with [Root Lock](../rootlock/) and the OS or cloud inbound control already on that host. See [Deployment scenarios](deployment-scenarios/) for fit by environment.

## Learn about HeartSuite Firewall

- [Introduction and overview](introduction/) — Core concepts, the inbound and host-path problem, and how HeartSuite Firewall differs from Root Lock.
- [Architecture and compatibility](architecture/) — Closed image, Linux netfilter on the nft path, and what sits under the filter.
- [Deployment scenarios](deployment-scenarios/) — Where the appliance fits, where it fits alongside Root Lock, and where a campus NGFW still belongs.
- [How HeartSuite Firewall compares](how-it-compares/) — Host-shaped sealed allowlist versus campus NGFW blades, and the complementary tools for each gap.
- [Recent firewall campaigns](examples/) — What Cisco and Fortinet incidents in 2024–2026 depended on, and which of those surfaces stay off this appliance.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers the HeartSuite Firewall prototype. Root Lock remains the shipped kernel product, and what the Root Lock pages say about inbound traffic still applies to it.*
