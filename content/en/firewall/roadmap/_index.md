---
title: "What the firewall prototype covers today"
linkTitle: "Roadmap"
weight: 35
description: "Current Root Lock Firewall prototype scope, what is intentionally not in the image, and the development work still ahead."
categories: ["Essentials"]
tags: ["firewall", "roadmap", "prototype"]
type: docs
toc: true
---

> **Prototype**: Root Lock Firewall is under active development.

## Current capabilities

Root Lock Firewall currently includes the following as the **prototype contract** on the appliance image. The observe → approve → seal path exists in the current TUI (Dashboard, Firewall Rules, Firewall Lockdown, Maintenance). Treat the rows as that contract, not as a GA feature list. This documentation stays Preview until the proud KVM roundtrip exists.

| Capability | Notes |
|---|---|
| Closed virtual appliance | QCOW2 and OVA. Console or serial first. Not a package on a foreign kernel. |
| Host-shaped stateful filter | INPUT/OUTPUT of this box. Workload on the image. Linux netfilter, nft path. |
| Observation → approve → seal | Dashboard Firewall Rules queue. Typed `YES`. Firewall Lockdown is a paired commitment with Root Lock Lockdown; the Dashboard does not run both. |
| Read-only inventory after seal | Mutate keys absent. Maintenance is the change path. |
| HeartSuite as update authority | No public CDN or reputation fetch under seal. |
| Root Lock underneath | Execution, files, and per-program outbound IPs remain the kernel product. |

See [Architecture and compatibility](../architecture/) for the nft-path constraint and the virtual-appliance residual.

## Planned

### Next

| Item | Notes |
|---|---|
| Proud demonstration roundtrip | Observation → review → seal → inventory → maintenance on a real KVM image. This documentation stays Preview until that roundtrip exists. |
| Image as the only customer path | Laboratory install scripts remain laboratory. |

### Subsequent

| Item | Notes |
|---|---|
| Hardware appliance | Same inspection class. Removes the hypervisor residual. Still not an NGFW. |
| Edge SKU | FORWARD/NAT, box in front of other hosts. Changes **placement**, not inspection, unless application inspection is added — and application inspection is not currently planned as identity. |
| Self-rendered nftables | Candidate only. Would keep the same product class (stateful host filter) and could make the seal hashable. Not committed. |

Items that are **not** on this roadmap as product identity: App-ID catalogs, TLS interception, URL clouds, sandbox blades, SD-WAN, SASE, SSL-VPN concentrator, cloud firewall / FWaaS, proxy / WAF, a drop-in vendor-panel replacement, UFW as a second manager.
