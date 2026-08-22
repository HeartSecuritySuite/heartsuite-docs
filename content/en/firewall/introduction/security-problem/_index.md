---
title: "A listener will accept a stranger by default"
linkTitle: "The security problem"
weight: 1
description: "Inbound default-accept is a different OS assumption from Root Lock's outbound allowlist. How Root Lock Firewall addresses that hole."
categories: ["Essentials"]
tags: ["firewall", "security", "inbound", "design", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A process that is listening will accept a connection from anywhere the routing table can reach, unless a packet filter refuses the packet first.

## Two different defaults

Root Lock by HeartSuite starts from one Unix inheritance: a program that can run may open files and make outbound connections as the user who launched it.

Root Lock Firewall starts from the other: a process that is listening will accept a connection from anywhere the routing table can reach, unless a packet filter refuses the packet first.

Those are independent controls. Approving `93.184.216.34` for `/usr/bin/curl` does not close port 22. Closing port 22 does not stop `curl` from calling an address you never reviewed.

## What inbound default-accept enables

### 1. Unsolicited reachability

Any service that binds a port is reachable from every address that can route to the host. Installing the service rarely meant "the entire internet."

Scanners, credential stuffing, and exploit kits treat that reachability as the starting condition.

### 2. Login and management planes on the filter itself

Campus and branch firewalls accumulated a second job: they became the remote-access concentrator and the administrative website. The packet filter then has to defend its own web VPN, SSO broker, and management GUI.

Incidents in 2024–2026 on Cisco Secure Firewall and FortiOS followed that surface. See [Recent firewall campaigns](../../examples/).

### 3. Rules nobody can still explain

Stateful policy that is never observed, reviewed, and reduced becomes an any-any rule with exceptions stacked on top. The filter is "on." The allowlist is not known.

Extra tools then appear to find which rules still matter.

## What another NGFW blade answers

Application catalogs, TLS interception, URL clouds, and sandbox subscriptions answer a different question: what is inside a flow you already decided to accept. Root Lock Firewall answers which inbound sockets on this box a human approved, and whether that set is sealed.

They add policy surface. They also add a management and update plane that has to stay reachable.

Root Lock Firewall addresses the first question and refuses the second as product identity. Inspection stays stateful. Delivery is a closed image. You reach the Dashboard on the console or serial console.

## What Root Lock already covers

[Root Lock](../../../docs/network/) already blocks outbound connections to destinations that are not on a program's allowlist, including from processes running as root. That is kernel grant policy. Inbound port policy is Root Lock Firewall.

Root Lock Lockdown can record a thin inbound permit for SSH scope and named services. That path is accept-only. Observation of real traffic, a reviewed allowlist of this box, and Firewall Lockdown are Root Lock Firewall.

Root Lock Firewall is the product that takes inbound (and this host's path) as its job.

That is a smaller remote plane. An approved port stays an approved port. A wide seal stays a wide seal. The hypervisor console stays in the trust boundary. See [Protection limits](../limits/).
