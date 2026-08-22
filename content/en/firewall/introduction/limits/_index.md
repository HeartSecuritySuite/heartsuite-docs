---
title: "Where the packet boundary holds"
linkTitle: "Protection limits"
weight: 3
description: "Root Lock Firewall's packet boundary, residuals, and which tool to put beside it for those gaps."
categories: ["Essentials"]
tags: ["firewall", "security", "limits", "inbound", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A listening service accepts packets from anywhere the routing table can reach, unless a filter refuses them. Root Lock Firewall refuses inbound and this-host path traffic that is not on the sealed allowlist — including traffic aimed at services running as root.

An attacker who uses a port you approved is constrained by that rule. Application content on that port stays with a WAF and Root Lock.

---

## An attacker uses a service you already approved

**The scenario.** You approved inbound HTTPS to the workload on this image. An attacker exploits a bug in that web application over the allowed port.

**What Root Lock Firewall does.** Packets to ports that are not on the allowlist still fail. Scanners probing closed ports still fail. A listener on a port that is not already in the sealed allowlist is not an approved path.

**What it does not cover.** If the attacker uses a port you already approved, this particular gate does not apply to application content on that port. Packets to ports off the allowlist still fail. A listener that binds a port the image already left open (including baseline ports open to any source) is still that approved path.

A WAF, application hardening, and [Root Lock by HeartSuite](../../../docs/) (what that process may execute, read, write, and call outbound) address the blast radius inside the approved service.

---

## Outbound destinations per program

**The scenario.** A compromised approved program opens an outbound connection to an address you never reviewed.

**What Root Lock Firewall does.** The host path is still subject to the sealed host filter. That is independent of per-program outbound policy.

**What it does not cover.** If a compromised approved program opens an outbound connection to an address you never reviewed, this particular gate does not apply to per-program destinations. The sealed host filter on this image still holds. Which *program* may reach which *literal IP* stays [Root Lock](../../../docs/network/).

---

## Traffic through this box to another server

**The scenario.** You want to place the appliance in front of a backup server or a subnet and publish NAT or forwarded ports.

**What Root Lock Firewall does.** v1 filters INPUT and OUTPUT of *this* image. The workload is meant to run on the image.

**What it does not cover.** If you want this box in front of other hosts, this particular gate does not apply to FORWARD or NAT. v1 still filters INPUT and OUTPUT of *this* image. See [Deployment scenarios](../../deployment-scenarios/).

---

## Application identification, TLS interception, and URL clouds

**The scenario.** A buyer expects App-ID, TLS man-in-the-middle, URL categories, sandbox detonation, or SD-WAN on the same appliance.

**What Root Lock Firewall does.** Connection state and the allowlist you sealed.

**What it does not cover.** If the requirement is App-ID, TLS interception, or URL clouds, this particular gate does not apply to those blades. The sealed host allowlist on this image still holds. Keep the specialist tool for that inspection.

---

## Physical access and the console

**The scenario.** Someone who can reach the serial console or the hypervisor console boots Maintenance and removes the seal.

**What Root Lock Firewall does.** Under Firewall Lockdown, an attacker who already has remote root cannot rewrite the sealed allowlist. Change goes through Maintenance on the console.

**What it does not cover.** If someone holds the serial console, a cloud serial console, or the hypervisor, this particular gate does not apply to that path. The sealed allowlist still holds against remote rewrite. Restrict console access in the hypervisor or cloud IAM.

A later hardware appliance removes the hypervisor residual. Physical presence stays a console path. See [Architecture and compatibility](../../architecture/#the-virtual-appliance-residual).

---

## An allowlist that is too wide

**The scenario.** Observation ran on a noisy network, a broad rule was approved to "make it work," or the image already opened ports to any source, and then that set was sealed.

**What Root Lock Firewall does.** The sealed set, including the wide rule and any baseline ports that were never a discovery product. Critical rules use IP addresses, not hostnames. DNS is not the enforcement mechanism.

**What it does not cover.** If a broad rule was approved and sealed, this particular gate does not unsay that approval. The sealed set still holds until you unseal it. Inventory advisories can flag breadth. Re-enter Maintenance, reduce, and seal again.

---

## Complementary tools

| Gap | Complementary control |
|---|---|
| Per-program execution, files, and outbound IPs | [Root Lock](../../../docs/) |
| Application payloads on an allowed port | WAF or application hardening |
| Ports the image left open to any source | Not produced by observation. Seal keeps them. Narrow through Maintenance. |
| Hostnames in a rule | Use literal IP addresses. DNS stays out of enforcement. |
| Fleet correlation and incident response | SIEM / NDR (forward structured events; the SOC console stays there) |
| Volumetric DDoS in front of the host | Provider or cloud perimeter — a host filter is the wrong layer |
| Publishing other hosts through this box | Later; keep the existing edge firewall or wait for an edge SKU |
| Encryption at rest | Disk encryption on the image (LUKS or the hypervisor's disk encryption) |
| Who may sit at the console | Hypervisor / cloud IAM / locked rack |

For how this sits next to campus NGFWs and cloud security groups, see [How Root Lock Firewall compares](../../how-it-compares/).
