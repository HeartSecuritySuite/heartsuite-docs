---
title: "Where the packet boundary holds — and where it does not"
linkTitle: "Protection limits"
weight: 3
description: "Root Lock Firewall's packet boundary, what it does not see on the host, and which tool to put beside it for those gaps."
categories: ["Essentials"]
tags: ["firewall", "security", "limits", "inbound", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A listening service accepts packets from anywhere the routing table can reach, unless a filter refuses them. Root Lock Firewall refuses inbound and this-host path traffic that is not on the sealed allowlist — including traffic aimed at services running as root.

An attacker who uses a port you approved is constrained by that rule, not stopped at the application.

---

## An attacker uses a service you already approved

**The scenario.** You approved inbound HTTPS to the workload on this image. An attacker exploits a bug in that web application over the allowed port.

**What Root Lock Firewall enforces.** Packets to ports that are not on the allowlist still fail. Scanners probing closed ports still fail. A listener on a port that is not already in the sealed allowlist is not an approved path.

**What Root Lock Firewall does not cover.** Content on an allowed port is outside a stateful packet filter. A listener that binds a port the image already left open (including baseline ports open to any source) is still that approved path.

A WAF, application hardening, and [Root Lock by HeartSuite](../../../docs/) (what that process may execute, read, write, and call outbound) address the blast radius inside the approved service. This is a deliberate division of layers, not a gap.

---

## Outbound destinations per program

**The scenario.** A compromised approved program opens an outbound connection to an address you never reviewed.

**What Root Lock Firewall enforces.** The host path is still subject to the sealed host filter. That is not the same as per-program outbound policy.

**What Root Lock Firewall does not cover.** Which *program* may reach which *literal IP* is Root Lock's domain. See [Network and Remote Access](../../../docs/network/).

---

## Traffic through this box to another server

**The scenario.** You want to place the appliance in front of a backup server or a subnet and publish NAT or forwarded ports.

**What Root Lock Firewall enforces.** v1 filters INPUT and OUTPUT of *this* image. The workload is meant to run on the image.

**What Root Lock Firewall does not cover.** Sitting in front of other hosts (FORWARD, NAT as a product surface) is not v1. The sealed allowlist of *this* image still holds. See [Deployment scenarios](../../deployment-scenarios/).

---

## Application identification, TLS interception, and URL clouds

**The scenario.** A buyer expects App-ID, TLS man-in-the-middle, URL categories, sandbox detonation, or SD-WAN on the same appliance.

**What Root Lock Firewall enforces.** Connection state and the allowlist you sealed.

**What Root Lock Firewall does not cover.** Those blades are refused as product identity. They are the policy surface Root Lock Firewall is designed not to become. Keep the specialist tool for App-ID, TLS interception, and URL clouds. The sealed host allowlist on this image still holds.

---

## Physical access and the console

**The scenario.** Someone who can reach the serial console or the hypervisor console boots Maintenance and removes the seal.

**What Root Lock Firewall enforces.** Under Firewall Lockdown, an attacker who already has remote root cannot rewrite the sealed allowlist. Change goes through Maintenance on the console.

**What Root Lock Firewall does not cover.** Physical presence, a cloud serial console, or control of the hypervisor under a virtual appliance returns the box to whoever holds that path. Restrict console access in the hypervisor or cloud IAM.

A later hardware appliance removes the hypervisor residual; it does not remove physical presence. See [Architecture and compatibility](../../architecture/#the-virtual-appliance-residual).

---

## An allowlist that is too wide

**The scenario.** Observation ran on a noisy network, a broad rule was approved to "make it work," or the image already opened ports to any source, and then that set was sealed.

**What Root Lock Firewall enforces.** The sealed set, including the wide rule and any baseline ports that were never a discovery product. Critical rules use IP addresses, not hostnames. DNS is not the enforcement mechanism.

**What Root Lock Firewall does not cover.** Seal makes a chosen ruleset immutable. It does not prove the ruleset is minimal.

Inventory advisories can flag breadth. They cannot unsay an approval. Re-enter Maintenance, reduce, and seal again.

---

## Complementary tools

| Gap | Complementary control |
|---|---|
| Per-program execution, files, and outbound IPs | [Root Lock](../../../docs/) |
| Application payloads on an allowed port | WAF or application hardening — not this product |
| Ports the image left open to any source | Not produced by observation. Seal keeps them. Narrow through Maintenance. |
| Hostnames in a rule | Not enforcement. Use literal IP addresses. |
| Fleet correlation and incident response | SIEM / NDR (forward structured events; do not expect a SOC console here) |
| Volumetric DDoS in front of the host | Provider or cloud perimeter — a host filter is the wrong layer |
| Publishing other hosts through this box | Not v1; keep the existing edge firewall or wait for an edge SKU |
| Encryption at rest | Disk encryption on the image (LUKS or the hypervisor's disk encryption) |
| Who may sit at the console | Hypervisor / cloud IAM / locked rack |

For how this sits next to campus NGFWs and cloud security groups, see [How Root Lock Firewall compares](../../how-it-compares/).
