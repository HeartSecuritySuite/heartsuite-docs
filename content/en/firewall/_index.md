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

Root Lock Firewall does not decide which programs may execute, which files they may read or write, or which outbound destinations each program may reach. Those are [Root Lock by HeartSuite](../docs/)'s domain. Root Lock sits under the filter as the hardened operating system. It is not itself a firewall.

If execution control or per-program outbound allowlisting on an existing server is the requirement, this appliance is not the right fit on its own. See [Deployment scenarios](deployment-scenarios/) for fit and non-fit by environment.

## Learn about Root Lock Firewall

- [Introduction and overview](introduction/) — Core concepts, the inbound and host-path problem, and how Root Lock Firewall differs from Root Lock.
- [Architecture and compatibility](architecture/) — Closed image, Linux netfilter on the nft path, and what sits under the filter.
- [Deployment scenarios](deployment-scenarios/) — Where the appliance fits, where it fits alongside Root Lock, and where it does not apply.
- [How Root Lock Firewall compares](how-it-compares/) — What it is not, what it complements, and why it sits beside a campus NGFW rather than replacing one.
- [Recent firewall campaigns](examples/) — What Cisco and Fortinet incidents in 2024–2026 depended on, and which of those surfaces this appliance is designed not to ship.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers Root Lock Firewall prototype. Root Lock remains the shipped kernel product; its inbound language is unchanged.*
