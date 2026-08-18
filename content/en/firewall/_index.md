---
title: "Root Lock Firewall"
linkTitle: "Firewall (Preview)"
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

An inbound port that nobody approved is open by default on a general-purpose server. Scanners find it. Login services see unsolicited attempts.

The operating system will accept a connection on any listening socket unless a packet filter refuses it first.

Root Lock Firewall is that packet filter, delivered as a closed virtual appliance. It watches real traffic on this box, you approve a finite allowlist, and Firewall Lockdown seals what you approved.

Packets are judged by connection state. The workload runs on the image.

The appliance is not an NGFW, not a proxy, not a cloud firewall service, and not an inline box you place in front of another server.

Root Lock Firewall does not decide which programs may execute, which files they may read or write, or which outbound destinations each program may reach. Those are [Root Lock by HeartSuite](../docs/)'s domain.

Packets this box sends and receives are still this filter. Root Lock sits under the firewall as the hardened operating system. It is not itself a firewall.

If the requirement is execution control or per-program outbound allowlisting on an existing server, Root Lock Firewall is not the right fit on its own. See [Deployment scenarios](deployment-scenarios/) for fit and non-fit by environment.

## Learn about Root Lock Firewall

- [Introduction and overview](introduction/) — Core concepts, the inbound and host-path problem, and how Root Lock Firewall differs from Root Lock.
- [Architecture and compatibility](architecture/) — Closed image, Linux netfilter on the nft path, and what sits under the filter.
- [Deployment scenarios](deployment-scenarios/) — Where the appliance fits, where it fits alongside Root Lock, and where it does not apply.
- [How Root Lock Firewall compares](how-it-compares/) — What it is not, what it complements, and why it sits beside a campus NGFW rather than replacing one.
- [Recent firewall campaigns](examples/) — What Cisco and Fortinet incidents in 2024–2026 depended on, and which of those surfaces this appliance is designed not to ship.
- [Roadmap](roadmap/) — Current prototype scope and planned development.

## About this documentation

*Covers Root Lock Firewall prototype. Root Lock remains the shipped kernel product; its inbound language is unchanged.*
