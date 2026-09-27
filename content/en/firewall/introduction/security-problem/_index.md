---
title: "A listener will accept a stranger by default"
linkTitle: "The security problem"
weight: 1
description: "Inbound default-accept is a different OS assumption from Root Lock's outbound allowlist. How HeartSuite Firewall addresses that hole."
categories: ["Essentials"]
tags: ["firewall", "security", "inbound", "design", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A process that is listening will accept a connection from anywhere the routing table can reach, unless a packet filter refuses the packet first.

## Two different defaults

Root Lock by HeartSuite starts from one Unix inheritance: a program that can run may open files and make outbound connections as the user who launched it.

HeartSuite Firewall starts from the other: a listening process accepts connections from any routable address unless a packet filter refuses them first.

Those are independent controls. Approving `93.184.216.34` for `/usr/bin/curl` does not close port 22. Closing port 22 does not stop `curl` from calling an address you never reviewed.

## What inbound default-accept enables

### 1. Unsolicited reachability

Any service that binds a port is reachable from every address that can route to the host. Installing the service rarely meant "the entire internet," yet scanners, credential stuffing, and exploit kits treat that reachability as their starting condition.

### 2. Login and management planes on the filter itself

Campus and branch firewalls accumulated a second job: they became the remote-access concentrator and the administrative website. The packet filter then has to defend its own web VPN, SSO broker, and management GUI.

Incidents in 2024–2026 on Cisco Secure Firewall and FortiOS followed that surface. See [Recent firewall campaigns](../../examples/).

### 3. Rules nobody can still explain

Stateful policy that is never observed, reviewed, and reduced becomes an any-any rule with exceptions stacked on top, so the filter is "on" but nobody knows what it allows.

Extra tools then appear to find which rules still matter.

## What another NGFW blade answers

Application catalogs, TLS interception, URL clouds, and sandbox subscriptions answer one question: what is inside a flow you already decided to accept. Each of those blades adds policy surface, plus a management and update plane that has to stay reachable.

HeartSuite Firewall answers a different question: which inbound sockets on this box a human approved, and whether that set is sealed. It leaves payload inspection to those specialist tools, keeps inspection stateful, and ships as a closed image that you administer from the Dashboard on the console or serial console.

## What Root Lock already covers

Under Lockdown, [Root Lock](../../../rootlock/network/) blocks outbound connections to destinations that are not on a program's allowlist, including from processes running as root. The kernel enforces that per program; inbound port policy is HeartSuite Firewall's job.

At Lockdown, Root Lock itself records only minimal inbound rules: SSH scope and accept-only permits for named services. Observing real traffic, reviewing an allowlist for this box, and sealing it with Firewall Lockdown are what HeartSuite Firewall adds.

The result is a smaller remotely reachable surface. A port you approved still accepts the traffic its rule allows, a seal that is too wide stays that wide until you narrow it through Maintenance, and the hypervisor console stays inside the trust boundary. See [Protection limits](../limits/).
