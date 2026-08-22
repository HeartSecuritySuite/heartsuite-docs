---
title: "Root Lock Firewall"
linkTitle: "Firewall (Prototype)"
description: "A closed appliance that watches real traffic on this box, lets you approve a finite allowlist, and seals it. Prototype documentation."
categories: ["Essentials"]
tags: ["firewall", "appliance", "security", "prototype", "host-path"]
toc: true
type: docs
---

---

*Root Lock Firewall | Prototype*

---

> **Prototype**: Root Lock Firewall is under active development. Documentation reflects current design intent and is subject to change.

**Overview**: An inbound port that nobody approved is open by default. Root Lock Firewall is the host-path packet filter on a closed HeartSuite appliance: observe real traffic, approve a finite allowlist, seal it.

The workload runs on the image. Packets are judged by connection state.

Execution, files, and per-program outbound destinations stay [Root Lock by HeartSuite](../docs/). Root Lock is the hardened operating system under the filter.

If execution control or per-program outbound allowlisting on an existing server is the requirement, stay with [Root Lock](../docs/) and the OS or cloud inbound control already on that host. See [Deployment scenarios](deployment-scenarios/) for fit by environment.

## Learn about Root Lock Firewall

- [Introduction and overview](introduction/) — Core concepts, the inbound and host-path problem, and how Root Lock Firewall differs from Root Lock.
- [Architecture and compatibility](architecture/) — Closed image, Linux netfilter on the nft path, and what sits under the filter.
- [Deployment scenarios](deployment-scenarios/) — Where the appliance fits, where it fits alongside Root Lock, and where a campus NGFW still belongs.
- [How Root Lock Firewall compares](how-it-compares/) — Host-shaped sealed allowlist versus campus NGFW blades, and the complementary tools for each gap.
- [Recent firewall campaigns](examples/) — What Cisco and Fortinet incidents in 2024–2026 depended on, and which of those surfaces stay off this appliance.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers Root Lock Firewall prototype. Root Lock remains the shipped kernel product; its inbound language is unchanged.*
