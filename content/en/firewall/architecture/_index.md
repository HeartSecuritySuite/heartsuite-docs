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

That shape is required by the kernel underneath. Root Lock by HeartSuite is a custom Linux kernel. Delivery is the closed image on that kernel.

Laboratory install scripts exist for layer-installing the prototype on a throwaway guest. They remain laboratory.

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

Root Lock's own packet path — SSH scope and accept-only service permits at Lockdown — remains thin. See [Lockdown](../../docs/lockdown/) for that Root Lock path.

## Linux netfilter on the nft path

The Root Lock kernel carries nftables. The older iptables table is absent. Public documentation therefore describes the data path as **Linux netfilter, nft path**. Older iptables tools on this image load no table, so a rule you thought you applied does nothing.

A userspace stateful-inspection engine drives the filter. The Dashboard writes allowlist entries. Engine internals, a vendor web panel, and a cluster GUI stay off the glass.

HeartSuite is the update authority for that engine. External reputation and geo downloads are off under seal.

The engine is still userspace software. Root Lock is what constrains which binaries may run and which addresses they may call. That residual is why the two layers ship together on the image.

## What the seal actually is

Firewall Lockdown makes the chosen allowlist immutable on the running appliance and is applied together with Root Lock Lockdown. After reboot, the Dashboard treats the ruleset as read-only.

The seal is immutability of the set you chose. Reduce through Maintenance.

Completeness of correspondence between the live filter table and the review queue is an engineering property under test. If a later engine can make the seal hashable, the product class stays a stateful host filter.

## No administrative web plane

You administer the box from the console TUI. The appliance is designed without:

- a public administrative SSH listener by default
- a VPN web server as product identity
- cloud single sign-on into the filter
- vendor-static administrative accounts

The host filter's image baseline can still include the SSH port and the usual workload ports, open to any source. That is a port shape, not a running listener.

Starting a listener on those ports is reachable from any source until you narrow the baseline through Maintenance. See [Protection limits](../introduction/limits/).

Those omissions are the architectural answer to the campaign class in [Recent firewall campaigns](../examples/). They shrink the remote attack surface of the filter. Someone who holds the hypervisor console or the rack key still reaches the box.

## The virtual appliance residual

A virtual appliance runs on someone else's hypervisor. Control of that hypervisor is control of the disk and of the serial console. A hostile hypervisor owns the disk.

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
| Shared-kernel containers on this image | This image is a closed appliance. A container engine stays off the image. See [Deployment Scenarios](../../docs/introduction/deployment-scenarios/) on Root Lock for the separate container-host kernel product. |
| Windows or macOS | The filter and the kernel are Linux. |
