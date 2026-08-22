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

Root Lock Firewall is the host-shaped stateful packet filter on a closed HeartSuite appliance. [Root Lock by HeartSuite](../../../docs/) is the hardened OS under it. You receive an image.

The Dashboard shows traffic as it happens. You approve a finite allowlist for this box's inbound and outbound path. Firewall Lockdown seals that set.

Packets are judged by connection state on Linux netfilter's nft path. Execution, file access, and per-program outbound destinations remain Root Lock's domain.

## What you receive

You receive a **virtual appliance** (QCOW2 or OVA). Hardware follows later, after real deployments, and keeps the same inspection class.

The image is closed:

- A custom Root Lock kernel is already the operating system.
- The packet filter is already installed and constrained by that kernel.
- You reach the box on the console or serial console. There is no public administrative SSH by default, and no Docker runtime.
- HeartSuite is the update authority. Rules and reputation stay off a public CDN under seal.

Delivery is the closed image. Install scripts that appear in development trees are for laboratory layer installs on a test guest. They remain laboratory.

## What the filter decides

Root Lock Firewall is a **host-shaped stateful firewall**.

- **Host-shaped.** It filters traffic to and from *this* box. The workload runs on the image.
- **Stateful.** Allow and deny follow connection state, not a stateless access list alone.
- **Literal addresses.** Critical rules use IP addresses, not hostnames. DNS is not the enforcement mechanism.

Inspection stays connection state on the sealed allowlist. Application payloads, TLS termination for classification, and URL or sandbox clouds stay outside product identity.

## Observation, approval, and Firewall Lockdown

You use the same observe → approve → seal path Root Lock already uses for programs and destinations:

**observe what is real → approve what is necessary → seal what was earned.**

| State | Trust | What you see |
|---|---|---|
| Observing | Traffic is logged so you can teach the allowlist. Rules are not fully enforced. | The system strip reports traffic observation. Pending events accumulate on Firewall Rules. |
| Reviewing | You decide. The Dashboard does not auto-approve. | Each event shows service, port, origin, and attempts. Approve creates an allowlist entry. Skip defers. |
| Firewall Lockdown applied | Trust is withdrawn from anything that is not on the sealed set. | After you type `YES` and reboot the host, mutate keys are absent. The Dashboard does not reboot the host. The strip is quiet when the seal and Root Lock Lockdown are both in place. |
| Maintenance | You deliberately reopen the box to change policy. | Maintenance is the only supported change path. You re-observe if needed, then seal again. |

Silence on the strip means Firewall Lockdown and Root Lock Lockdown are both in place.

Firewall Lockdown and Root Lock Lockdown are paired on the appliance. Firewall Lockdown seals the packet allowlist. Root Lock Lockdown seals the kernel allowlist (programs, files, outbound destinations).

Changing either after seal requires the maintenance path.

## What stays on Root Lock

| Control | Product |
|---|---|
| May this program execute? | Root Lock |
| Which files may it read or write? | Root Lock |
| Which outbound IP may this program reach? | Root Lock |
| Which packets may this box accept or send? | Root Lock Firewall |
| Is the chosen packet allowlist sealed? | Root Lock Firewall (Firewall Lockdown) |

See [Network and Remote Access](../../../docs/network/) for Root Lock's outbound queue, and [Protection limits](../limits/) for residuals.
