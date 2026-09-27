---
title: "Observe real traffic, approve a list, seal it"
linkTitle: "Overview"
weight: 2
description: "Host-shaped stateful filter on a closed appliance: observe real traffic, approve a finite allowlist for this box, then seal it. Root Lock is the OS under the filter."
categories: ["Essentials"]
tags: ["firewall", "overview", "appliance", "lockdown", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A listening service on a general-purpose host accepts inbound packets unless a filter refuses them. That is the Unix default this product closes.

HeartSuite Firewall is a host-shaped stateful packet filter delivered as a closed HeartSuite appliance image, with [Root Lock by HeartSuite](../../../rootlock/) as the hardened OS under it. The Dashboard shows traffic as it happens, you approve a finite allowlist for this box's inbound and outbound path, and Firewall Lockdown seals that set.

The filter judges packets by connection state on Linux netfilter's nft path. Execution, file access, and per-program outbound destinations remain with Root Lock, the kernel under the filter.

## What you receive

You receive a **virtual appliance** (QCOW2 or OVA). Hardware follows later, after real deployments, and keeps the same inspection class.

The image is closed:

- A custom Root Lock kernel is already the operating system.
- The packet filter is already installed and constrained by that kernel.
- You reach the box on the console or serial console. There is no public administrative SSH by default, and no Docker runtime.
- HeartSuite is the update authority, so once the allowlist is sealed the filter fetches no rules or reputation data from a public CDN.

The closed image is the only delivery. Install scripts that appear in development trees layer the prototype onto a test guest for laboratory use only.

## What the filter decides

HeartSuite Firewall is a **host-shaped stateful firewall**.

- **Host-shaped.** It filters traffic to and from *this* box. The workload runs on the image.
- **Stateful.** Allow and deny follow connection state, not a stateless access list alone.
- **Literal addresses.** Critical rules use IP addresses rather than hostnames, so a DNS answer never decides what the filter allows.

Inspection is limited to connection state against the sealed allowlist. Application payload inspection, TLS termination for classification, and URL or sandbox clouds are outside the product by design; [Protection limits](../limits/#application-identification-tls-interception-and-url-clouds) names the tools that cover them.

## Observation, approval, and Firewall Lockdown

You use the same observe → approve → seal path Root Lock already uses for programs and destinations:

**observe what is real → approve what is necessary → seal what was earned.**

| State | Trust | What you see |
|---|---|---|
| Observing | Traffic is logged so you can teach the allowlist. Rules are not fully enforced. | The system strip reports traffic observation. Pending events accumulate on Firewall Rules. |
| Reviewing | You decide. The Dashboard does not auto-approve. | Each event shows service, port, origin, and attempts. Approve creates an allowlist entry. Skip defers. |
| Firewall Lockdown applied | Trust is withdrawn from anything that is not on the sealed set. | After you type `YES` and reboot the host yourself (the Dashboard does not reboot it), the keys that change rules are gone. The strip is quiet when the seal and Root Lock Lockdown are both in place. |
| Maintenance | You deliberately reopen the box to change policy. | Maintenance is the only supported change path. You re-observe if needed, then seal again. |

Firewall Lockdown and Root Lock Lockdown are paired on the appliance: Firewall Lockdown seals the packet allowlist, and Root Lock Lockdown seals the kernel allowlist (programs, files, outbound destinations). After the seal, changing either one goes through Maintenance.

## What stays on Root Lock

| Control | Product |
|---|---|
| May this program execute? | Root Lock |
| Which files may it read or write? | Root Lock |
| Which outbound IP may this program reach? | Root Lock |
| Which packets may this box accept or send? | HeartSuite Firewall |
| Is the chosen packet allowlist sealed? | HeartSuite Firewall (Firewall Lockdown) |

See [Network and Remote Access](../../../rootlock/network/) for Root Lock's outbound queue, and [Protection limits](../limits/) for what the packet boundary leaves to other tools.
