---
title: "Where the packet boundary holds"
linkTitle: "Protection limits"
weight: 3
description: "HeartSuite Firewall's packet boundary, residuals, and which tool to put beside it for those gaps."
categories: ["Essentials"]
tags: ["firewall", "security", "limits", "inbound", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A listening service accepts packets from anywhere the routing table can reach, unless a filter refuses them. Under Firewall Lockdown, HeartSuite Firewall refuses traffic to and from this box that is not on the sealed allowlist — including traffic aimed at services running as root.

An attacker who uses a port you approved is limited to what that rule allows, and what they send over that port is for a WAF and Root Lock to constrain.

---

## An attacker uses a service you already approved

**The scenario.** You approved inbound HTTPS to the workload on this image. An attacker exploits a bug in that web application over the allowed port.

**What HeartSuite Firewall does.** Packets to ports that are not on the sealed allowlist still fail, so scanners probing closed ports get nothing, and a listener the attacker starts on a port outside the allowlist gets no inbound path.

**What it does not cover.** The filter does not judge application content on a port you approved. A listener that binds one of the ports the image already leaves open to any source is reachable too, because that port is already an approved path.

A WAF, application hardening, and [Root Lock by HeartSuite](../../../rootlock/) (what that process may execute, read, write, and call outbound) address the blast radius inside the approved service.

---

## Outbound destinations per program

**The scenario.** A compromised approved program opens an outbound connection to an address you never reviewed.

**What HeartSuite Firewall does.** The connection still has to pass the sealed host filter, which applies to traffic leaving this box independently of per-program outbound policy.

**What it does not cover.** The host filter has no per-program destination rules. Which *program* may reach which *literal IP* stays with [Root Lock](../../../rootlock/network/).

---

## Traffic through this box to another server

**The scenario.** You want to place the appliance in front of a backup server or a subnet and publish NAT or forwarded ports.

**What HeartSuite Firewall does.** v1 filters INPUT and OUTPUT of *this* image, because the workload is meant to run on the image.

**What it does not cover.** v1 has no FORWARD or NAT path, so keep the existing edge firewall in front of other hosts. See [Deployment scenarios](../../deployment-scenarios/).

---

## Application identification, TLS interception, and URL clouds

**The scenario.** A buyer expects App-ID, TLS man-in-the-middle, URL categories, sandbox detonation, or SD-WAN on the same appliance.

**What HeartSuite Firewall does.** It filters on connection state against the allowlist you sealed.

**What it does not cover.** App-ID, TLS interception, and URL clouds are outside the product, so keep the specialist tool for that inspection.

---

## Physical access and the console

**The scenario.** Someone who can reach the serial console or the hypervisor console boots Maintenance and removes the seal.

**What HeartSuite Firewall does.** Under Firewall Lockdown, an attacker who already has remote root cannot rewrite the sealed allowlist. Change goes through Maintenance on the console.

**What it does not cover.** Whoever holds the serial console, a cloud serial console, or the hypervisor can boot Maintenance and change the allowlist, so restrict console access in the hypervisor or cloud IAM.

A later hardware appliance takes the hypervisor out of that path, while physical presence at the box remains a console path. See [Architecture and compatibility](../../architecture/#the-virtual-appliance-residual).

---

## An allowlist that is too wide

**The scenario.** Observation ran on a noisy network, a broad rule was approved to "make it work," or the image already opened ports to any source, and then that set was sealed.

**What HeartSuite Firewall does.** It enforces exactly the sealed set, including the wide rule and any baseline ports that observation never produced.

**What it does not cover.** Sealing does not narrow an approval: a broad rule stays in force until you unseal. Inventory advisories can flag breadth, so re-enter Maintenance, reduce the rule, and seal again.

---

## Complementary tools

| Gap | Complementary control |
|---|---|
| Per-program execution, files, and outbound IPs | [Root Lock](../../../rootlock/) |
| Application payloads on an allowed port | WAF or application hardening |
| Ports the image left open to any source | Not produced by observation. Seal keeps them. Narrow through Maintenance. |
| Hostnames in a rule | Use literal IP addresses. DNS stays out of enforcement. |
| Fleet correlation and incident response | SIEM / NDR (forward structured events; the SOC console stays there) |
| Volumetric DDoS in front of the host | Provider or cloud perimeter — a host filter is the wrong layer |
| Publishing other hosts through this box | Later; keep the existing edge firewall or wait for an edge SKU |
| Encryption at rest | Disk encryption on the image (LUKS or the hypervisor's disk encryption) |
| Who may sit at the console | Hypervisor / cloud IAM / locked rack |

For how this sits next to campus NGFWs and cloud security groups, see [How HeartSuite Firewall compares](../../how-it-compares/).
