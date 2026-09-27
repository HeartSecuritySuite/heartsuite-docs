---
title: "What sits under a closed firewall image"
linkTitle: "Architecture"
weight: 20
description: "Root Lock Firewall is a closed image: a stateful host filter on Linux netfilter (nft). What is in the box."
categories: ["Essentials"]
tags: ["firewall", "architecture", "netfilter", "nftables", "kernel", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: Root Lock Firewall is a stateful host filter on a closed HeartSuite image. You boot the image, open the Dashboard on the console or serial console, observe, approve, and seal.

The image already carries a custom kernel, a userspace stateful-inspection engine HeartSuite updates, a console TUI, and host-integrity grants. You do not allowlist those programs.

The kernel underneath requires that shape: Root Lock by HeartSuite is a custom Linux kernel, so the firewall is delivered as a closed image built on it.

Install scripts that layer the prototype onto a throwaway guest exist for laboratory use only.

## Two layers, one box

```text
Workload on this image
        │
        ▼
Root Lock Firewall     stateful allowlist for this host's path
        │
        ▼
Root Lock programs, files, per-program outbound IPs
                        plus the kernel the filter is allowed to run on
```

Root Lock Firewall owns the host packet filter. Root Lock owns what may execute and which literal outbound addresses each program may use.

On this image there is one filter owner. A second manager (UFW, firewalld, or a hand-maintained ruleset beside the product) is a composition hazard.

Root Lock's own packet rules stay minimal: SSH scope and accept-only service permits at Lockdown. See [Lockdown](../../rootlock/lockdown/) for that Root Lock path.

## Linux netfilter on the nft path

The Root Lock kernel carries nftables. The older iptables table is absent. Public documentation therefore describes the data path as **Linux netfilter, nft path**. Older iptables tools on this image load no table, so a rule you thought you applied does nothing.

A userspace stateful-inspection engine drives the filter. The Dashboard writes allowlist entries. Engine internals, a vendor web panel, and a cluster GUI do not appear in the Dashboard.

HeartSuite is the update authority for that engine. Under the seal, the engine does not download external reputation or geolocation feeds.

The engine is still userspace software, which is why the two layers ship together on the image: Root Lock constrains which binaries may run and which addresses they may call.

## What the seal actually is

Firewall Lockdown makes the chosen allowlist immutable on the running appliance and is applied together with Root Lock Lockdown. After reboot, the Dashboard treats the ruleset as read-only.

The seal makes the set you chose immutable. To narrow it, go through Maintenance.

Completeness of correspondence between the live filter table and the review queue is an engineering property under test. If a later engine can make the seal hashable, the product class stays a stateful host filter.

## No administrative web plane

You administer the box from the console TUI. The appliance is designed without:

- a public administrative SSH listener by default
- a VPN web server as product identity
- cloud single sign-on into the filter
- vendor-static administrative accounts

The host filter's image baseline can still open the SSH port and the usual workload ports to any source. An open port is not a running listener, but a listener you start on one of those ports is reachable from any source until you narrow the baseline through Maintenance. See [Protection limits](../introduction/limits/).

Those omissions are the architectural answer to the campaign class in [Recent firewall campaigns](../examples/). They shrink the remote attack surface of the filter. Someone who holds the hypervisor console or the rack key still reaches the box.

## The virtual appliance residual

A virtual appliance runs on someone else's hypervisor. Control of that hypervisor is control of the disk and of the serial console.

Two deliveries, same inspection class:

- a virtual appliance on a hypervisor you trust
- a hardware appliance for environments where the hypervisor is not trusted

Until hardware ships, treat hypervisor and cloud serial-console IAM as part of the product's trust boundary. The sealed allowlist on this image still holds.

## Compatibility notes

| Environment | Notes |
|---|---|
| HeartSuite appliance image (QCOW2, OVA) | The supported delivery. Console or serial first. |
| Root Lock kernel on a general-purpose server you built | That is Root Lock. Root Lock Firewall is the closed appliance image. |
| Stock Debian or Ubuntu kernel | Delivery is the closed image. The nft-only constraint and the closed image assume the Root Lock kernel. |
| Cloud IaaS (AWS, Google Cloud, Azure, and others) | The virtual appliance may *run* there. Provider controls (security groups, Network Firewall, Azure Firewall) stay the outer layer if you use them. |
| Inline / NAT / HA pair | Later. See [Deployment scenarios](../deployment-scenarios/). |
| Shared-kernel containers on this image | This image is a closed appliance, so a container engine stays off it. Docker, containerd, Kubernetes, and CRI-O are not a supported workload on the Root Lock kernel either; run the workload in a Firecracker or Kata microVM instead. See [Deployment Scenarios](../../rootlock/introduction/deployment-scenarios/#container-hosts) and [Containers and microVMs](../../rootlock/introduction/containers-and-microvms/). |
| Windows or macOS | The filter and the kernel are Linux. |
