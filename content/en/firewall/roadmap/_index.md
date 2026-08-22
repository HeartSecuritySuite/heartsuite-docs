---
title: "What the firewall prototype covers today"
linkTitle: "Roadmap"
weight: 35
description: "Current Root Lock Firewall prototype scope and the development work still ahead."
categories: ["Essentials"]
tags: ["firewall", "roadmap", "prototype"]
type: docs
toc: true
---

> **Prototype**: Root Lock Firewall is under active development.

## Current capabilities

Root Lock Firewall currently includes the following as the **prototype contract** on the appliance image.

The intended observe → approve → seal path is Dashboard, Firewall Rules, Firewall Lockdown, and Maintenance. Treat the rows as that contract, not as a GA feature list. This documentation stays Prototype until that path exists on a real KVM image.

| Capability | Notes |
|---|---|
| Closed virtual appliance | QCOW2 and OVA. Console or serial first. Delivery is the closed image. |
| Host-shaped stateful filter | INPUT/OUTPUT of this box. Workload on the image. Linux netfilter, nft path. |
| Observation → approve → seal | Dashboard Firewall Rules queue. Typed `YES`. Firewall Lockdown is a paired commitment with Root Lock Lockdown; the Dashboard does not run both. |
| Read-only inventory after seal | Mutate keys absent. Maintenance is the change path. |
| HeartSuite as update authority | No public CDN or reputation fetch under seal. |
| Root Lock underneath | Execution, files, and per-program outbound IPs remain [Root Lock by HeartSuite](../../docs/) — the kernel product. |

See [Architecture and compatibility](../architecture/) for the nft-path constraint and the virtual-appliance residual.

## Planned

### Next

| Item | Notes |
|---|---|
| Demonstration roundtrip | Observation → review → seal → inventory → maintenance on a real KVM image. This documentation stays Prototype until that roundtrip exists. |
| Image as the only customer path | Laboratory install scripts remain laboratory. |

### Subsequent

| Item | Notes |
|---|---|
| Hardware appliance | Same inspection class: host-shaped stateful filter. Removes the hypervisor residual. |
| Edge SKU | FORWARD/NAT, box in front of other hosts. Changes **placement**. Inspection stays stateful host filtering unless application inspection is added later. |
| Self-rendered nftables | Candidate only. Would keep the same product class (stateful host filter) and could make the seal hashable. |

Product identity stays a sealed host-shaped stateful filter. App-ID catalogs, TLS interception, URL clouds, sandbox blades, SD-WAN, SASE, SSL-VPN concentrator, cloud firewall / FWaaS, proxy / WAF, a vendor-panel replacement, and UFW as a second manager stay outside that identity.
